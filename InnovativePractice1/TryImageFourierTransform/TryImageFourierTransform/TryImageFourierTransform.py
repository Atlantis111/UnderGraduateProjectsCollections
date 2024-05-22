import cv2
import numpy as np
import matplotlib.pyplot as plt

#！！！这是个逆傅里叶变换！！！

img = cv2.imread('E:\\VisualstudioProject\\InnovativePractice1\\TryImageFourierTransform\\liziqiu.jpg', 0)
f = np.fft.fft2(img)
fshift = np.fft.fftshift(f)
ishift = np.fft.ifftshift(fshift)
iimg = np.fft.ifft2(ishift)
iimg = np.abs(iimg)

plt.subplot(121)
plt.imshow(img, cmap = 'gray')
plt.title('original')
plt.axis('off')

plt.subplot(122)
plt.imshow(iimg, cmap = 'gray')
plt.title('result')
plt.axis('off')

plt.show()
