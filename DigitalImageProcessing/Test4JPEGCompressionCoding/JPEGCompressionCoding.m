%算法步骤包括如下几个部分：图像分块，离散余弦变换，量化，ac和dc系数的Z字形编排
clc;
clear;
%JPEG标准亮度量化表
Qy = [ 16  11  10  16  24  40  51  61;
         12  12  14  19  26  58  60  55;
         14  13  16  24  40  57  69  56;
         14  17  22  29  51  87  80  62;
         18  22  37  56  68  109 103 77;
         24  35  55  64  81  104 113 92;
         49  64  78  87  103 121 120 101;
         72  92  95  98  112 100 103 99];
%JPEG标准色度量化表    
Qc = [17 18 24 47 99 99 99 99;
      18 21 26 66 99 99 99 99;
      24 26 56 99 99 99 99 99;
      47 99 99 99 99 99 99 99;
      99 99 99 99 99 99 99 99;
      99 99 99 99 99 99 99 99;
      99 99 99 99 99 99 99 99;
      99 99 99 99 99 99 99 99;];
%Z顺序
order = [1 9  2  3  10 17 25 18 11 4  5  12 19 26 33  ...
        41 34 27 20 13 6  7  14 21 28 35 42 49 57 50  ...
        43 36 29 22 15 8  16 23 30 37 44 51 58 59 52  ...
        45 38 31 24 32 39 46 53 60 61 54 47 40 48 55  ...
        62 63 56 64];
%JPEG的DC编码
DcCode = ['00','010','011','100','101','110','1110','11110','111110','1111110','11111110','111111110'];

%导入并展示原图
rgb = imread('1.jpg');
subplot(2,2,1);
imshow(rgb);
%转换rgb通道为ycbcr通道
yuv = double(rgb2ycbcr(rgb));
%对图像进行分块处理
yuvDct(:,:,1) = blkproc(yuv(:,:,1),[8,8],'dct2');
yuvDct(:,:,2) = blkproc(yuv(:,:,2),[8,8],'dct2');
yuvDct(:,:,3) = blkproc(yuv(:,:,3),[8,8],'dct2');
subplot(2,2,2);
imshow(log(abs(yuvDct)));
 
%量化过程
yuvQ(:,:,1) = blkproc(yuvDct(:,:,1),[8 8], 'round(x./P1)',Qy);
yuvQ(:,:,2) = blkproc(yuvDct(:,:,2),[8 8], 'round(x./P1)',Qc);
yuvQ(:,:,3) = blkproc(yuvDct(:,:,3),[8 8], 'round(x./P1)',Qc);
 
%将图像重新排列为矩阵列
lineYuv(:,:,1) = im2col(yuvQ(:,:,1), [8 8], 'distinct');
lineYuv(:,:,2) = im2col(yuvQ(:,:,2), [8 8], 'distinct');
lineYuv(:,:,3) = im2col(yuvQ(:,:,3), [8 8], 'distinct');
xb = size(lineYuv(:,:,1),2);
lineYuv(:,:,1) = lineYuv(order,:,1);
lineYuv(:,:,2) = lineYuv(order,:,2);
lineYuv(:,:,3) = lineYuv(order,:,3); %行程编码
 
lineYuv(lineYuv<0)=0;
 
%对DC进行编码，将DC编码结果，放进字符串里
lineSize = size(lineYuv);
DC = zeros(lineSize(2),3); 
DCHuffman=string(zeros(1,3));
%遍历lineYuv三维数组，得出DC编码
for i=1:lineSize(2)
    if(i==1)
       DC(1,1)=lineYuv(1,i,1);
       DC(1,2)=lineYuv(1,i,2);
       DC(1,3)=lineYuv(1,i,3);
       DCHuffman(1)=dec2bin(DC(1,1));
       DCHuffman(2)=dec2bin(DC(1,2));
       DCHuffman(3)=dec2bin(DC(1,3));
    else
       DC(i,1)=lineYuv(1,i,1)-lineYuv(1,i-1,1);
       DC(i,2)=lineYuv(1,i,2)-lineYuv(1,i-1,2);
       DC(i,3)=lineYuv(1,i,3)-lineYuv(1,i-1,3);
       binDC1=dec2bin(DC(i,1));
       binDC2=dec2bin(DC(i,2));
       binDC3=dec2bin(DC(i,3));
       DCHuffman(1)=DCHuffman(1)+DcCode(length(binDC1))+binDC1;
       DCHuffman(2)=DCHuffman(2)+DcCode(length(binDC2))+binDC2;
       DCHuffman(3)=DCHuffman(3)+DcCode(length(binDC3))+binDC3;
    end
end


%对AC进行编码
%编码的个数太多了，放进txt里读入
[ac_RS, ~, ac_code] = textread('AcHuffman.txt', '%s%s%s');
ACHuffman=string(zeros(1,3));
%
for i=1:lineSize(2)
    encoY = runLengthEnco(lineYuv(2:64,i,1));
    encoU = runLengthEnco(lineYuv(2:64,i,2));
    encoV = runLengthEnco(lineYuv(2:64,i,3));
    for j=1:2:length(encoY)-1
        ACHuffman(1)=ACHuffman(1)+ac_code((encoY(j)+1)*(encoY(j+1)+1));
        
        if(encoY(j)==0 && encoY(j+1)==0)
           break; 
        end    
    end
    for j=1:2:length(encoU)-1
        ACHuffman(2)=ACHuffman(2)+ac_code((encoU(j)+1)*(encoU(j+1)+1));
        
        if(encoU(j)==0 && encoU(j+1)==0)
           break; 
        end    
    end  
    for j=1:2:length(encoV)-1
        ACHuffman(3)=ACHuffman(3)+ac_code((encoV(j)+1)*(encoV(j+1)+1));
        if(encoV(j)==0 && encoV(j+1)==0)
           break; 
        end    
    end  
    
end
 
strlength(ACHuffman(1)+ACHuffman(2)+ACHuffman(3)+DCHuffman(1)+DCHuffman(2)+DCHuffman(3))
yuvQb(:,:,1) = blkproc(yuvQ(:,:,1),[8 8], 'x.*P1',Qy);
yuvQb(:,:,2) = blkproc(yuvQ(:,:,2),[8 8], 'x.*P1',Qc);
yuvQb(:,:,3) = blkproc(yuvQ(:,:,3),[8 8], 'x.*P1',Qc);
yuvAfter(:,:,1) = blkproc(yuvQb(:,:,1),[8,8],'idct2');
yuvAfter(:,:,2) = blkproc(yuvQb(:,:,2),[8,8],'idct2');
yuvAfter(:,:,3) = blkproc(yuvQb(:,:,3),[8,8],'idct2');
subplot(2,2,3);
imshow(uint8(ycbcr2rgb(uint8(yuvAfter))));
 
 
function enco = runLengthEnco(sig)
    enco = zeros(1);
    k = 1;
    enco(k) = sig(1);
    enco(k+1) = 1;
    i = 2;
    while (i<=length(sig))
        if (sig(i)==enco(k))
            enco(k+1) = enco(k+1)+1;
        else
            k = k+2;
            enco(k) = sig(i);
            enco(k+1) = 1;
        end
        i = i+1;
    end
    enco = enco';
end
