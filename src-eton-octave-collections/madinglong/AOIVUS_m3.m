close all;
clearvars -except dataFrame;
clc;

pkg load signal;

% load('F:\Windows\Documents\MATLAB\acr_debugDataBufF0007.mat');                 %% 数据读取
% load('F:\Windows\Documents\MATLAB\VesselStentFrame20231121.mat');
% load('F:\Windows\Documents\MATLAB\231122-datas.mat');
% load('F:\Windows\Documents\MATLAB\PIUstentVessel01.mat');
% load('F:\Windows\Documents\MATLAB\vesselStent1123-1.mat');
nAline = size(dataFrame,2);
skipPBF = true;
skipRDS = true;
%% 从A-Line列对数据进行处理 %%
fs = 250e6;
[b,a] = butter(6,[10 75]*1e6/(fs/2),'bandpass');
dataCache = dataFrame;
if !skipPBF
    print("using PBF\n");
    for i = 1:nAline
        dataCache(:,i) = filter(b,a,dataCache(:,i));
    end
end

%% 从RHO列消除直流分量  %%
nPts = size(dataFrame,1);
if !skipRDS
    print("using RDS\n");
    for i = 1:nPts
        rho = dataCache(i,:);                         %% 数据选取
        rho_ac = detrend(rho);                        %% 消除直流分量
        data_out_rho(i,:) = rho_ac;                   %% 矩阵输出
    end
else
    data_out_rho = dataCache;
end

##return ;
%%
usingkwaveEnv=true;
usingkwaveCompress=true;
addpath('/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/k-Wave:/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/k-Wave/examples');

for j = 1:nAline
    a_line = data_out_rho(:,j);                   %% 数据选取
    if usingkwaveEnv
        envLine=envelopeDetection(a_line);
    else
        envLine0 = hilbert(a_line);                   %% 希尔伯特变换
        envLine = abs(envLine0);                     %% 取希尔伯特变换后的模
    endif
    %     data_out_aline(:,j) = 10*log10(a_line_j./max(a_line_j(:)));
    alines_envloped(:,j)=envLine;
    if usingkwaveCompress
        compressLine = logCompression(envLine, 3, true);
    else
        compressLine = 20*log10(envLine); #amplitude not power, change 10 to 20;
    endif
    alines_compressed(:,j) = compressLine;
    #data_out_aline(:,j) = compressLine;
endfor
maxPixelVal=max(alines_compressed(:));
data_out_aline = 255 * alines_compressed / maxPixelVal;
#data_out_aline = data_out_aline - max(data_out_aline(:));
#time0 = datetime('now');

rectImg = data_out_aline;
f1=figure('Name','RECT-01-image()', "Position", [0, 0, 512, 512]);image(rectImg);
f2=figure('Name','RECT-01-imagesc()');imagesc(rectImg);
#return;

## scan convert;
tic;
printf("beflore polar running.")
%% 图像显示 %%

#ElapsedFun = @()
[outputImg] = Polar_text_01(data_out_aline, nPts);
f3=figure('Name','SCVVT-01-image()', "Position", [0, 0, 512, 512]);image(outputImg); ## imshow would be fixed, but image() will auto fit window size;--eton@240104.
#return;
toc; #time1 = datetime('now'); above function will cost [Elapsed time is 27.3513 seconds.]

#consumedTime=timeit(ElapsedFun);
#printf("consumed time=:%d\n", consumedTime);
#imshow(outputImg);##try convert or just specify [min, max]; b2bi=cast(outputImg, "uint8");
f4=figure('Name','SCVVT-01-imshow');imshow(outputImg,[0,255], 'tight', 'initialmagnification', 'fit');  %% 图像设置
title("SCVVT-01");
#caxis([-15, 0]); should be `caxis([0,255]); caxis("auto");` matlab changed to clim("auto");
caxis("auto");
#set (gcf, 'Position', [0,0, 1, 1]);
get(f4, "Position");
movegui('center');


#end./
