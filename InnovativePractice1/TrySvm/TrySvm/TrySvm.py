import cv2
import numpy as np
import matplotlib.pyplot as plt

a=np.random.randint(95,100,(20,2)).astype(np.float32)       #A级员工的笔试成绩和面试成绩
b=np.random.randint(90,95,(20,2)).astype(np.float32)        #B级员工的笔试成绩和面试成绩
data=np.vstack((a,b))           #合并数据
data=np.array(data,dtype='float32')

aLabel=np.zeros((20,1))     #建立标签
bLabel=np.ones((20,1))

label=np.vstack((aLabel,bLabel))        #合并标签
label=np.array(label,dtype='int32')

svm=cv2.ml.SVM_create()     #创建SVM (直接用默认的值)

result=svm.train(data,cv2.ml.ROW_SAMPLE,label)      #训练

test=np.vstack([[98,90],[90,99]])       #预测
test=np.array(test,dtype='float32')
(p1,p2)=svm.predict(test)

plt.scatter(a[:,0],a[:,1],80,'g','o')       #可视化
plt.scatter(b[:,0],b[:,1],80,'b','s')
plt.scatter(test[:,0],test[:,1],80,'r','*')
plt.show()

print(test)     #打印
print(p2)
