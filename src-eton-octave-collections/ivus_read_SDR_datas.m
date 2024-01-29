# eton@240129 read sdr data;
clearvars;
close all;
f0='/tmp/acr_dataFrame0000.bin'
f0='/tmp/nn/acr_dataFrame0002.bin'
fileSize1=dir(f0).bytes;
f0fd=fopen(f0, 'r')
fseek(f0fd, 0, SEEK_END);
fileSz2=ftell(f0fd);

fseek(f0fd, 0, SEEK_SET);

numScanline=fread(f0fd, 1, 'int32');
fixedHeadLen=256;
elementLen=4;#int32=4byte
leftheadLen=fixedHeadLen-4;
head=fread(f0fd, leftheadLen);
printf("head:%s\n",head);

scanlineLength=(fileSz2 - fixedHeadLen) / numScanline/elementLen;
printf("%d scanlines, %d elements one line\n", numScanline, scanlineLength-2);
for scanlineIdx=1:numScanline
    datas=fread(f0fd, scanlineLength, 'int32');
    scanlineIdxInFrame= datas(1);
    NumOfEle= datas(2);
    actualData=datas(3:end);
    printf("%d: index=%d, NofEle=%d, first element=%d\n", scanlineIdx, datas(1),  datas(2), datas(3));
endfor
