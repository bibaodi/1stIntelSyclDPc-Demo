close all;
clearvars -except dataFrame;
clc;

% load('F:\Windows\Documents\MATLAB\acr_debugDataBufF0007.mat');                 %% 数据读取
% load('F:\Windows\Documents\MATLAB\VesselStentFrame20231121.mat');
% load('F:\Windows\Documents\MATLAB\231122-datas.mat');
% load('F:\Windows\Documents\MATLAB\PIUstentVessel01.mat');
% load('F:\Windows\Documents\MATLAB\vesselStent1123-1.mat');
nAline = size(dataFrame,2);
skipPBF = 1;
skipRDS = 1;
%% 从A-Line列对数据进行处理 %%
fs = 250e6;
[b,a] = butter(6,[10 75]*1e6/(fs/2),'bandpass');
dataCache = dataFrame;
if skipPBF ~= 1
    for i = 1:nAline
        dataCache(:,i) = filter(b,a,dataCache(:,i));
    end
end

%% 从RHO列消除直流分量  %%
nPts = size(dataFrame,1);
if skipRDS ~= 1
    for i = 1:nPts
        rho = dataCache(i,:);                         %% 数据选取
        rho_ac = detrend(rho);                        %% 消除直流分量
        data_out_rho(i,:) = rho_ac;                   %% 矩阵输出
    end
else
    data_out_rho = dataCache;
end
%%
for j = 1:nAline
    a_line = data_out_rho(:,j);                   %% 数据选取
    a_line_j = hilbert(a_line);                   %% 希尔伯特变换
    a_line_j = abs(a_line_j);                     %% 取希尔伯特变换后的模
%     data_out_aline(:,j) = 10*log10(a_line_j./max(a_line_j(:)));
    data_out_aline(:,j) = 20*log10(a_line_j); #amplitude not power, change 10 to 20;
end
data_out_aline = data_out_aline - max(data_out_aline(:));
#time0 = datetime('now');
tic;
printf("beflore polar running.")
%% 图像显示 %%

#ElapsedFun = @()
[outputImg] = Polar_text_01(data_out_aline,nPts);
toc; #time1 = datetime('now'); above function will cost [Elapsed time is 27.3513 seconds.]

#consumedTime=timeit(ElapsedFun);
#printf("consumed time=:%d\n", consumedTime);

imshow(outputImg, 'border', 'tight', 'initialmagnification', 'fit');  %% 图像设置
% caxis([1250,4000]);
caxis([-15, 0]);
set (gcf, 'Position', [0,0, 600, 600]);
