clc;clear;

best = [        [75    33]
    [78    72]
    [79    74]
    [75    68]
    [81    57]
    [73    71]
    [68    49]
    [72    74]
    [65    63]
    [79    74]
    [79    74]
    [79    43]
    [73    71]
    [78    77]
    [53    63]
    [79    76]];
ex = csvread('经验部署点.csv', 1);
for i = 1 : 16
    %(经度 * 10000 - 1201264) / 10, 列索引为(纬度 * 10000 - 301288) / 10
    ex(i, 1) = ceil((ex(i, 1) * 10000 - 1201264) / 10);
    ex(i, 2) = ceil((ex(i, 2) * 10000 - 301288) / 10);
end

m = csvread('事故.csv',1,1);
r = csvread('拥堵.csv',1,1);

parentz = 0;
%r是圈体半径，默认为14.91格
rad = 14.91;
%w为权重，默认为0.6、0.4
w1 = 0.6;
w2 = 0.4;
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
disp(['优化点服务分数：',num2str(servicepop(best, maxz, m, r, rad, w1, w2)),'，覆盖率：',num2str(cover(best, m, rad, t))]);
disp(['经验点服务分数：',num2str(servicepop(ex, maxz, m, r, rad, w1, w2)),'，覆盖率：',num2str(cover(ex, m, rad, t))]);

function y = servicepop(pop, maxz, m, r, rad, w1, w2)
    score = 0;
    for i = 1 : 16
        score = score + service(pop(i, 1), pop(i, 2), m, r, rad, w1, w2);
    end
    y = score / maxz / 16 * 100;
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
            for k = 1 : 16
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