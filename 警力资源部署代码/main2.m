clc;clear

%读取文件
m = csvread('事故.csv',1,1);
r = csvread('拥堵.csv',1,1);

parentz = 0;
%r是圈体半径，默认为14.91格
rad = 14.91;
%w为权重，默认为0.6、0.4
w1 = 0.8;
w2 = 0.2;
%t为事故总数
t = sum(sum(m));
for i = 1 : 100
    for j = 1 : 100
        z = service(i, j, m, r, rad, w1, w2);
        if z > parentz
            parentz = z;
        end
    end
end
maxz = parentz;

%遗传算法相关参数
maxturn = 2000; %遗传代数
select_num = 200; %复制次数
crate = 0.2; %交叉概率
mrate = 0.06; %变异概率

%产生初始种群
for i = 1 : select_num
    popx = ceil(100 * rand(12, 1));
    popy = ceil(100 * rand(12, 1));
    pop( : , : , i) = [popx, popy];
end

%结果
anspop = zeros(12, 2, maxturn);
ansc = zeros(maxturn, 1);
ansz = zeros(maxturn, 1);

%遗传算法
for turn = 1 : maxturn
    %找出最大值并保存
    maxc = 1;
    popc = zeros(select_num, 1);
    popc(maxc, 1) = 3 * cover(pop( : , : , maxc), m, rad, t) + servicepop(pop( : , : , maxc), maxz, m, r, rad, w1, w2);%计算目标函数(适应度=目标函数）
    for i = 2 : select_num
        popc(i, 1) = 3 * cover(pop( : , : , i), m, rad, t) + servicepop(pop( : , : , i), maxz, m, r, rad, w1, w2);%计算目标函数
        if popc(i, 1) > popc(maxc, 1)
            maxc = i;
        end
    end
    anspop( : , : ,turn) = pop( : , : , maxc);
    ansc(turn, 1) = cover(pop( : , : , maxc), m, rad, t);
    ansz(turn, 1) = servicepop(pop( : , : , maxc), maxz, m, r, rad, w1, w2);
    disp(['第',num2str(turn),'代覆盖率为：',num2str(ansc(turn, 1)),'；服务得分为：',num2str(ansz(turn, 1))])
    
    newpop = select(pop, popc, select_num);%复制
    newpop = crossover(newpop, crate, select_num);%交叉
    pop = mutation(newpop, mrate, select_num);%变异   
end

%最大输出
mt = 1;
for i = 2 : maxturn
    if ansc(i, 1) + ansz(i, 1) > ansc(mt, 1) +ansz(mt, 1)
        mt = i;
    end
end
disp(['综合分最大为第',num2str(mt),'代，覆盖率为：',num2str(ansc(mt,1)),'%，服务得分为：',num2str(ansz(mt,1))])
disp(anspop(:,:,mt))
scatter(ansc, ansz);

%帕累托前沿
id = 1;
pac = zeros(100,1);
paz = zeros(100,1);
papop = zeros(12,2,100);
for i = 1 : maxturn
    sign = 1;
    for j = 1 : maxturn
        if ansc(j ,1) > ansc(i, 1) && ansz(j, 1) > ansz(i, 1)
            sign = 0;
            break;
        end
    end
    for j = 1 : id - 1
        if pac(j, 1) == ansc(i, 1)
            sign = 0;
        end
    end
    if sign == 1 && ansc(i, 1) >= 60 && ansz(i, 1) >= 60 
        papop(:,:,id) = anspop(:,:,i);
        pac(id, 1) = ansc(i, 1);
        paz(id, 1) = ansz(i, 1);
        id = id + 1;
    end
end

scatter(pac, paz);

function y = servicepop(pop, maxz, m, r, rad, w1, w2)
    score = 0;
    for i = 1 : 12
        score = score + service(pop(i, 1), pop(i, 2), m, r, rad, w1, w2);
    end
    y = score / maxz / 12 * 100;
end

function y = service(i, j, m, r, rad, w1, w2)
    frad = rad;
    res = 0;
    if fix(rad) ~= rad
        frad = fix(rad) + 1;
    end
    minx = max(i - frad, 1);
    maxx = min(i + frad, 100);
    miny = max(j - frad, 1);
    maxy = min(j + frad, 100);
    for a = minx : maxx
        for b = miny: maxy
            l = sqrt((a - i) .^ 2 + (b - j) .^ 2);
            if l <= rad
                res = res + w1 * r(a, b) / ( l * 111 / 600 + 1) + w2 * m (a, b);
            end
        end
    end
    y = res;
end

function y = cover(pop, m, rad, t)
    res = 0;
    for i = 1 : 100
        for j = 1 : 100
            for k = 1 : 12
                l = sqrt((pop(k, 1) - i) ^ 2 + (pop(k, 2) - j) ^ 2);
                if l < rad
                    res = res + m(i, j);
                    break;
                end
            end
        end
    end
    y = res / t * 100;
end

%复制
function y = select(pop, popc, select_num)
    tc = sum(popc);
    popc = popc ./ tc;
    popcsum = cumsum(popc);
    popnew = zeros(size(pop));
    popcnew = zeros(select_num, 2);
    new_num = sort(rand(select_num, 1));
    newid = 1;
    popid = 1;
    while newid <= select_num
        if new_num(newid, 1) <= popcsum(popid, 1)
            popcnew(newid, 1) = popc(popid, 1);
            popcnew(newid, 2) = popid;
            newid = newid + 1;
        else
            popid = popid + 1;
        end
    end
    popcnew(select_num + 1 : select_num * 2, 1) = popc( : , 1);
    for i = 1 : select_num
        popcnew(select_num + i, 2) = i;
    end
    popcnew = sortrows(popcnew, -1);
    for i = 1 : select_num
        popnew( : , : , i) = pop( : , : , popcnew(i, 2));
    end
    y = popnew;
end

%交叉
function y = crossover(pop, crate, select_num)
    newpop = zeros(12, 2, select_num);
    for i = 1 : select_num / 2
        if rand < crate
            se = sort(ceil(12 *rand(2, 1)));
            newpop(1 : se(1, 1), : , i) = pop(1 : se(1, 1), : , i);
            newpop(1 : se(1, 1), : , i + select_num / 2) = pop(1 : se(1, 1), : , i + select_num / 2);
            newpop(se(2, 1) : 12, : , i) = pop(se(2, 1) : 12, : , i);
            newpop(se(2, 1) : 12, : , i + select_num / 2) = pop(se(2, 1) : 12, : , i + select_num / 2);
            newpop(se(1, 1) : se(2, 1), : , i) = pop(se(1, 1) : se(2, 1), : , i + select_num / 2);
            newpop(se(1, 1) : se(2, 1), : , i + select_num / 2) = pop(se(1, 1) : se(2, 1), : , i);
        else
            newpop( : , : , i) = pop( : , : , i);
            newpop( : , : , i + 1) = pop( : , : , i + 1);
        end
    end
    y = newpop;
end

%变异
function y = mutation(pop, mrate, select_num)
    for i = 1 : select_num
        for j = 1 : 12
            for k = 1 : 2
                if rand < mrate
                    pop(j , k, i) = ceil(rand * 100);
                end
            end
        end
    end
    y = pop;
end