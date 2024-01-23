generateVideoFile=false;

if generateVideoFile
    fn = fullfile (tempdir(), "saft800-900.mp4");
    w0 = VideoWriter (fn);
    open (w0);
endif

mhdfileName='/home/eton/42workspace.lnk/51-develop/33-data-analyse/cachedata_20240108T174945_7.mhd';

[~, metaInfo]=metaImageIOread(mhdfileName,  -1);
frameCount=metaInfo.DimSize(3);#[lineNum, samlieNum, frameNum]

[dir, name0, ext]=fileparts(mhdfileName);

frameStart=800;
frameStep=1;
frameEnd=900;

assert(frameStart<=frameEnd && frameEnd<=frameCount);

for sliceIdx=frameStart:frameStep:frameEnd #mhd slice index
    [buf, ~]=metaImageIOread(mhdfileName,  sliceIdx);
    set(gcf(), "Name", strcat(name, num2str(sliceIdx)));
    #buf2=reshape(buf,[256, 1792]);
    ivus_signalProcessV1(buf)
    if generateVideoFile
        drawnow;
        writeVideo (w0, getframe (gcf));
    endif
    var = input("Enter if continue (y/n):", 's');
    fprintf("Input is [%c]\n", var);
    if 'y' == var || 'Y' == var
        continue;
    else
        printf("user stop continue.\n");
        break;
    endif
endfor

if generateVideoFile
    close (w0)
    printf ("Now run '%s' in your favourite video player or try 'demo VideoReader'!\n", fn);
endif

