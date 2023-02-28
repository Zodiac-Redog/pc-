import pandas as pd
import numpy
import os
#加载数据
file = open('ccgps.csv', encoding = 'utf-8')
data = pd.read_csv(file)
#形成矩阵30.1288-30.2278,120.1264-120.2254

jz = pd.DataFrame()
for i in range(100):
	jz[i] = data.iloc[i * 100 : i * 100 + 100, 5].tolist()
#jz的行索引为(经度 * 10000 - 1201264) / 10, 列索引为(纬度 * 10000 - 301288) / 10
#加入手工数据
add_data = [[120.1886,30.1772,120.1887,30.1824,3],
			[120.2243,30.2130,120.2233,30.2143,2],
			[120.2263,30.1885,120.2257,30.1895,2],
			[120.1887,30.1824,120.1874,30.1926,2],
			[120.1698,30.1865,120.1734,30.1881,2],
			[120.1573,30.1874,120.1590,30.1878,2],
			[120.1785,30.1947,120.1792,30.1934,2],
			[120.2057,30.2115,120.2261,30.2095,2],
			[120.1872,30.1462,120.1883,30.1467,2],
			[120.1542,30.1785,120.1542,30.1801,2]]
#print(len(add_data)) 10
count = 0
for i in range(len(add_data)):
	x1 = int((float(add_data[i][0]) * 10000 - 1201264) / 10)
	x2 = int((float(add_data[i][2]) * 10000 - 1201264) / 10)
	y1 = int((float(add_data[i][1]) * 10000 - 301288) / 10)
	y2 = int((float(add_data[i][3]) * 10000 - 301288) / 10)
	if x1 > x2:
		x = x1
		x1 = x2
		x2 = x
	if y1 > y2:
		y = y1
		y1 = y2
		y2 = y
	for x in range(x1, x2 + 1):
		for y in range(y1, y2 + 1):
			if jz.iloc[y, x] != 0 and jz.iloc[y, x] != add_data[i][4]:
				jz.iloc[y, x] = add_data[i][4]
				count = count + 1
	print(x1,x2,y1,y2)
print(count)
jz.to_csv('jz.csv')