import cv2
import numpy as np
img = cv2.imread('E:\\VisualstudioProject\\HistogramEqualization(YUV)\\liziqiu.jpg', 1)

imgYUV = cv2.cvtColor(img, cv2.COLOR_BGR2YCrCb)
cv2.imshow("src", img)

channelsYUV = cv2.split(imgYUV)
channelsYUV[0] = cv2.equalizeHist(channelsYUV[0])

channels = cv2.merge(channelsYUV)
result = cv2.cvtColor(channels, cv2.COLOR_YCrCb2BGR)
cv2.imshow("dst", result)

cv2.waitKey(0)
