import cv2
import numpy as np
import matplotlib.pyplot as plt

#由于不知道怎么取谷底，所以用了迭代法，保证阈值取到的位置位于谷底附近
#根据灰度直方图数据，以每个灰度对应的像素个数为权重
#分别计算灰度区间[0,t0]的加权平均灰度值lb和灰度区间(t0,256]的加权灰度平均值ub；得到新灰度阈值t1=(ub+lb)/2；
#若t1与t0相等，则迭代结束；否则回到步骤②继续迭代。
def searchThresh(hist,lb0,ub0):
    th0=int((lb0+ub0)/2)
    th1=0
    while (th1-th0)!=0:
        cnt1=0;cnt2=0
        sum1=0;sum2=0
        for i in range(th0):
            sum1+=i*hist[i]
            cnt1+=hist[i]
        for i in range(th0,256):
            sum2+=i*hist[i]
            cnt2+=hist[i]
        lb1=sum1/cnt1
        ub1=sum2/cnt2
        th1=th0
        th0=int((lb1+ub1)/2)
    return th0

#读入图片
g1=cv2.imread('1.png',cv2.IMREAD_GRAYSCALE)
g2=cv2.imread('2.png',cv2.IMREAD_GRAYSCALE)
#绘制直方图
gray=np.arange(0,256,1).astype(int)
hist1=cv2.calcHist([g1],[0],None,histSize=[256],ranges=[0,255]).reshape((1,-1))[0]
hist2=cv2.calcHist([g2],[0],None,histSize=[256],ranges=[0,255]).reshape((1,-1))[0]
plt.bar(gray,hist1)
plt.savefig('hist1.jpg')
plt.close()
plt.bar(gray,hist2)
plt.savefig('hist2.jpg')
#将直方图转换为一维变量
hist1=np.reshape(hist1,(1,-1))
hist2=np.reshape(hist2,(1,-1))
#寻找阈值（结果为接近谷底位置）
th1=searchThresh(hist1[0],np.min(g1),np.max(g1))
th2=searchThresh(hist2[0],np.min(g2),np.max(g2))
#通过阈值二值化输出图像并保存
_,cut1=cv2.threshold(g1,th1,255,cv2.THRESH_BINARY)
_,cut2=cv2.threshold(g2,th2,255,cv2.THRESH_BINARY)
cv2.imwrite('cut1.png',cut1)
cv2.imwrite('cut2.png',cut2)
