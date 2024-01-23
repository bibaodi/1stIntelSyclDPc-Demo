#eton@230123 if want video file then change below to true;
clearvars;close all;
generateVideoFile=true;
needUserConfirm=false;

mhdfileName='/home/eton/42workspace.lnk/51-develop/33-data-analyse/cachedata_20240108T174552_5.mhd';

[~, metaInfo]=metaImageIOread(mhdfileName,  -1);
frameCount=metaInfo.DimSize(3);#[lineNum, samlieNum, frameNum]

[dir, name0, ext]=fileparts(mhdfileName);

frameStart=1;
frameStep=1;
frameEnd=594;

assert(frameStart<=frameEnd && frameEnd<=frameCount);

if generateVideoFile
    fn = fullfile(tempdir(), strcat("saft-", name0,"-F", num2str(frameStart), "-", num2str(frameEnd), ".mp4"));
    w0 = VideoWriter(fn);
    open(w0);
endif

for sliceIdx=frameStart:frameStep:frameEnd #mhd slice index
    [buf, ~]=metaImageIOread(mhdfileName,  sliceIdx);
    set(gcf(), "Name", strcat(name0, num2str(sliceIdx)));
    #buf2=reshape(buf,[256, 1792]);
    ivus_signalProcessV1(buf)
    if generateVideoFile
        drawnow;
        writeVideo(w0, getframe (gcf));
    endif
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

if generateVideoFile
    close (w0)
    printf ("Now run '%s' in your favourite video player or try 'demo VideoReader'!\n", fn);
endif

