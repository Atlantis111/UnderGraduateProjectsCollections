origin=sum(abs(Cycs),2);  %累加到y轴，形成1024*1矩阵
q=reshape(origin,1,[]);         %重构为1行1024列
x1=1:1024;
x2=1:1023;

m=ones(1023,1)*nan;             %m存放原矩阵的差值
for i=1:1023
        m(i,1)=origin(i+1,1)-origin(i,1);
end

[val_max,index_max]=max(m);     %输出差值最大处与最小处
[val_min,index_min]=min(m);     %最大处为开始点，最小处为结束点
bar(x1,q)       %显示累加到y轴的图片
%bar(x2,m)       %显示差值图