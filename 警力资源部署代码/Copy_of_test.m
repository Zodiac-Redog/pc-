clc;clear

x = 0 : 100;
y = 0 : 100;

x1 = [x(1) x(end)]';
y1 = [y(1) y(end)]';

x2 = repmat(x1, 1, length(y)-2);
x3 = repmat(x(2) : x(end-1), 2, 1);
xData = [x2 x3];

y2 = repmat(y1, 1, length(x)-2);
y3 = repmat(y(2) : y(end-1), 2, 1);
yData = [y3 y2];

h = line(xData, yData);
box on;
set(h, 'Color', 'k');
r = csvread('事故.csv',1,1);
r = r';
for i = 1 : 100
    for j = 1 : 100
        x = [0 1 1 0] + i - 1;
        y = [0 0 1 1] + j - 1;
        if r(i, j) ~= 0
            patch('xData', x, 'yData', y, 'FaceColor', 'r');
        end
    end
end
h