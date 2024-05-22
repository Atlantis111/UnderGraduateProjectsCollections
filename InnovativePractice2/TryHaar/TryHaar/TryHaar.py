import cv2
import numpy as np


image = cv2.imread('1.jpg')
#加载人脸检测器
faceCascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
#转换为灰度图像
gray=cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
#调用函数
faces=faceCascade.detectMultiScale(
    gray,
    scaleFactor=1.15,
    minNeighbors=9,
    minSize=(5,5)
)
print(faces)
#打印人脸个数
print(len(faces))

for(x,y,w,h) in faces:
    cv2.circle(image,(int((x+x+w)/2),int((y+y+h)/2)),int(w/2),(0,255,0),2)

cv2.imshow("dect",image)
cv2.imwrite("result13.jpg",image)
cv2.waitKey(0)
cv2.destroyAllWindows
