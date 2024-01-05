function AOIVUS_m3(dataFrame)
##close all;
##clearvars -except dataFrame;
##clc;

pkg load signal;
% load('acr_debugDataBufF0007.mat');

NumScanlines = size(dataFrame,1);
NumSamples = size(dataFrame,2);
skipPBF = true;
%% 从A-Line列对数据进行处理 %%
scanlines_raw = dataFrame;
if !skipPBF
    printf("using PBF\n");
    sampleRate = 250e6;
    filterOrder=7;
    stopFreq=20e6;
    #[b,a] = butter(filterOrder, [10, 75]*1e6/(sampleRate/2), 'bandpass');
    [b,a] = butter(filterOrder, stopFreq/(sampleRate/2), 'high');
    #[b,a] = butter(filterOrder, 20*1e6/(sampleRate/2), 'low');
    for i = 1:NumScanlines
        scanlines_filtered(i, :) = filter(b,a,scanlines_raw(i, :));
    end
else
    scanlines_filtered=scanlines_raw;
end

scanline_beforeEnvDec = scanlines_filtered;
##return ;
%%
usingkwaveEnv=true;
usingkwaveCompress=true;
addpath('/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/k-Wave:/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/k-Wave/examples');

scanlines_enved=envelopeDetection(scanline_beforeEnvDec);
compressFactor=5;
scanlines_lgped=logCompression(scanlines_enved, compressFactor, true);

alines_compressed= scanlines_lgped;

maxPixelVal=max(alines_compressed(:));
scanlines_finishSigProc = 255 * alines_compressed / maxPixelVal;

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
angleStep=totalAngle / (NumScanlines-1);
steering_angles = (0:angleStep:360) -180; #eton-debug.work
image_size=[0.013, 0.013]; # assume it is 6.5mm depth;
deltaT = 2*image_size(1)/c0/NumSamples;

img_resolution=[512,512];
b_mode_img = scanConversionIvusEditionBasedonKwave(scanlines_finishSigProc, steering_angles, image_size, c0, deltaT, img_resolution);
###############scan convert --begin.end

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
