import cv2
import random
import numpy as np
import matplotlib.pyplot as plt
import tkinter as tk

#1.定义椒盐噪声函数
def sp_noise(img, prob):        #添加椒盐噪声，输入参数为img图像，prob噪声比例
    resultImg = np.zeros(img.shape, np.uint8)
    thres = 1 - prob
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            rdn = random.random()           # 随机生成0-1之间的数字
            if rdn < prob:                  # 如果生成的随机数小于噪声比例则将该像素点添加黑点，即椒噪声
                resultImg[i][j] = 0
            elif rdn > thres:               # 如果生成的随机数大于（1-噪声比例）则将该像素点添加白点，即盐噪声
                resultImg[i][j] = 255
            else:
                resultImg[i][j] = img[i][j]  # 其他情况像素点不变
    return resultImg

#1.1显示椒盐噪声函数
def jiaoyan(a):
    img = cv2.imread(a)
    cv2.imshow('jiaoyan', sp_noise(img, 0.05))


#2.定义高斯噪声函数
def gasuss_noise(image, mean, var):     #添加高斯噪声，输入参数为mean均值 ，var方差
    image = np.array(image/255, dtype=float)        #将图片转化为数组
    noise = np.random.normal(mean, var ** 0.5, image.shape)         #噪声的数组
    out = image + noise         #叠加
    return out


#2.1显示高斯噪声函数
def gaosi(a):
    img = cv2.imread(a,1)
    cv2.imshow('gaosi', gasuss_noise(img, 0, 0.001))

#3.显示直方图均衡化函数
def equalizeHist(a):
    img = cv2.imread(a, 1)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    his = cv2.equalizeHist(gray)
    cv2.imshow("histogram", his)

#4.显示中值滤波函数
def middleBlur(a):
    img = cv2.imread(a, 1)
    medianBlur=cv2.medianBlur(img ,5)
    cv2.imshow('medianBlur',medianBlur)

#5.显示开运算函数
def OpenOperation(a):
    img = cv2.imread(a,0)
    k= np.ones((10,10),np.uint8)
    r1=cv2.morphologyEx(img,cv2.MORPH_OPEN,k)
    cv2.imshow("OpenOperation",r1)

#6.显示闭运算函数
def CloseOperation(a):
    img = cv2.imread(a,0)
    k= np.ones((10,10),np.uint8)
    r2=cv2.morphologyEx(img,cv2.MORPH_CLOSE,k,iterations=1)
    cv2.imshow("CloseOperation",r2)

#7.显示低通滤波函数
def LowEnter(a):
    img = cv2.imread(a,0)

    dft = cv2.dft(np.float32(img),flags = cv2.DFT_COMPLEX_OUTPUT)           #傅里叶变换

    dft_shift = np.fft.fftshift(dft)        #将图像中的低频部分移动到图像的中心

    magnitude_spectrum = 20*np.log(cv2.magnitude(dft_shift[:,:,0],dft_shift[:,:,1]))        #计算矩阵维度的平方根

    rows, cols = img.shape
    crow,ccol = int(rows/2) , int(cols/2)
 
    mask = np.zeros((rows,cols,2),np.uint8)
    mask[crow-30:crow+30, ccol-30:ccol+30] = 1
 
    fshift = dft_shift*mask

    f_ishift = np.fft.ifftshift(fshift)         ## 将图像的低频和高频部分移动到图像原来的位置

    img_back = cv2.idft(f_ishift)               #进行傅里叶的逆变化

    img_back = cv2.magnitude(img_back[:,:,0],img_back[:,:,1])
 
    plt.imshow(img_back, cmap = 'gray')
    plt.title('Fourier'), plt.xticks([]), plt.yticks([])
    plt.show()
    cv2.waitKey(0)



def Choosefunction(a):
    root3=tk.Tk()   #实例化tkinter类
    root3.title('测试')  #设置窗口的标题
    root3.geometry('300x600')
    button1=tk.Button(root3,text="椒盐噪声",width=10,height=3,command = lambda:jiaoyan(a))
    button1.pack()
    button2=tk.Button(root3,text="高斯噪声",width=10,height=3,command = lambda:gaosi(a))
    button2.pack()
    button3=tk.Button(root3,text="直方图均衡化",width=10,height=3,command = lambda:equalizeHist(a))
    button3.pack()
    button4=tk.Button(root3,text="中值滤波",width=10,height=3,command = lambda:middleBlur(a))
    button4.pack()
    button5=tk.Button(root3,text="开运算",width=10,height=3,command = lambda:OpenOperation(a))
    button5.pack()
    button6=tk.Button(root3,text="闭运算",width=10,height=3,command = lambda:CloseOperation(a))
    button6.pack()
    button7=tk.Button(root3,text="低通滤波",width=10,height=3,command = lambda:LowEnter(a))
    button7.pack()
    root3.mainloop()   #继续等待和执行

    
def ChoosePicture():
    root2=tk.Tk()   #实例化tkinter类
    root2.title('测试')  #设置窗口的标题
    root2.geometry('300x600')
    button1=tk.Button(root2,text="第一张图",width=10,height=2,command = lambda:Choosefunction('1.jpg'))
    button1.pack()
    button2=tk.Button(root2,text="第二张图",width=10,height=2,command = lambda:Choosefunction('2.jpg'))
    button2.pack()
    button2=tk.Button(root2,text="第三张图",width=10,height=2,command = lambda:Choosefunction('3.jpg'))
    button2.pack()
    button2=tk.Button(root2,text="第四张图",width=10,height=2,command = lambda:Choosefunction('4.jpg'))
    button2.pack()
    button2=tk.Button(root2,text="第五张图",width=10,height=2,command = lambda:Choosefunction('5.jpg'))
    button2.pack()
    button2=tk.Button(root2,text="第六张图",width=10,height=2,command = lambda:Choosefunction('6.jpg'))
    button2.pack()
    button2=tk.Button(root2,text="第七张图",width=10,height=2,command = lambda:Choosefunction('7.jpg'))
    button2.pack()
    button2=tk.Button(root2,text="第八张图",width=10,height=2,command = lambda:Choosefunction('8.jpg'))
    button2.pack()
    button2=tk.Button(root2,text="第九张图",width=10,height=2,command = lambda:Choosefunction('9.jpg'))
    button2.pack()
    button2=tk.Button(root2,text="第十张图",width=10,height=2,command = lambda:Choosefunction('10.jpg'))
    button2.pack()
    root2.mainloop()   #继续等待和执行

root1=tk.Tk()   #实例化tkinter类
root1.title('测试')  #设置窗口的标题
root1.geometry('30x60')
button1=tk.Button(root1,text="开始",width=10,height=4,command = ChoosePicture)
button1.pack()
root1.mainloop()   #继续等待和执行