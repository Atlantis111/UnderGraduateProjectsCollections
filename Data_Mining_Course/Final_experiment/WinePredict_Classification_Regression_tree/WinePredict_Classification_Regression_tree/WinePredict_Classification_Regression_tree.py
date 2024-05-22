from sklearn import tree
# 导入数据集划分方法
from sklearn.model_selection import train_test_split
# 导入决策树可视化所需字符串缓存
from six import StringIO
# 导入准确率包
from sklearn.metrics import accuracy_score as accs
#导入均方误差包
from sklearn.metrics import mean_squared_error as mse
# 数据处理
import numpy as np 
import pandas as pd
# 数据可视化
import matplotlib.pyplot as plt
# 决策树可视化
import pydotplus as pdp
from IPython.display import Image
from IPython.display import display


#读入红葡萄酒数据
data_frame_red=pd.read_csv('../../winedata_red.csv')
#读入白葡萄酒数据
data_frame_white=pd.read_csv('../../winedata_white.csv')

# 红葡萄酒数据转化,将数据拉直成一维列表
red_data=np.array(data_frame_red)
# 白葡萄酒数据转化
white_data=np.array(data_frame_white)


# 获取前十一维的数据
x=red_data[:,0:11]
# 获得最后一维的数据
y=red_data[:,-1]

#选取糖分属性进行可视化
plt.scatter(red_data[:,3],y) # 选取剩余糖分数据和酒的品质画图
plt.xlabel('residual sugar') # 横轴文字标签
plt.ylabel('quality') # 纵轴文字标签
plt.show()

#划分数据集，70%训练，30%测试
x_train,x_test,y_train,y_test = train_test_split(x,y,test_size=0.3)

DTR=tree.DecisionTreeRegressor(max_depth=3) # 构造回归树
DTC=tree.DecisionTreeClassifier(max_depth=3) # 构造分类树

DTR.fit(x_train,y_train) # 训练回归树
DTC.fit(x_train,y_train) # 训练分类树

dot_DTR=StringIO() # 构造回归树可视化所需字符串缓存
dot_DTC=StringIO() # 构造分类树可视化所需字符串缓存

feature_name=data_frame_red.columns.values[0:11] # 提取自变量属性名
target_name=data_frame_red.columns.values[-1] # 提取因变量属性名

#导出回归树与分析树
dot_DTR=tree.export_graphviz(DTR,feature_names=feature_name,class_names=target_name) # 导出回归树
dot_DTC=tree.export_graphviz(DTC,feature_names=feature_name,class_names=target_name) # 导出分类树

graph_DTR = pdp.graph_from_dot_data(dot_DTR) # 回归树图像生成
graph_DTC = pdp.graph_from_dot_data(dot_DTC) # 分类树图像生成


# 显示回归树与分类树
'''
imDTR=Image(graph_DTR.create_png())
imDTC=Image(graph_DTC.create_png())
display(imDTR) # 展示回归树
display(imDTC) # 展示分类树
'''

y_predR=DTR.predict(x_test)
y_predC=DTC.predict(x_test)
print('回归树均方误差：%f' % mse(y_predR,y_test))
print('分类树准确度：%.3f%%' % (accs(y_predC,y_test)*100))


