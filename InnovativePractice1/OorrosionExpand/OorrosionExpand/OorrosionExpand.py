import cv2
import numpy as np

img = cv2.imread('E:\\VisualstudioProject\\OorrosionExpand\\liziqiu.jpg',0)
kernel = np.ones((5,5),np.uint8)
dict = cv2.dilate(img,kernel,iterations = 1)
cv2.imshow("org",img)
cv2.imshow("result", dict)
cv2.waitKey(0)
