%加载目标文件至变量a，存为一struct类型的变量
%a=load('E:/xinhao/xujia/CyclicSpec_650_740/CyclicSpec_650_740.7z/CyclicSpec_650_740.mat');
%BP1 = struct2cell(a);
%matrix = cell2mat(BP1);
%按列的方式对矩阵求和
A=sum(abs(stdMetric),1);
%按行的方式读取矩阵
B=sum(abs(stdMetric),2);

max_num=max(max(A));
min_num=min(min(A));

find(A>100)
