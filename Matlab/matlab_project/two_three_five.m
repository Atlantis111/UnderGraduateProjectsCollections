z1_copy=z1(1:1024,500:523886);     %z1副本,去除前500个值
sum_length=523387;      %信号矩阵总长度
slice = 5760;       %切分的长度
y_spot = 510;       %判断时所取y轴的坐标
sum_coord = [];     %存放提取的全坐标
fingerprint = [1920,2880];      %脉宽指纹库(待改）
deviation = 50;     %允许脉宽偏差
standby =[];        %待命区
test =[];           %测试数组

while 1
    inserted = [];      %存放待插入的数
    for i=1:1:floor(sum_length/slice)
        temp = z1_copy(y_spot,(i-1)*slice+1:i*slice);     %对每一个切片
        
        Fs = 1; %采样频率
        MinPeakProminence = max(temp)/4; %峰最小突起幅度门限
        threshold = 0; %峰值点与邻近点比较门限
        MinPeakHeight = 0; %最小峰高度门限,原为max(temp)/20，改为0
        MinPeakDistance = length(temp)/Fs-2; %最小峰间距门限
        nPeaks = 1; %最多找nPeaks个峰
        sortstr = 'none'; %结果排序
        Annotate = 'extents'; %丰富的输出
        %峰宽度计算标准,halfprom:半突起幅度宽； halfheight:半高宽
        WidthReference = 'halfprom';

        [max_value,max_index] = findpeaks(temp,'MinPeakDistance',1000,'nPeaks',1);

%         [max_value,max_index] = min(temp);      %找到其最大值和最大值位置
        inserted = [inserted max_index + (i-1)*slice + 500];        %存入最大值对应下标
%         z1_copy(y_spot,max_index)=-inf;          %赋予最大数以规避下一次最小值查找
        corr_num = 0;                           %脉宽正确数
    end
    %存数过程
    for j = 1:1:length(inserted)
        if isempty(sum_coord)      %直接放入第一批坐标
            sum_coord = inserted;
            break;
        end
        for n = 1:length(sum_coord)         %有位置插入则插入,无则待命
            if inserted(j)>sum_coord(n) && inserted(j)<sum_coord(n+1) ...       %如果有相距1920或2880的点在坐标数组中，则按顺序插入；若无，则放至待命区
                && ((sum_coord(n+1)-inserted(j)>fingerprint(1)-deviation && sum_coord(n+1)-inserted(j)<fingerprint(1)+deviation)...
                ||(sum_coord(n+1)-inserted(j)>fingerprint(2)-deviation && sum_coord(n+1)-inserted(j)<fingerprint(2)+deviation))
                sum_coord = [sum_coord(1:n) inserted(j) sum_coord(n+1:len(sum_coord))];
            else
                inserted = [inserted inserted(j)];
            end
        end
        for m = 1:1:length(sum_coord)-1       %判断坐标是否相连
            if (sum_coord(m+1)-sum_coord(m)>fingerprint(1)-deviation && sum_coord(m+1)-sum_coord(m)<fingerprint(1)+deviation) ...
                    || (sum_coord(m+1)-sum_coord(m)>fingerprint(2)-deviation && sum_coord(m+1)-sum_coord(m)<fingerprint(2)+deviation)...
                    || (sum_coord(m+1)-sum_coord(m)<40)
                corr_num = corr_num + 1;
            end
        end  
    end
    if corr_num > (sum_length/2880)*0.5      %大于某一概率，标记为有该电台型号出现
        disp("有该型号电台出现")
        break;
    end
end


% fingerprint=zeros(1,15);   %存放指纹
% while 1
%     input_fingerprint=input(prompt);
%     if input_fingerprint~="end"
%         fingerprint(end+1)=input(prompt);
%     else
%         break
%     end 
% end





