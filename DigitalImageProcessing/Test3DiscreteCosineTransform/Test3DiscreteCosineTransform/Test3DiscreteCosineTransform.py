import cv2
import math
import numpy as np

def SplitDCT(img,quant):
    h0,w0=img.shape
    #将图像长和宽除以8取整后*8，保证长和宽为8的倍数
    h=math.ceil(h0/8)*8
    w=(math.ceil(w0/8))*8
    mat=np.zeros((h,w))
    mat[0:h0,0:w0]=img.copy()
    #将数组垂直拆分为h/8个数组
    temp=np.vsplit(mat,h/8)
    res=[]
    qres=[]
    ires=[]
    #对图像切割成的若干个8*8像素矩阵进行力三余弦变换，得到频谱系数图
    for i in range(int(h/8)):
        res.append([])
        qres.append([])
        ires.append([])
        tempb=np.hsplit(temp[i],w/8)
        for j in range(int(w/8)):
            dcted=cv2.dct(tempb[j])
            res[i].append(dcted)
            qdcted=dcted/quant
            qdcted=qdcted.astype(int)
            idcted=cv2.idct(qdcted.astype(float)*quant)
            ires[i].append(idcted)
        res[i]=np.concatenate(res[i],axis=1)
        ires[i]=np.concatenate(ires[i],axis=1)
    #将结果res和ires数组拼接，重新组合成新的完整的原图的频谱图
    res=np.concatenate(res,axis=0)
    ires=np.concatenate(ires,axis=0)
    return res,ires[0:h0,0:w0]

#为了简化操作，采用了8*8的全为150的矩阵作为量化矩阵
quant=np.array([[150,150,150,150,150,150,150,150],
                [150,150,150,150,150,150,150,150],
                [150,150,150,150,150,150,150,150],
                [150,150,150,150,150,150,150,150],
                [150,150,150,150,150,150,150,150],
                [150,150,150,150,150,150,150,150],
                [150,150,150,150,150,150,150,150],
                [150,150,150,150,150,150,150,150]])

#读入两张测试图片
g1=cv2.imread('1.jpg',flags=cv2.IMREAD_GRAYSCALE)
g2=cv2.imread('2.jpg',flags=cv2.IMREAD_GRAYSCALE)
#进行离散余弦变换并输出DOT系数图与离散余弦逆变换过程
dct1,idct1=SplitDCT(g1,quant)
cv2.imwrite('dct1.png',dct1.astype(np.uint8))
cv2.imwrite('idct1.png',idct1.astype(np.uint8))
dct2,idct2=SplitDCT(g2,quant)
cv2.imwrite('dct2.png',dct2.astype(np.uint8))
cv2.imwrite('idct2.png',idct2.astype(np.uint8))