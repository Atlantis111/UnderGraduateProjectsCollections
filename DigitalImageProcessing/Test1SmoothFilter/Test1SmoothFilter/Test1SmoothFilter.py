import numpy as np
import cv2
import matplotlib.pyplot as plt


#读入图片，把opencv的BGR转换成普通的RGB
img_bgr = cv2.imread('2.jpg')
img = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)

# 均值滤波
img_mean_3 = cv2.blur(img,(3,3))
img_mean_5 = cv2.blur(img,(5,5))
img_mean_10 = cv2.blur(img,(10,10))
img_mean_15 = cv2.blur(img,(15,15))
img_mean_30 = cv2.blur(img,(30,30))

# 图片展示
titles = ['mean3*3','mean5*5', 'mean10*10', 'mean15*15', 'mean30*30']
imgs = [img_mean_3, img_mean_5, img_mean_10, img_mean_15, img_mean_30]

for i in range(5):
    plt.subplot(2,3,i+1)
    #数组下标从1开始！！
    plt.imshow(imgs[i])
    plt.title(titles[i])
plt.show()
