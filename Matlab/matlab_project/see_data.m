serch_range_flag=[0,0,1,1,1,1,0,0,1,1,0,1,1,1,0,1,1,1,1];
%3-6 9-10 12-14 16-19
serch_range_flag2=[0,0,1,1,1,1,0,0,1,1,0,1,1,1,0,1,1,1,0];
%3-6 9-10 12-14 16-18
serch_range_flag3=[0,0,1,1,1,1,0,0,1,1,0,1,1,1,0,0,1,0,1];
%3-6 9-10 12-14 17 19
serch_range_flag4=[0,0,1,1,1,1,0,0,1,1,0,1,1,1,0,0,0,0,0];
%3-6 9-10 12-14
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
            if (i==len)         %排除最后为1.0.1的情况
                start=i+1;
                break;
            end
            for j=i+1:len
                if serch_range_flag(j)==0
                    disp(j-1)
                    disp("一组")
                    start=j+1;
                    flag2=1;
                    break;
                end
                if j==len       %单个值充当左边界与右边界的情况
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