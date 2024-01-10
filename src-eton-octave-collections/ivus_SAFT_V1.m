function [im,phiIm,rIm]=ivus_SAFT_V1(scanlinesData)
## eton-debug.begin
ptp=scanlinesData;
NumScanlines=size(scanlinesData,2);
cc=1540;
fs=250e6;
tDelay=0;
phiStep=2*pi/(NumScanlines-1);
r0=1e-6;#0.05mm; ##cannot be zero, else will lead to error;
fHigh = 70e6;#fs/2;#
fLow = 10e6;#fHigh/3;#
## eton-debug.begin.end

%% Set processing parameters
rStep = (cc/2)/(fHigh-fLow);                % Range resolution
rStart = r0 + (tDelay*(cc/2));              % Start of focused image
rEnd = rStart + (size(ptp,1)/fs)*(cc/2);    % End of focused image

transFunc = 'haun';     % Transfer function, options 'haun', 'gardner', 'exact'

%% Focus
disp('Processing data')
tic
[im,phiIm,rIm] = cpsm(ptp,fs,tDelay,cc,fLow,fHigh,phiStep,r0,rStep,...
    rStart,rEnd,'transFunc',transFunc);
toc
%% Plot raw data and focused image
figure;subplot(1,2,1),
polRawDataImage(abs(hilbert(ptp)),tDelay+(0:(size(ptp,1)-1))/fs,phiIm,...
    [],[],r0,cc)
subplot(1,2,2),
polFocusedImage(abs(im),phiIm,rIm,[],[])
title("left origin, right apply SAFT.");
disp('end of demo SAFT... \n by eton. ')
