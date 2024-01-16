# eton@240109 implementation SyntheticApertureFocusingTechnique
# eton@240116 this is a Error version;
#{
clearvars;close all;
im0=imread("/home/eton/Pictures/Screenshots/sa-1998-input0.png");
inputImg0=rgb2gray(im0);
inputImg = imresize(inputImg0, 0.4);
#}

function processed=SAFT_algoV2(inputImg)
    processed=inputImg;
    figure("Name", "saft:origin");
    image(inputImg);
    figure("Name", "saft:processed");
    image(processed.');
endfunction

#{
# eton@240115-v1 cannot work maybe for the correlation not correct;
function processed=SAFT_algoV1(inputImg)
    [imgH, imgW]=size(inputImg);
    winSz = 32;#window size;
    SampleSp = 1;#axiel physical spacing;
    lateralSpacing = 1;#lateral spacing;

    halfWin=cast(winSz/2, 'int32');

    processed=zeros(imgW, imgH);

    refLineStart=halfWin+1;
    refLineEnd=imgW-halfWin;

    tic;
    imgData=inputImg.';#scanlines then line datas;
    for refLine = refLineStart:refLineEnd #go through all line as A-line(ref-line) in the image;
        #based on the A-line go throuth all window range lines;
        iAdjacentStart = refLine-halfWin;
        if iAdjacentStart < 1
            iAdjacentStart=1;
        endif
        iAdjacentEnd = refLine+halfWin;
        if iAdjacentEnd > imgW
            iAdjacentEnd=imgW;
        endif

        sum_prod = zeros(imgH);
        for iAdjacent=iAdjacentStart:iAdjacentEnd
            # get lateral position delta;
            lateralDelta=abs(refLine - iAdjacent);
            # calculate all points in one line;
            for iSample=1:imgH
                deltaIdxInAxiel = sqrt((iSample * SampleSp)^2 + (lateralDelta * lateralSpacing)^2) - iSample * SampleSp;
                vdiffi = cast(deltaIdxInAxiel, 'int32');

                NeighborLineAxielPos = iSample - vdiffi;
                NeighborLineAxielPos = cast(NeighborLineAxielPos, 'uint32');
                if NeighborLineAxielPos < 1
                    continue;
                endif
                # in the paper, below use correlation, but I donot understand it. eton@240113;
                sum_prod(iSample) = (imgData(iAdjacent, NeighborLineAxielPos) ) * (imgData(refLine, iSample)) + sum_prod(iSample);
            endfor
            # sum to average, then replace origin ref-line;
            for iSample=1:imgH
                sum_prod(iSample) /= winSz;
                processed(refLine, iSample) = sum_prod(iSample);
            endfor
        endfor
    endfor
    toc;
endfunction;
#}

#end./
