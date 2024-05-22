clear all
close all
clc

% load flt10m.mat

% fid = fopen('1950.data','r');
% data = fread(fid,3774873600/10,'int16');
% res=complex(data(1:2:end),data(2:2:end));
% % plot(abs(fft(res(end-1000:end))))
% len=length(res);
% len=floor(len/10)*10;
% for i=1:10
% subplot(3,4,i);
% plot(20*log10(abs(fft(res( (i-1)*len/10+1:i*len/10 )))));grid on;
% end


% ver 8g
start_data = zeros(8,10);
end_data = zeros(8,10);
max_pos = zeros(8);
max_value = zeros(8);

% filenamelist = { '20210314_part',...
%             '20210304-1980-10dbm_part',...
%             '210304-1990-10_part',...
%             '2010mhz-10dbm_part',...
%             '111_part'};
        
% filenamelist = { '0324_1signal_part'};    
% filenamelist = { '0330_04_dji_44m_part'};    
% filenamelist = { '0330_wifi_01_-0.5m_part'};  
% filenamelist = { '0331_holystone_01_5.18g_part'};  
% filenamelist = { '0802_wifi_01_2450_part'};  
% filenamelist = { '0802_wifidji_01_2450_2464.5_part'}; 
% filenamelist = { '0802_wifidji_02_2450_2464.5_part'}; 
% filenamelist = { '0802_wifidji_03_2450_2464.5_part'}; 
% filenamelist = { '0802_wifidji_04_2450_2464.5_part'}; 
% filenamelist = { '0803_ltedji_04_5800_5831_part'}; 
% filenamelist = { '0803_ltedji_04_5831_part'}; 
% filenamelist = { '0807_ltedji_01_5800_5822_part'}; 
% filenamelist = { '0810_dji2_01_5829.5_5838.5_part'}; 
% filenamelist = { '0810_dji1_01_5800.5_part'}; 
% filenamelist = { '0810_dji2_01_5800.5_5838.5_part'}; 
% filenamelist = { '0811_dji1_01_5828.5_part'}; 
% filenamelist = { '0817_nframe_5800_part'}; 
% filenamelist = { '0817_nframenoise_5800_part'}; 
% filenamelist = { '0819_noise_5800_part'}; 
% filenamelist = { '0904_nframe_5800_10m_part'};    
% filenamelist = { '0904_nframenoise_5800_10m_part'}; 
% filenamelist = { '0914_two20m02_fnoise_5800_5805_8ms_part'}; 
% filenamelist = { '0922_two20m_fnoise_5800_8ms_part'};
filenamelist = { 'nmavic2_frame_01_part2.'};



index=1;
res=[];
for loop = 1:1
%     base_name='20210314_part';
    base_name=filenamelist{loop};
    N = 2^28;                                                                                                                                                                                                                                                                                                                                                                
    for index_top=1:1   
%         full_name=[base_name num2str(index_top-1) '..data'];
        full_name=[base_name  '.data'];
        fid = fopen(full_name,'r');
%         fid = fopen("0324_1signal_part0..data",'r');

        data = fread(fid,536870912,'int16');
%         data = fread(fid,'int16');
        fclose(fid);
        a=complex(data(1:2:end),data(2:2:end));
        res=[res,a.'];        
%         start_data(index_top,:) = res(1:10);
%         end_data(index_top,:) = res(end-9:end);
    %     FFT_res = 20*log10(abs(fft(res.*hanning(536870912/2))));
%         [FFT_res,f,pxxc] = pwin_mine(res,N);
%         FFT_res=pwelch(res(1:268435456,1),hamming(268435456),268435456/2,268435456,245.76);
%         [max_value(index_top,index), max_pos(index_top,index)]=max(FFT_res);
%         max_value(index_top,index) = 20*log10(max_value(index_top,index));
    %     max_value(index_top) = mean(abs(res).^2);
        heh=1;
    %     subplot(3,3,index_top);
    %     plot(20*log10(abs(fft(res))));grid on;
    end
    index=index+1;
end

spectrogram(res(1:1024*32768*1),hamming(1024),0,1024,245.76*10^6,'centered')

 c=real(res);
 for i=1:length(res)
     if c(i)<0
         d(i)=c(i)+65536;
     else
         d(i)=c(i);
     end
 end

e=mod(d,2);



% for index_top=1:7
% subplot(3,3,index_top);
% plot([real(end_data(index_top,:)) real(start_data(index_top+1,:))]);
% end

%%%%%%%%%%%%%%%%

% n=1:length(res);
% mixer=exp(j*2*pi*-44*n/245.76);
% mixres=mixer.*res;
% fmixres=conv(mixres,flt10m);
% 
% ares=abs(fmixres);
% lares=20*log10(ares);
% a32=ones(1,512);
% alares=conv(lares,a32);
% 
% cres=zeros(1,length(alares));
% for loop=1:length(alares)
%     if alares(loop)>20500
%         cres(loop)=1;
%     else
%         cres(loop)=0;
%     end
% end 
% 
% n=1;
% for loop=2:length(cres)
%     if (cres(loop-1)==0 && cres(loop)==1) || (cres(loop-1)==1 && cres(loop)==0)
%         togglepoint(n)=loop;
%         n=n+1;
%     end
% end 
% 
% %%%%%%%%%%%%%%%%
% 
% %filenamelist = { '0330_04_dji_44m_part'};   1 and 2 
% 
% k=1:1:437;
% jiange(k)=togglepoint(2*k+2)-togglepoint(2*k);
% plot(jiange./245.76./1000,'*')



