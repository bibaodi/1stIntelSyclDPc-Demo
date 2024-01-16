##{
#debug below function;
close all;clear all;clc;
filepath="/home/eton/42workspace.lnk/51-develop/33-data-analyse/231215-5mhz"
#filepath="/home/eton/42workspace.lnk/51-develop/33-data-analyse/231220-rfdatas"
#filepath="/home/eton/42workspace.lnk/51-develop/33-data-analyse/240105-vessels/atdN4-1";
#filepath="/home/eton/42workspace.lnk/51-develop/33-data-analyse/240105-vessels/atdN4-3";
addpath("/media/eton/hdd931g/42-workspace4debian/10-ExtSrcs/61.231030-DP-CL-MP-HPC/41-sycl-tutorials-eton/src-eton-octave-collections/");
scanlinesData = ivus_readLinesBinDataV1(filepath);
scanlinesData = scanlinesData.';
toolboxPath='/home/eton/00-src/30-octaves/synaptus';
addpath(fullfile(toolboxPath,'core'),fullfile(toolboxPath,'misc'));
pkg load signal;
pkg load image;
##}
#function [im,phiIm,rIm]=ivus_SAFT_V1(scanlinesData)
## eton-debug.begin
ptp=scanlinesData;
NumScanlines=size(scanlinesData,2);
cc=1540;
fs=250e6;
tDelay=0;
phiStep=2*pi/(NumScanlines-1);
r0=1e-4;#0.1mm, unit is meter;; ##cannot be zero, else will lead to error;
fHigh = 70e6;#fs/2;#
fLow = 7e6;#fHigh/3;#
## eton-debug.begin.end

%% Set processing parameters
rStep = (cc/2)/(fHigh-fLow);                % Range resolution
rStart = r0 + (tDelay*(cc/2));              % Start of focused image
rEnd = rStart + (size(ptp,1)/fs)*(cc/2);    % End of focused image
#rEnd = 4.5e-3;#3mm;

transFunc = 'haun';     % Transfer function, options 'haun', 'gardner', 'exact'

%% Focus
disp('Processing data')
tic
[im,phiIm,rIm] = cpsm(ptp,fs,tDelay,cc,fLow,fHigh,phiStep,r0,rStep,...
    rStart,rEnd,'transFunc',transFunc);
toc
%% Plot raw data and focused image
figure("Position", [0, 0, 1900, 840]);subplot(1,2,1),
polRawDataImage(abs(hilbert(ptp)),tDelay+(0:(size(ptp,1)-1))/fs,phiIm,...
    [],[],r0,cc)
subplot(1,2,2),
polFocusedImage(abs(im),phiIm,rIm,[],[])
title("left origin, right apply SAFT.");
saveas(gcf, strcat(filepath, "/img-saft.png"));
disp('end of demo SAFT... \n by eton. ')
