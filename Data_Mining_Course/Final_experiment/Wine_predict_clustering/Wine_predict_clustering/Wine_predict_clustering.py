import numpy as np
import matplotlib.pyplot as plt
import csv
import pandas as pd
 
 
#计算两点间的距离
def get_distance(p1, p2):
    diff = [x-y for x, y in zip(p1, p2)]
    distance = np.sqrt(sum(map(lambda x: x**2, diff)))
    return distance
 
 
# 计算多个点的中心，输入参数为列表，输出中心点
def getnew_center_point(cluster):
    N = len(cluster)
    m = np.matrix(cluster).transpose().tolist()
    center_point = [sum(x)/N for x in m]
    return center_point
 
 
# 检查旧、新中心点是否有差别
def check_center_diff(center, new_center):
    n = len(center)
    for c, nc in zip(center, new_center):
        if c != nc:
            return False
    return True
 
 
# K-means算法的实现
def K_means(samples, center_points):
 
    N = len(samples)         # 样本个数
    n = len(samples[0])      # 单个样本的属性个数
    k = len(center_points)  # 类别数
 
    tot = 0
    while True:             # 迭代
        temp_center_points = [] # 记录中心点
        clusters = []       # 记录聚类的结果
        for c in range(0, k):
            clusters.append([]) # 初始化，此时clusters=[[],[],[]]
 
        # 针对每个点，寻找距离其最近的中心点（寻找组织）
        for i, data in enumerate(samples):
            distances = []
            for center_point in center_points:
                distances.append(get_distance(data, center_point))
            index = distances.index(min(distances)) # 找到最小的距离的那个中心点的索引，
 
            clusters[index].append(data)    # 那么这个中心点代表的簇，里面增加一个样本.
 
        tot += 1
        print(tot, '次迭代', clusters)
        k = len(clusters) 

        colors = ['r.', 'g.', 'b.'] 
        for i, cluster in enumerate(clusters):
            data = np.array(cluster)     
            data_x = [x[8] for x in data]
            data_y = [x[9] for x in data]
            plt.subplot(5, 4, tot)
            plt.plot(data_x, data_y, colors[i])
            plt.axis([0, 300, 0, 200])
 
        # 计算新的中心点
        for cluster in clusters:
            temp_center_points.append(getnew_center_point(cluster))
 
        # 在计算中心点的时候，需要将原来的中心点算进去
        for j in range(0, k):
            if len(clusters[j]) == 0:
                temp_center_points[j] = center_points[j]
 
        # 判断中心点是否发生变化
        for c, nc in zip(center_points, temp_center_points):
            if not check_center_diff(c, nc):
                center_points = temp_center_points[:]   # 复制一份
                break
        else: 
            break
 
    plt.show()
    return clusters # 返回聚类的结果
 
 
 
 
# 随机获取一个样本集，用于测试K-means算法
def get_test_data():
 
    samples = []
    center_points = []

    df = pd.read_csv('winedata_red.csv')
    samples = df.values.tolist()          #提取属性列表
    df1 = pd.read_csv('winedata_white.csv')
    samples1 = df1.values.tolist()
    samples.extend(samples1)

    center_points = [[7.4,0.7,0,1.9,0.076,11,34,0.9978,3.51,0.56,9.4,5], 
                     [7,0.27,0.36,20.7,0.045,45,170,1.001,3,0.45,8.8,6]]
 
    return samples, center_points
 
 
if __name__ == '__main__':
    
    one_one,one_two,two_one,two_two=0,0,0,0


    samples, center_points = get_test_data()
    clusters = K_means(samples, center_points)

    print('分类结果')
    print('\n')
    for i, cluster in enumerate(clusters):
        print('cluster ', i, ' ', cluster)
        print('\n')

    for n, point in enumerate(samples):
        for m, cluster in enumerate(clusters):
            if point in cluster:
                print(n+1,'条数据在第',m+1,'类中')

                if m+1==1 and n+1<=1600:   one_one=one_one+1     #实际为1，预测为1
                if m+1==2 and n+1<=1600:   one_two=one_two+1     #实际为1，预测为2
                if m+1==1 and n+1>1600:   two_one=two_one+1      #实际为2，预测为1
                if m+1==2 and n+1>1600:   two_two=two_two+1      #实际为2，预测为2

    print('实际为1，预测为1的条数为',one_one)
    print('实际为1，预测为2的条数为',one_two)
    print('实际为2，预测为1的条数为',two_one)
    print('实际为2，预测为2的条数为',two_two)