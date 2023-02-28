clc;clear

m = csvread('事故.csv',1, 1);
r = csvread('拥堵.csv',1, 1);

times = zeros(100, 100);
imps = ones(10, 3);
for i = 1 : 100
    for j = 1 : 100
        times(i, j) = m(i, j) * r(i, j);
        sign = 1;
        for k = 2 : 10
            if imps(sign, 2) > imps(k, 3)
                sign = k;
            end
        end
        if times(i, j) > imps(sign, 3)
            imps(sign, 1) = i;
            imps(sign, 2) = j;
            imps(sign, 3) = times(i, j);
        end
    end
end