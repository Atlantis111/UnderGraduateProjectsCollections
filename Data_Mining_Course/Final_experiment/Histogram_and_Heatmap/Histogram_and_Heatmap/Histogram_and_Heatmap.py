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

data=pd.read_csv('winedata_red.csv')


#sns.pairplot(data=data, diag_kind='hist', hue='quality')
#plt.show()

corr=data.corr()
sns.heatmap(data=corr,vmax=1,vmin=-1,cmap='coolwarm')
plt.show()