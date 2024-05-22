import cv2
import numpy as np

img = cv2.imread('E:\\VisualstudioProject\\HistogramEqualization\\liziqiu.jpg', 1)
cv2.imshow("src", img)

# 分解通道 对每一个通道均衡化
(b, g, r) = cv2.split(img)
bH = cv2.equalizeHist(b)
gH = cv2.equalizeHist(g)
rH = cv2.equalizeHist(r)

# 合并所有通道
result = cv2.merge((bH, gH, rH))
cv2.imshow("dst", result)
cv2.waitKey(0)


