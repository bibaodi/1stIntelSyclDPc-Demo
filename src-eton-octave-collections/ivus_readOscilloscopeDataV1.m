function [dataArray, dataEnvd]=ivus_readOscilloscopeDataV1(datafile, isFigure)
    # input: datafile is the data file;
    # output: dataArray is the double data array ;
    # output: dataEnvd is the envoloped double data array ;
    # eton@240111;
    fd=fopen(datafile);
    fseek(fd, 0);
    b1=fread(fd, [1,1], 'int32');#this is total length in double type;
    buf=fread(fd, [b1, 1], 'double');
    dataArray=buf;
    fclose(fd);

    pkg load signal;
    dataEnvd=abs(hilbert(dataArray));

    if nargin <2
        isFigure=false;
    endif

    if isFigure
        maxV=max(dataEnvd(:));
        averageV=sum(dataEnvd(:)) / length(dataEnvd);
        noisePower =averageV;
        SNR = (maxV - noisePower)/noisePower;
        SNR = 10 * log10(SNR);
        plot(dataEnvd/maxV);
        stitle=sprintf("normalized envelop data. SNR=%fDB.", SNR);
        title(stitle);
    endif
endfunction
# SNR not support in octave;https://terpconnect.umd.edu/~toh/spectrum/functions.html
# using opensource : https://github.com/juanfonsecasolis/computeSnr.git


return;
close all;
clearvars;
dataf='/media/eton/hdd931g/42-workspace4debian/51-develop/33-data-analyse/240105-vessels/fromOndaPulse/probeTx240105_PAT_00.data'
dataBuf=ivus_readOscilloscopeDataV1(dataf);
dataEnvd=abs(hilbert(dataBuf));
maxV=max(dataEnvd(:));
plot(dataEnvd/maxV);
#end function
