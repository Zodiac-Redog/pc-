clc;clear

%读取文件
fid = fopen('事故时间.csv', 'rt');
a = textscan(fid, '%d %d %s','Delimiter',',', 'HeaderLines',1);
fclose(fid);
M = [a{1}, a{2}, datenum(a{3})];
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
    [23	58]
    ];
ex = csvread('经验部署点.csv', 1);
for i = 1 : 32
    %(经度 * 10000 - 1201264) / 10, 列索引为(纬度 * 10000 - 301288) / 10
    ex(i, 1) = ceil((ex(i, 1) * 10000 - 1201264) / 10);
    ex(i, 2) = ceil((ex(i, 2) * 10000 - 301288) / 10);
end
avgnow = zeros(262, 1);
avgbef = zeros(262, 1);
d = zeros(262, 1);
id = 1;
count = 0;
res1 = 0;
res0 = 0;
for i = 1 : size(M, 1)
    if M(i, 3) - 737974 ~= id
        avgnow(id, 1) = (res1 / count) * 111 * 1.45 / 600 + 1;
        avgbef(id, 1) = (res0 / count) * 111 * 1.45 / 600 + 1;
        d(id, 1) = id + 737974;
        count = 0;
        id = id + 1;
        res1 = 0;
        res0 = 0;
    end
    lnow = 200;
    lbef = 200;
    for j = 1 : 32
        l1 = sqrt((double(M(i, 1)) - best(j, 1)) .^ 2 + (double(M(i, 2)) - best(j, 2)) .^ 2);
        l0 = sqrt((double(M(i, 1)) - ex(j, 1)) .^ 2 + (double(M(i, 2)) - ex(j, 2)) .^ 2);
        if l1 < lnow
            lnow = l1;
        end
        if l0 < lbef
            lbef = l0;
        end
    end
    res1 = res1 + lnow;
    res0 = res0 + lbef;
    count = count + 1;
end
avgnow(id, 1) = (res1 / count) * 111 * 1.45 / 600 + 1;
avgbef(id, 1) = (res0 / count) * 111 * 1.45 / 600 + 1;
d(id, 1) = id + 737974;
plot(d, avgnow);
datetick('x','yy-mm');
hold on
plot(d, avgbef);
hold off