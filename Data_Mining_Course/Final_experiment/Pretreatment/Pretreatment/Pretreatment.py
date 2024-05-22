import csv
import pandas as pd

#读入红酒数据集，最后一列填上type属性=1
df = pd.read_csv('winedata_red.csv')
df.columns = ['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar',
       'chlorides', 'free sulfur dioxide', 'total sulfur dioxide', 'density',
       'pH', 'sulphates', 'alcohol', 'quality']
print(df.head())
df['type']='1'
print(df.head())
df.to_csv('new_winedata_red.csv')

#读入白酒数据集，最后一列填上type属性=2
df = pd.read_csv('winedata_white.csv')
df.columns = ['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar',
       'chlorides', 'free sulfur dioxide', 'total sulfur dioxide', 'density',
       'pH', 'sulphates', 'alcohol', 'quality']
print(df.head())
df['type']='2'
print(df.head())
df.to_csv('new_winedata_white.csv')
