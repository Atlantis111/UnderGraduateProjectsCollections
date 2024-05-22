import cv2
import numpy as np
from scipy import fftpack

#使用理想的低通滤波器进行滤波
#将频域图像中大于截止频率的部分置为0实现低通滤波
def Lfilt(img,freq):
    h,w=img.shape
    #定义一个掩膜，中心为1，用于实现低通滤波
    mask=np.zeros(img.shape)
    hh=int(h/2)
    hw=int(w/2)
    mask[hh-freq:hh+freq,hw-freq:hw+freq]=1
    #调用函数进行二维离散傅里叶变换
    f=fftpack.fft2(img)
    #实现低通
    ldft=fftpack.fftshift(f)*mask
    #逆傅里叶变换
    ilf=fftpack.ifftshift(ldft)
    ildft=abs(fftpack.ifft2(ilf))
    return abs(ldft),ildft

#使用理想的高通滤波器进行滤波
#将频域图像中小于截止频率的部分置为0实现低通滤波
def Hfilt(img,freq):
    h,w=img.shape
    hh=int(h/2)
    hw=int(w/2)
    f=fftpack.fft2(img)
    hdft=fftpack.fftshift(f)
    hdft[hh-freq:hh+freq,hw-freq:hw+freq]=0
    ihf=fftpack.ifftshift(hdft)
    ihdft=abs(fftpack.ifft2(ihf))
    return abs(hdft),ihdft



#低通滤波截止频率暂设置为30
#高通滤波截止频率暂设置为50
freq1=30
freq2=50
#导入图片
g1=cv2.imread('1.jpg',flags=cv2.IMREAD_GRAYSCALE)
g2=cv2.imread('2.jpg',flags=cv2.IMREAD_GRAYSCALE)

#调用函数，实现傅里叶变换和低通/高通滤波
hdft1_1,ihdft1_1=Hfilt(g1,freq1)
ldft1_1,ildft1_1=Lfilt(g1,freq1)
hdft1_2,ihdft1_2=Hfilt(g1,freq2)
ldft1_2,ildft1_2=Lfilt(g1,freq2)
cv2.imwrite('hdft1_1.png',hdft1_1)
cv2.imwrite('ihdft1_1.png',ihdft1_1)
cv2.imwrite('ldft1_1.png',ldft1_1)
cv2.imwrite('ildft1_1.png',ildft1_1)
cv2.imwrite('hdft1_2.png',hdft1_2)
cv2.imwrite('ihdft1_2.png',ihdft1_2)
cv2.imwrite('ldft1_2.png',ldft1_2)
cv2.imwrite('ildft1_2.png',ildft1_2)

hdft2_1,ihdft2_1=Hfilt(g2,freq1)
ldft2_1,ildft2_1=Lfilt(g2,freq1)
hdft2_2,ihdft2_2=Hfilt(g2,freq2)
ldft2_2,ildft2_2=Lfilt(g2,freq2)
cv2.imwrite('hdft2_1.png',hdft2_1)
cv2.imwrite('ihdft2_1.png',ihdft2_1)
cv2.imwrite('ldft2_1.png',ldft2_1)
cv2.imwrite('ildft2_1.png',ildft2_1)
cv2.imwrite('hdft2_2.png',hdft2_2)
cv2.imwrite('ihdft2_2.png',ihdft2_2)
cv2.imwrite('ldft2_2.png',ldft2_2)
cv2.imwrite('ildft2_2.png',ildft2_2)