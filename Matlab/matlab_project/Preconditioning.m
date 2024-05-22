origin=sum(abs(Cycs),2);  %累加到y轴，形成1024*1矩阵
q=reshape(origin,1,[]);         %重构为1行1024列
x1=1:1024;

m=ones(1023,1)*nan;             %m矩阵存放原矩阵的差值
count=zeros(1,1013);          
for i=1:1023                %求差值矩阵
        m(i,1)=origin(i+1,1)-origin(i,1);
end
for i=1:1013                %count数组存放某下标处的值比后十个值小的个数，
    for j=1:10              %用于找出最小点
        if m(i)<m(i+j)
            count(i)=count(i)+1;
        end
    end
end
%输出差值最大处与最小处  最大处为开始点，最小处为结束点
serch_range_flag=zeros(1,1023);     %用于排除已被分割出的部分
while 1
    flag=0;
    flag1=0;
    val_max=0;
    index_max=0;
    for j = 1:1023                  %找出没有被排除的部分的最大值
        if serch_range_flag(j)==0 && m(j)>val_max 
            val_max=m(j);
            index_max=j;
        end
    end
    if val_max < 1E9                %最大值低于阈值，表示处理完毕
        break;
    end
    while val_max > 1E9
        for i=index_max:1013        %高于阈值，在后面继续寻找最小值
            if (i-index_max>100) || (i==1013)     %找到结尾或者超出后100都没有找到，则退出
                flag=1;
                serch_range_flag(index_max)=1;
                break;
            end
            if (count(i)>=10) && (abs(m(i)) > val_max/3) && (i-index_max>10)     
                                %寻找比自身后十个值大，并且绝对值不小于最大值的第一个数，
                                %认为它是最小值,并且排除了小段波动情况
                %disp(index_max-3)
                %disp(i+3)
                %disp("一组")
                for q=index_max-3:i+3       %下次不在这个范围内搜索
                    serch_range_flag(q)=1;
                end
                flag=1;
                break;
             end      
        end
        if (flag==1)
            break;
        end
    end
end

disp("分割结果")

start=1;
len=length(serch_range_flag(:));
while 1
    flag2=0;
    if start==len+1 || i==len     %排除最后为1时和最后为0时，已经找完所有数字的情况
        break;
    end
    for i=start:len
        if serch_range_flag(i)==1
            disp(i)
            fprintf('%c',8);
            if (i==len)         %排除最后为1.0.1的情况
                start=i+1;
                break;
            end
            for j=i+1:len
                if serch_range_flag(j)==0
                    disp(j-1)
                    fprintf('%c',8);
                    disp("一组")
                    start=j+1;
                    flag2=1;
                    break;
                end
                if j==len       %最右出现单个值充当边界的情况
                    disp(j)
                    disp("一组")
                    start=j+1;
                    flag2=1;
                    break;
                end
            end
            if flag2==1
                break;
            end
        end
    end
end