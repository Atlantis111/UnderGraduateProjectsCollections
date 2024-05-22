import sys
import dlib
from skimage import io
 
#生成默认的人脸检测器
detector = dlib.get_frontal_face_detector()


window = dlib.image_window() 
img = io.imread("2.jpg")


#使用detector进行人脸检测，画框，dets为返回的结果
dets = detector(img, 1) 

# 打印len(dets)，即检测到的人脸个数，format使得函数接收不限个参数，位置可以不按顺序
print("Number of faces detected: {}".format(len(dets)))

#enumerate是一个Python的内置方法，用于遍历索引
# left()、top()、right()、bottom()都是dlib.rectangle类的方法，对应矩形四条边的位置
for i, d in enumerate(dets):
    print("Detection {}: Left: {} Top: {} Right: {} Bottom: {}".format(i, d.left(), d.top(), d.right(), d.bottom()))
 
window.clear_overlay()
window.set_image(img)
window.add_overlay(dets)
dlib.hit_enter_to_continue()