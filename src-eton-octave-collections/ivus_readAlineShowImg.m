#eton@240103 read alines in multi files then show image;
close all;clear all;clc;

addpath("/media/eton/hdd931g/42-workspace4debian/10-ExtSrcs/61.231030-DP-CL-MP-HPC/41-sycl-tutorials-eton/src-eton-octave-collections/madinglong");
    #filepath="/home/eton/42workspace.lnk/51-develop/33-data-analyse/231220-rfdatas"
    filepath="/home/eton/42workspace.lnk/51-develop/33-data-analyse/231215-5mhz"
    #filepath="/home/eton/42workspace.lnk/51-develop/33-data-analyse/240105-vessels/atdN4-1";
    filepath="/home/eton/42workspace.lnk/51-develop/33-data-analyse/240105-vessels/atdN4-2";

scalinedataFrame = ivus_readLinesBinDataV1(filepath);
NumSamples=size(scalinedataFrame)(end);
NumScalines=size(scalinedataFrame)(1);
#------------using fft1d;
using1Dfft=9;
if using1Dfft
    NumSamples=size(scalinedataFrame)(end);
    NumScalines=size(scalinedataFrame)(1);

    ringdownStartIdx=NumSamples/3;
    tobeAnalysedRemoveRingdownData=scalinedataFrame(2, ringdownStartIdx:NumSamples);
    NumSamples = NumSamples - ringdownStartIdx + 1;

    xSummed=sum(tobeAnalysedRemoveRingdownData, 1) / NumScalines;#sum all same depth point in all alines; return the length of one line;
    yfft=fft(xSummed);
    #yfft=fft(scalinedataFrame(1,:));
    yfft0 = fftshift(yfft);         % shift y values

    sampleRate=250;
    freq_range=(0:NumSamples-1)*(sampleRate/NumSamples);
    #ypower = abs(yfft).^2/NumSamples;
    freq_range0 = (-NumSamples/2:NumSamples/2-1)*(sampleRate/NumSamples); % 0-centered frequency range
    ypower0 = abs(yfft0).^2/NumSamples;    % 0-centered power
    # ---------remove 0hz --begin;
    remove0hz=true;
    if remove0hz
        i=-3;
        rangeCenterIdx=cast(length(ypower0)/2, "int32");
        do
            ypower0(rangeCenterIdx+i)=1 ;#//adjust 0Hz value in fft;
            i++;
        until (i>3)
    endif
    # ---------remove 0hz --begin.end;
    valueMax=max(ypower0);
    normalizedY=ypower0/valueMax;
    plot(freq_range0, normalizedY);
    xlabel('Frequency(MHZ)');
    ylabel('Power');
endif
#------------using fft2;
using2Dfft=false;
if using2Dfft
    yfft2d=fft2(scalinedataFrame);
    yfft2d0 = fftshift(yfft2d);         % shift y values
    figure("Name", "rf-data");imagesc(scalinedataFrame);
    figure("Name", "fft2-0");imagesc(abs(yfft2d0))
    sampleRate=250;
    freq_range=(0:NumSamples-1)*(sampleRate/NumSamples);
    #ypower = abs(yfft2d).^2/NumSamples;
    freq_range0 = (-NumSamples/2:NumSamples/2-1)*(sampleRate/NumSamples); % 0-centered frequency range
    ypower0 = abs(yfft2d0).^2/NumSamples;    % 0-centered power

    figure("Name", "spectural");plot(freq_range0, ypower0);
    xlabel('Frequency(MHZ)');
    ylabel('Power');
endif
#return;
#------------using signal path;
ringdownStartIdx=NumSamples/3;
tobeProcessData=scalinedataFrame(:, ringdownStartIdx:NumSamples);;
ivus_signalProcessV1(tobeProcessData);

#end.
