# eton@240109 implementation SyntheticApertureFocusingTechnique
function processed=SAFT_algo(inputImg)
    imgW, imgH=size(inputImg);
    winSz = 32;#window size;
    SampleSp = 1;#axiel physical spacing;
    lateralSpacing = 1;#lateral spacing;

    halfWin=cast(winSz/2, 'int32');

    sum_prod = zeros(imgW * imgH);

    for refLine = halfWin:imgW-halfWin
        for iAdjacent=refLine-halfWin:refLine+halfWin
            lateralDelta=abs(refLine - iAdjacent);
            for iSample=1:imgH
                vdiff = sqrt(pow(iSample * SampleSp, 2) + pow(lateralDelta * lateralSpacing, 2)) - iSample * SampleSp;
                vdiffi = cast(vdiff, 'int32');

                sum_prod[iSample] = (inputImg[iAdjacent][iSample - vdiffi] - 128) *
                             (inputImg[refLine] + iSample] - 128) +
                         sum_prod[iSample];
            endfor
        endfor
    endfor
#end./
