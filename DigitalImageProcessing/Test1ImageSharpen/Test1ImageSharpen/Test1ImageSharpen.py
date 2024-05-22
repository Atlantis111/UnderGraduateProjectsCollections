import cv2
import random
import numpy as np
from scipy import signal
import matplotlib.pyplot as plt


#读入图片
img = cv2.imread('1.jpg',cv2.IMREAD_GRAYSCALE)

#锐化函数
def detect45(img,mat):
    return signal.convolve2d(img,mat,mode='same')

mat1=np.array([[-1,0,1],[-2,0,2],[-1,0,1]])
mat2=np.array([[1,2,1],[0,0,0],[-1,-2,-1]])
#调用函数实现锐化
res1=detect45(img,mat1)
res2=detect45(img,mat2)

plt.figure(figsize=(15,15))
plt.subplot(131)
plt.title('Original Img')    
plt.imshow(img)
plt.subplot(132)
plt.title('Result1')    
plt.imshow(res1)
plt.subplot(133)
plt.title('Result2')    
plt.imshow(res2)
plt.show()
