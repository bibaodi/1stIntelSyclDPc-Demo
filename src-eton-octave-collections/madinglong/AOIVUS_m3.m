function AOIVUS_m3(dataFrame)
##close all;
##clearvars -except dataFrame;
##clc;

pkg load signal;
% load('acr_debugDataBufF0007.mat');

NumScanlines = size(dataFrame,1);
NumSamples = size(dataFrame,2);
skipPBF = false;
skipRDS = true;
%% 从A-Line列对数据进行处理 %%
scanlines_raw = dataFrame;
if !skipPBF
    printf("using PBF\n");
    sampleRate = 250e6;
    filterOrder=7;
    stopFreq=9e6;
    #[b,a] = butter(filterOrder, [10, 75]*1e6/(sampleRate/2), 'bandpass');
    [b,a] = butter(filterOrder, stopFreq/(sampleRate/2), 'high');
    #[b,a] = butter(filterOrder, 20*1e6/(sampleRate/2), 'low');
    for i = 1:NumScanlines
        scanlines_filtered(i, :) = filter(b,a,scanlines_raw(i, :));
    end
else
    scanlines_filtered=scanlines_raw;
end

%% 从RHO列消除直流分量  %%
if !skipRDS
    print("using RDS\n");
    for i = 1:NumSamples
        rho = scanlines_filtered(i,:);                         %% 数据选取
        rho_ac = detrend(rho);                        %% 消除直流分量
        scanlines_detrend(i,:) = rho_ac;                   %% 矩阵输出
    end
else
    scanlines_detrend = scanlines_filtered;
end

##return ;
%%
usingkwaveEnv=true;
usingkwaveCompress=true;
addpath('/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/k-Wave:/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/k-Wave/examples');

scanlines_enved=envelopeDetection(scanlines_detrend);
scanlines_lgped=logCompression( scanlines_enved, 5, true);

usingBeihangCodesPart1=false;
if usingBeihangCodesPart1
    for j = 1:NumScanlines
        a_line = scanlines_detrend(:,j);                   %% 数据选取
        if usingkwaveEnv
            envLine=envelopeDetection(a_line);
        else
            envLine0 = hilbert(a_line);                   %% 希尔伯特变换
            envLine = abs(envLine0);                     %% 取希尔伯特变换后的模
        endif
        alines_envloped(:,j)=envLine;
        if usingkwaveCompress
            compressLine = logCompression(envLine, 1.5, true);
        else
            compressLine = 20*log10(envLine); #amplitude not power, change 10 to 20;
        endif
        alines_compressed(:,j) = compressLine;
    endfor
else
    alines_compressed= scanlines_lgped;
endif
maxPixelVal=max(alines_compressed(:));
scanlines_finishSigProc = 255 * alines_compressed / maxPixelVal;
#scanlines_finishSigProc = scanlines_finishSigProc - max(scanlines_finishSigProc(:));
#time0 = datetime('now');

rectImg = scanlines_finishSigProc.';
f1=figure('Name','RECT-01-image()', "Position", [0, 0, NumSamples, NumScanlines]);image(rectImg);
#f2=figure('Name','RECT-01-imagesc()');imagesc(rectImg);
#return;

## scan convert;
tic;
printf("beflore scan convert running.\n");
###############scan convert --begin
c0 = 1540;                      % [m/s]
totalAngle=360;
angleStep=totalAngle / NumScanlines;
steering_angles = (0.5:angleStep:360) -180; #eton-debug.work
image_size=[0.013, 0.013]; # assume it is 6.5mm depth;
deltaT = 2*image_size(1)/c0/NumSamples;

img_resolution=[512,512];
b_mode_img = scanConversionIvusEditionBasedonKwave(scanlines_finishSigProc, steering_angles, image_size, c0, deltaT, img_resolution);
###############scan convert --begin.end


#[outputImg] = Polar_text_01(scanlines_finishSigProc, NumSamples);
outputImg=b_mode_img;
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
