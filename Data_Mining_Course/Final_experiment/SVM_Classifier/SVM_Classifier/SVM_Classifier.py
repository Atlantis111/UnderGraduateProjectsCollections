import time
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.svm import SVC
from sklearn.decomposition import PCA
from sklearn.metrics import accuracy_score
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split

#读取数据集
data=pd.read_csv('../../winedata_red.csv')

#从原数据集中分出特征数据和类别数据，并将其转化为numpy的数组
feature=np.array(data.iloc[:,0:-1])
quality=np.array(data.iloc[:,-1])

#标准化的方式，预处理
feature_scaled=(feature-np.min(feature))/(np.max(feature)-np.min(feature))

#维数过多不利于可视化，通过主成分分析的方法降维
def ReduDim(feature,n=2):
    pca_model=PCA(n_components=n)
    pca_model.fit(feature)
    feature_nd=pca_model.transform(feature)
    return feature_nd

#划分数据集为训练集和测试集
def DatasetSplit(feature,quality):
    x_tra,x_tes,y_tra,y_tes=train_test_split(feature,quality,random_state=0)
    return x_tra,y_tra,x_tes,y_tes

mx=0 #初始化最大值
kernels=['linear','poly','rbf','sigmoid'] #初始化核函数列表
plt.figure(figsize=(10,8))
begin_t=time.time() #开始时间
for kernel in kernels:
    index=[] #用于存放维数的列表
    res=[] #用于存放降维到对应维数后分类预测的准确率
    for i in range(1,11):
        SVM_model=SVC(kernel=kernel)
        x_tr,y_tr,x_te,y_te=DatasetSplit(ReduDim(feature_scaled,i),quality)
        SVM_model.fit(x_tr,y_tr)
        y_pred=SVM_model.predict(x_te)
        acc=accuracy_score(y_te,y_pred)
        index.append(i)
        res.append(acc)
    mx=max((mx,max(res)))
    plt.plot(index,res)
end_t=time.time() #结束时间
plt.legend(labels=kernels) #显示标签
plt.xlim((1,11))
plt.show()
print('支持向量机算法预测的最大准确率为%.2f%%'%(mx*100))
print('算法运行平均总时间为%fs'%((end_t-begin_t)/4))