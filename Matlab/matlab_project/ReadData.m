clear all
close all
clc
filenamelist = {'nmavic2_frame_01_part0.'};

for loop = 1:1
    base_name=filenamelist{loop};
    N = 2^28;                                                                                                                                                                                                                                                                                                                                                                
    full_name=[base_name,'.data'];
    fid = fopen(full_name,'r');    
    dataRaw = fread(fid,536870912,'uint16');    % 数据文件1G 1个， 对应大小就是 536870912， 如果内存不够可以少读一些，改长度即可
    fclose(fid);
    data = floor(dataRaw/2);
    trig = mod(dataRaw,2);
    data(data>16383) = data(data>16383) - 32768;
    
    a=complex(data(1:2:end),data(2:2:end));
    res=complex(data(1:2:end),data(2:2:end));   % 这是原始的时域数据 
        
    [Cycs,f,t] = spectrogram(res,hamming(1024),512,1024,245.76e6,'centered');       % 这里的 Cycs 就是之前mat 文件的二维图， 如果内存不够可以少分析一些
                                                                              %举例， spectrogram(res（1:1000000),hamming(1024),512,1024,245.76e6,'centered');
                                                                              % 表示分析数据的前 1000000点，每一点的时间跨度是 1/122.88 us
                                                                              % 这个函数是matlab自带的，之前的数据是由硬件生成之后采集的，所以会有很小的差异
end
trigCycs = trig(1:1024:end);    %这里每1024 取一个，为的是和 Cycs 的时间轴同步

% 如果想和 时域数据 res 同步，取 trig(1:2:end)即可