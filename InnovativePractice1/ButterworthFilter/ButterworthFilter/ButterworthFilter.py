import numpy as np
import cv2
import matplotlib.pyplot as plt

img =cv2.imread('E:\\VisualstudioProject\\SmoothFiltering\\yuanweiji.jpg',0)

GaussianBlur = cv2.GaussianBlur(img, (5, 5), 0)


cv2.imshow("GaussianBlur",GaussianBlur)
cv2.imwrite("./GaussianBlur.jpg",GaussianBlur)
cv2.imshow("yuantu",img)
cv2.waitKey(3000)