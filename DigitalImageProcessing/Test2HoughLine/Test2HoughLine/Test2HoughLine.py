import cv2
import numpy as np
import matplotlib as plt

#读入图片
img = cv2.imread('1.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
gaus = cv2.GaussianBlur(gray,(3,3),0)
#canny函数会使用题1的sober算子进行边缘检测，生成边缘图edges
edges = cv2.Canny(gaus, 50, 150, apertureSize=3)

#使用HoughLinesP函数进行直线检测
#rho: 距离精度；theta：角度精度；threshod: 累加平面的阈值参数；minLineLength：线段的最小长度；maxLineGap：线段的最大允许间隔
lines_p = cv2.HoughLinesP(edges, rho = 1, theta = np.pi/180, threshold = 1, minLineLength= 3, maxLineGap=3)
for i in range(len(lines_p)):
    x_1, y_1, x_2, y_2 = lines_p[i][0]
    cv2.line(img, (x_1, y_1), (x_2, y_2), (0, 255, 0), 2)

#展示结果
cv2.imshow("HoughResult",img)
cv2.waitKey(0)
