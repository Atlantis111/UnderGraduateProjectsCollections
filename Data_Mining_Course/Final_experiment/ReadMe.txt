文件列表
1.winedata_red.csv和winedata_white.csv
对应红酒和白酒的数据集，其中，前面的为酒的各项属性，最后一列为酒的品质。聚类算法实现了白酒和红酒的聚类，而分类算法只使用了红酒数据集。

1.Pretreatment.py		
预处理算法，用于给红酒和白酒打上type标签，红酒为1，白酒为2，并导出。

2.Wine_predict_clustering.py
聚类算法，将红酒和白酒数据集混合，并使用K-means算法对其进行聚类。由于红酒数据1600条，白酒数据4900条，样本差太多，聚类效果不好，所以将白酒数据只保留了前1600条。

3.Histogram_and_Heatmap.py
打注释的部分是通过seaborn库的pairplot()函数画出每对特征彼此以及与质量之间的关系，并对每个特征进行直方图统计。最后绘制出的直方图放在了.py文件目录下。
未注释的部分是通过pandas库自带的corr方法计算数据集的相关性矩阵，并通过seaborn库的heatmap()函数绘制相关系数热力图。最后绘制出的热力图放在了.py文件目录下。


以下皆为分类算法模型，意在对红酒的品质进行预测。数据集在Final_experiment目录下分类准确率都绘制成了图片并存放在每个程序的.py文件目录下
4.WinePredict_Classification_Regression_tree.py
使用决策树算法（回归树和分类树），基于红酒的属性，对红酒的品质进行分类（以红酒为例，并不涉及白酒）。两个决策树绘制图在.py目录下。

5.Bayes_Classifier.py
使用贝叶斯算法对红酒的品质进行分类

6.KNN_Classifier.py
使用K-临近算法对红酒的品质进行分类

7.RandomForest_Classifier.py
使用随机森林算法对红酒的品质进行分类

