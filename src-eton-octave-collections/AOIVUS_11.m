close all;
clear;
clc;
%% 参数输入 %%%%%%%%%%%%%%
N         =  1;                                                      %%  成像图数选择
v         =  100;                                                    %%  对数压缩参数
%%  默认参数  %%%%%%%%%%%%
A_Line    =  1004;                                                   %%  成像A-Line选择
sgnlgt    =  4096*2;                                                   %%  成像A-Line长度选择
sgnlgt_1  =  5600;                                                   %%  图像A-Line长度选择
%% TDMS数据读取 %%%%%%%%%%
TDMS      =  simpleConvertTDMS(false,'F:\Download\22222\12.tdms');   %%  确定是否生成.mat文件,true/false
T_DATA    =  TDMS.Data.MeasuredData(3).Data;                         %%  提取数据
AA_length =  length(T_DATA(:))/(A_Line*sgnlgt);                      %%  图像数
%% 成像 %%%%%%%%%%%%%%%%%
for i=1:A_Line
   ii=(i-1)*sgnlgt+N*A_Line*sgnlgt+1;                                  %% 数组选择
   DATA_1 = T_DATA(ii:ii+sgnlgt-1,1);                       %% 数组变换
   [output,fft_out,fft_in] = band_pass_filter_V2(DATA_1,10,95,500);    %% 数字滤波
   h = hilbert(output);                               %% 希尔伯特变换
   h = abs(h);                                        %% 取希尔伯特变换后的模
   H(i,:)=h(1:sgnlgt_1,1);                              %% 数据组成矩阵
end
 H_1 = log(1+v*H)/log(1+v);                           %% 线性-对数压缩
 H_1 =  H_1';                                         %% 矩阵变换
[output] = Polar_text_01( H_1,2001);                  %% 坐标变换、双线性插值
imshow(output, 'border', 'tight', 'initialmagnification', 'fit');  %% 图像设置
t = saveAsTiffdouble(output, [ 'F:\Data',num2str(j),'.tif']);      %% 图像存储为Tiff


caxis([-25,3]);
set (gcf, 'Position', [0,0, 900, 900]);
% saveas(gcf, [ 'F:\Data',num2str(j),'.png']);
% save(['E:\PO',num2str(j),'.mat'],'input','-v7.3','-nocompression') ;


%%
subplot(2,1,1);
plot(DATA_1);
title('滤波后信号时域波形');
xlabel('t(s)');
subplot(2,1,2);
plot( output );
title('滤波后信号幅度谱');
xlabel('f(hz)');

blf=fft(DATA_1); % 离散傅立叶变换
def=blf; % 取blf的数组长度
def=def*0; % 将def清零便于下面%

sfft=fft(DATA_1); % calculate Fast Fourier Transform
sfft_mag=abs(sfft); % take abs to return the magnitude of the frequency components
plot(sfft_mag, '-.'); % plot fft result


P2 = abs(Y/L); % 每个量除以数列长度 L
P1 = P2(1:L/2+1); % 取交流部分
P1(2:end-1) = 2*P1(2:end-1); % 交流部分模值乘以2
plot(f,P1)
