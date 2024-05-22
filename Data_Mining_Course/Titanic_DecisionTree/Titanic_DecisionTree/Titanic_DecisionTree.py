import numpy as np
import pandas as pd
from sklearn.feature_extraction import DictVectorizer
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import cross_val_score
 
#加载数据
train_data = pd.read_csv('train.csv')
test_data = pd.read_csv('test.csv')

#数据预处理
train_data['Age'].fillna(train_data['Age'].mean(),inplace = True)
test_data['Age'].fillna(test_data['Age'].mean(),inplace = True)

#特征选择
features = ['Pclass','Sex','Age','SibSp','Parch']
train_features = train_data[features]
train_labels = train_data['Survived']
test_features = test_data[features]

#将符号0-1化
dv = DictVectorizer(sparse = False)
train_features = dv.fit_transform(train_features.to_dict(orient= 'records'))

#建立决策树并进行训练
clf = DecisionTreeClassifier(criterion= 'entropy')
clf.fit(train_features,train_labels)

#预测
test_features = dv.transform(test_features.to_dict(orient= 'records'))
result = clf.predict(test_features)

#导出数据
test_data['Survived'] = result
test_data.to_csv('result.csv') 

#准确率
acc_decision_tree = round(clf.score(train_features, train_labels),6)
print(acc_decision_tree)