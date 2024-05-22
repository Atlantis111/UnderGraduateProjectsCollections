import cv2
import numpy as np
import matplotlib.pyplot as plt

#读入图片，把opencv的BGR转换成普通的RGB
img_bgr = cv2.imread('1.jpg')
#img_bgr = cv2.imread('1.jpg',cv2.IMREAD_GRAYSCALE)
img = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)


#伽玛变换函数
def adjust_gamma(image, gamma=1.0):
    invgamma = 1/gamma
    brighter_image = np.array(np.power((image/255), invgamma)*255, dtype=np.uint8)
    return brighter_image

#原图
plt.figure(figsize=(15,15))
plt.subplot(131)
plt.title('Original Img')    
plt.imshow(img)
#gamma大于1的图，对比度下降
img_gamma = adjust_gamma(img, gamma=5) 
plt.subplot(132)
plt.title("gamma>1 Img")
plt.imshow(img_gamma, cmap="gray")
#gamma小于1的图，对比度增强
img_gamma = adjust_gamma(img, gamma=0.3) 
plt.subplot(133)
plt.title("gamma<1 Img")
plt.imshow(img_gamma, cmap="gray")
plt.show()


