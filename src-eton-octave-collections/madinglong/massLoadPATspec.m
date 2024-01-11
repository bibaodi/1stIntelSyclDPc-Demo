#{
240111-michael.ma give me to read data which from oscilloscope;
用来看今天LabVIEW保存数据的脚本，不过额外的东西有点多。真正需要读取数据的就是line27-line38;
--
这个数据结构就是一个波形存了一个二进制block，block的头部有一个int32的包头来指示后面1D数组的长度，然后按这个长度读出double类型的一串数组就好了。block数量是任意的，读到文件尾部就算完了。
block长度均一的话是可以通过前面那行numWfm = filelist(fidx).bytes/(8*1400+4);来计算出波形数量的，可以用来提前分配内存。

#}
filepath = 'C:\Users\Michael\Documents\ACE work\Engineering\Verification\Test data\20231119\ringdownBG';
filelist = dir(filepath);

filelist = filelist(3:end);
fmask = ones(size(filelist));
sampleName = string(size(filelist));
dutNum = zeros(size(filelist));
for fidx = 1:length(filelist)
    [~,nametmp,fext] = fileparts(filelist(fidx).name);
    if ~isempty(fext)
        fmask(fidx) = 0;
    else
        sampleName(fidx) = nametmp(1:end-3);
        dutNum(fidx) = str2double(nametmp(end-1:end));
    end
end

filelist = filelist(fmask > 0);
sampleName = sampleName(fmask > 0);
dutNum = dutNum(fmask > 0);

%%
data = cell(size(filelist));
for fidx = 1:length(filelist)
    numWfm = filelist(fidx).bytes/(8*1400+4);
    ## read oscilloscope data .begin
    fid = fopen(filelist(fidx).name);
    L = fread(fid,[1 1],'int32');
    datatmp = fread(fid,[L 1],'double');
    data{fidx} = datatmp;
    L = fread(fid,[1 1],'int32');
    while ~isempty(L)
        datatmp = fread(fid,[L 1],'double');
        data{fidx} = [data{fidx} datatmp];
        L = fread(fid,[1 1],'int32');
    end
    fclose(fid);
    ## read oscilloscope data .begin.end
    if numWfm > size(data{fidx},2)
        warning('Not all waveforms loaded!')
    else
        if numWfm > size(data{fidx},2)
            warning('data size inconsistent! check ACQ configuration...')
        end
    end
    %
%     pause;
end

%%

clearvars -except data sampleName dutNum
fidx = 20;
fs = 500e6;
winL = 194;
start = 660;
datatmp = mean(data{fidx}(start+(1:2*winL),:),2);
% datatmp = data{fidx}(start+(1:2*winL),:);
% [b,a] = butter(6,[2e6 120e6]/(fs/2),'bandpass');
% datatmp = filter(b,a,datatmp);
spectmp = fftshift(fft(datatmp));
spectmpAbs = abs(spectmp);
fscale = (-winL:(winL-1))/winL*fs/2;
spectmpAbs = spectmpAbs./max(spectmpAbs);
plot(fscale/1e6,10*log(spectmpAbs))
ylim([-20 0])
xlim([0 100])
hold on
plot([fscale(1) fscale(end)],[-6 -6],'--k')
hold off
legend(num2str(dutNum(fidx)))
title(sampleName(fidx))
