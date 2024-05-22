import cv2
import numpy as np
import matplotlib.pyplot as plt

def compress(str_num):
    #1维游程压缩编码。
    #对一连续的0，1,用8为进行存储游程信息。第一位存储的是字符0,1，后7位存储的是字符的数目
    compress_str = ''
    last = None
    count = 0
    for t in list(str_num):
        if last is None:
            last = t
            count = 1
        else:
            if t == last and count < 127:
                count += 1
            else:
                if last == '0':
                    str_2 = str(bin(count))[2:]

                    if len(str_2) < 8:
                        str_2 = (8 - len(str_2)) * '0' + str_2
                    compress_str = compress_str+ str_2
                else:

                    count = count+128
                    str_2 = str(bin(count))[2:]

                    if len(str_2) < 8:
                        str_2 = (8 - len(str_2)) * '0' + str_2
                    compress_str = compress_str+str_2
                last = t
                count = 1
    if last == '0':
        str_2 = str(bin(count))[2:]
        if len(str_2) < 8:
            str_2 = (8 - len(str_2)) * '0' + str_2
        compress_str = compress_str+ str_2
    else:
        count = count + 128
        str_2 = str(bin(count))[2:]
        if len(str_2) < 8:
            str_2 = (8 - len(str_2)) * '0' + str_2
        compress_str = compress_str + str_2
    return compress_str


def decompress(compress_str):
    #游程编码解压缩，对输入的二进制字符串按 8 位一组进行解压
    decompress_str = ''
    i = 0
    while True:
        string_num = compress_str[i:i+8]
        str_10 = int(string_num, 2)
        if  str_10 > 127:
            decompress_str += int(string_num[1:], 2) * '1'
        else:
            decompress_str += str_10*'0'
        i = i + 8
        if i+8 > len(compress_str):
            break
    return decompress_str



# 读取图像
img = cv2.imread(r'1.jpg', 0)
h, w = img.shape[0], img.shape[1]
rows, cols = img.shape[0], img.shape[1]
#8个位平面数据存储带new_img数组中
new_img = np.zeros((h, w, 8),np.uint8)
for i in range(h):
    for j in range(w):
        n = str(np.binary_repr(img[i, j], 8))
        for k in range(8):
            new_img[i, j, k] = n[k]


#对8个位平面分别使用游程编码
compress_len_list = []
for k in range(8):
    img_k = new_img[:, :, k]
    # 把灰度化后的二维图像降维为一维列表
    image1 = img_k.flatten() 
    imgdata_str_list = [str(i) for i in image1]
    imgdata_str = ''.join(imgdata_str_list)
    # 压缩
    compress_str = compress(imgdata_str)  
    # 解压缩
    decompress_str = decompress(compress_str)  
    decompress_int = [int(i) for i in list(decompress_str)] 

    # 转换会图像数组形式
    new_img[:, :, k] = np.reshape(decompress_int, (rows, cols))
    compress_size = len(compress_str)/8/1024.0
    compress_len_list.append(compress_size)
    decompress_size = len(decompress_str)/8/1024.0
    #计算压缩比
    ratio = 100 - compress_size / decompress_size*100
    print('平面{}:{:.2f}KB  压缩后:{:.2f}KB  压缩比{:.2f}%'.format(k,decompress_size, compress_size,ratio))

# 计算只压缩前两个平面的压缩率
compress_len_sum = (compress_len_list[0]+compress_len_list[1]) + w*h*6/1024.0/8.0
all_size = (w*h*8)/1024.0/8
ratio = 100 - compress_len_sum / all_size*100
print('原图:{:.2f}KB  压缩后:{:.2f}KB  压缩比{:.2f}%'.format(all_size, compress_len_sum,ratio))

res_img = np.zeros((h, w),np.uint8)
for i in range(h):
    for j in range(w):
        s = ''
        for k in range(8):
            s += str(new_img[i, j, k])
        res_img[i][j] = int(s,2)



# 显示1-8层位平面
plt.rcParams['font.sans-serif'] = ['SimHei']
for i in range(8):
    j = i + 1
    plt.subplot(2, 4, i + 1)
    plt.axis('off')
    plt.title('第%i层图像' % j)
    plt.imshow(new_img[:, :, i], cmap='gray')
plt.savefig('result1.jpg')
plt.figure()
plt.subplot(121), plt.imshow(img, plt.cm.gray), plt.title('原图灰度图像'), plt.axis('off')
plt.subplot(122), plt.imshow(res_img, plt.cm.gray), plt.title('解压后'), plt.axis('off')

plt.show()
