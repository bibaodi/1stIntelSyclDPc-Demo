#{---
#this block for debug this function;
close all;
clearvars;
datafile='/media/eton/hdd931g/42-workspace4debian/51-develop/33-data-analyse/240105-vessels/fromOndaPulse/probeTx240105_PAT_00.data'
###}
    pkg load signal;
#function [dataArray, dataEnvd]=ivus_readOscilloscopeDataV1(datafile, isFigure)
    # input: datafile is the data file;
    # output: dataArray is the double data array ;
    # output: dataEnvd is the envoloped double data array ;
    # eton@240111;
    # format:[[int32(len), double(data repeat len times)], []...]; eton@240119 change from read first line to all line;
    fd=fopen(datafile);
    fseek (fd, 0, 'eof'); filesize = ftell (fd) ;
    int32Is4Bytes=4;
    doubleIs8Bytes=8;

    fseek(fd, 0);

    itemLen=fread(fd, [1,1], 'int32');#this is total length in double type;
    oneDataItemLenInBytes = doubleIs8Bytes * itemLen + int32Is4Bytes;
    fileDataCount=filesize / oneDataItemLenInBytes;
    NumScalines = filesize / oneDataItemLenInBytes;
    dataArray=zeros(fileDataCount, itemLen);
    dataEnvdArray=zeros(fileDataCount, itemLen);
    lineIdx=1;
    while ~isempty(itemLen)
        oneItemBuf = fread(fd,[itemLen 1],'double');
        #dataArray{lineIdx} = oneItemBuf;
        dataEnvd=abs(hilbert(oneItemBuf));
        dataArray(lineIdx, :) = oneItemBuf;
        dataEnvdArray(lineIdx, :) = dataEnvd;
        itemLen = fread(fd,[1 1],'int32');
        lineIdx =lineIdx+1;
    endwhile
    fclose(fd);

    if nargin <2
        isFigure=false;
    endif

    if 1#isFigure
        maxV=max(dataEnvd(:));
        averageV=sum(dataEnvd(:)) / length(dataEnvd);
        noisePower =averageV;
        SNR = (maxV - noisePower)/noisePower;
        SNR = 10 * log10(SNR);
        plot(dataEnvd/maxV);
        stitle=sprintf("normalized envelop data. SNR=%fDB.", SNR);
        title(stitle);

        xSummed=sum(dataArray, 1) / NumScalines;#average all scanlines to one;

        figure("Name", "all datas in mesh");mesh(dataArray);
        figure("Name", "all EnvdDatas in mesh");mesh(dataEnvdArray);
    endif
#endfunction
# SNR not support in octave;https://terpconnect.umd.edu/~toh/spectrum/functions.html
# using opensource : https://github.com/juanfonsecasolis/computeSnr.git


return;
#{
close all;
clearvars;
dataf='/media/eton/hdd931g/42-workspace4debian/51-develop/33-data-analyse/240105-vessels/fromOndaPulse/probeTx240105_PAT_00.data'
dataBuf=ivus_readOscilloscopeDataV1(dataf);
dataEnvd=abs(hilbert(dataBuf));
maxV=max(dataEnvd(:));
plot(dataEnvd/maxV);
#}
#end function
