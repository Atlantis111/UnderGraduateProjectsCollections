import numpy as np
import cv2
import matplotlib.pyplot as plt

def IdealHighPassFiltering(f_shift):
    # 设置滤波半径
    D0 = 8
    # 初始化
    m = f_shift.shape[0]
    n = f_shift.shape[1]
    h1 = np.zeros((m, n))
    x0 = np.floor(m/2)
    y0 = np.floor(n/2)
    for i in range(m):
        for j in range(n):
            D = np.sqrt((i - x0)**2 + (j - y0)**2)
            if D >= D0:
                h1[i][j] = 1
    result = np.multiply(f_shift, h1)
    return result

def GaussLowPassFiltering(f_shift):
    # 设置滤波半径
    D0 = 8
    # 初始化
    m = f_shift.shape[0]
    n = f_shift.shape[1]
    h1 = np.zeros((m, n))
    x0 = np.floor(m/2)
    y0 = np.floor(n/2)
    for i in range(m):
        for j in range(n):
            D = np.sqrt((i - x0)**2 + (j - y0)**2)
            h1[i][j] = np.exp((-1)*D**2/2/(D0**2))
    result = np.multiply(f_shift, h1)
    return result

img =cv2.imread('E:\\VisualstudioProject\\SmoothFiltering\\yuanweiji.jpg',0)
f=np.fft.fft2(img)
f_shift=np.fft.fftshift(f)

# 理想高通滤波
IHPF = IdealHighPassFiltering(f_shift)
new_f1 = np.fft.ifftshift(IHPF)
new_image1 = np.uint8(np.abs(np.fft.ifft2(new_f1)))
plt.subplot(2,2,1)
plt.imshow(new_image1, 'gray')
plt.show()