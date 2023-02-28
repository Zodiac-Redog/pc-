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
best = [    [79    72]
    [83    45]
    [73    74]
    [80    76]
    [53    58]
    [82    58]
    [78    77]
    [75    33]
    [51    65]
    [71    47]
    [73    67]
    [64    57]
    [63    71]
    [58    45]
    [79    74]
    [73    71]
    [55	69]
    [66	75]
    [74	78]
    [81	82]
    [55	57]
    [63	58]
    [74	68]
    [74	63]
    [79	57]
    [79	52]
    [87	68]
    [63	43]
    [74	36]
    [72	26]
    [30	81]
    [23	58]];
ex = csvread('经验部署点.csv', 1);
for i = 1 : 32
    %(经度 * 10000 - 1201264) / 10, 列索引为(纬度 * 10000 - 301288) / 10
    ex(i, 1) = ceil((ex(i, 1) * 10000 - 1201264) / 10);
    ex(i, 2) = ceil((ex(i, 2) * 10000 - 301288) / 10);
end
avgnow = zeros(10, 1);
avgbef = zeros(10, 1);
x = zeros(10, 1);
for i = 1 : 10
    lnow = 200;
    lbef = 200;
    for j = 1 : 32
        l1 = sqrt((double(imps(i, 1)) - best(j, 1)) .^ 2 + (double(imps(i, 2)) - best(j, 2)) .^ 2);
        l0 = sqrt((double(imps(i, 1)) - ex(j, 1)) .^ 2 + (double(imps(i, 2)) - ex(j, 2)) .^ 2);
        if l1 < lnow
            lnow = l1;
        end
        if l0 < lbef
            lbef = l0;
        end
    end
    avgnow(i, 1) = lnow * 111 * 1.45 / 600 + 1;
    avgbef(i, 1) = lbef * 111 * 1.45 / 600 + 1;
    x(i, 1) = i;
end
plot(x, avgnow);
hold on
plot(x, avgbef);
hold off