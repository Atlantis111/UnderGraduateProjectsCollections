origin=sum(abs(Cycs),1);  %累加到x轴，形成1*262143矩阵
y1=1:262143;
y2=1:262142;

m=ones(1,262142)*nan;          %求差值
for i=1:262142
        m(1,i)=origin(1,i+1)-origin(1,i);
end

[val_max,index_max]=max(m);     %输出差值最大处与最小处
[val_min,index_min]=min(m);     %最大处为开始点，最小处为结束点

accum_val_max=0;
for j = 1:262142                  %找出没有被排除的部分的最大值
	if origin(1,j)>accum_val_max 
        accum_val_max=origin(1,j);
        accum_index_max=j;
    end
end

bar(y1,origin)       %显示累加到x轴的图片
%bar(y2,m)       %显示差值图
