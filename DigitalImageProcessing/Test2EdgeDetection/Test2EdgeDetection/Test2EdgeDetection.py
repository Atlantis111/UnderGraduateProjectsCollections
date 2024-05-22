import cv2

#读入图片，并将图片转换为灰度图
img = cv2.imread("2.jpg")
gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#使用Sober算子分别对x和y方向的图片进行图像梯度计算
x = cv2.Sobel(gray_img, cv2.CV_16S, 1, 0)
y = cv2.Sobel(gray_img, cv2.CV_16S, 0, 1)
#在经过处理后，需要用convertScaleAbs()函数将其转回原来的uint8形式
##否则将无法显示图像，而只是一副灰色的窗口
Scale_absX = cv2.convertScaleAbs(x)
Scale_absY = cv2.convertScaleAbs(y)
#以0.5和0.5的权重统合x与y方向上的边缘提取结果
result = cv2.addWeighted(Scale_absX, 0.5, Scale_absY, 0.5, 0)
#保存图片，输出图像
cv2.imwrite("Result2.jpg",result)
cv2.imshow('img', gray_img)
cv2.imshow('result', result)
cv2.waitKey(0)


