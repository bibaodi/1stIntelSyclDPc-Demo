#eton@240219 find the frame all data is zeros;
#input: mhd file;
#output: csv file;
clearvars;close all;
generateVideoFile=false;
needUserConfirm=false;

mhdfileName="/media/eton/zhitai01/240125-animalDatas/cachedata_20240126T191724_3.mhd";

[~, metaInfo]=metaImageIOread(mhdfileName,  -1);
frameCount=metaInfo.DimSize(3);#[lineNum, samlieNum, frameNum]

dimInfoStr= mat2str(metaInfo.DimSize(1:2));
strHeader01=sprintf("SliceIdx(dim=%s)", dimInfoStr);
CSV_headers={strHeader01, "maxValue", "minValue", "median", "sum of abs", "average"};
CSVdataFrame = cell(frameCount+1, numel(CSV_headers));#sliceIdx, dim, maxvalue, minValue, median, sum of abs, average;
CSVdataFrame(1,:) = CSV_headers;
[dir, name0, ext]=fileparts(mhdfileName);

frameStart=1;
frameStep=1;
frameEnd=frameCount;
#frameEnd=3;
assert(frameStart<=frameEnd && frameEnd<=frameCount);


for sliceIdx=frameStart:frameStep:frameEnd #mhd slice index
    [buf, ~]=metaImageIOread(mhdfileName,  sliceIdx);

    elementCount=numel(buf);
    absBuf=abs(buf);
    retSum = sum(sum(absBuf));
    retMax = max(max(buf));
    retMin  = min(min(buf));
    retMedian = median(median(buf));
    retAverage = sum(sum(buf)) / elementCount;

    oneRowData={sliceIdx, retMax, retMin, retMedian, retSum, retAverage};
    CSVdataFrame(sliceIdx+1, :) = oneRowData;

    printf("sum of frame[%04d]=%d\n",sliceIdx, retSum);

    if needUserConfirm
        var = input("Enter if continue (y/n):", 's');
        fprintf("Input is [%c]\n", var);
        if 'y' == var || 'Y' == var
            continue;
        else
            printf("user stop continue.\n");
            break;
        endif
    endif
endfor

csvName=strcat(mhdfileName, ".csv");
pkg load io;
cell2csv(csvName,  CSVdataFrame);

