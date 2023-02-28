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
r = [
    [75    33]
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
    [79    76]
];
for i = 1 : 12
    x = [0 1 1 0] + r(i, 1) - 1;
    y = [0 0 1 1] + r(i, 2) - 1;
    patch('xData', x, 'yData', y, 'FaceColor', 'b');
end
h