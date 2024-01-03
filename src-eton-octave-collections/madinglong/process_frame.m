filepath = uigetdir();
filenames = dir(filepath);
filenames = filenames(3:end);

%check if filenames consistent with format
lenAline = filenames(1).bytes/4;
numAline = length(filenames);
dataFrame = zeros(lenAline,numAline);
for fidx = 1:numAline
    fnametmp = filenames(fidx).name;
    tmp = textscan(fnametmp,'acr_debugDataBufF%dL%d.bin');
    fidxRead = tmp{2};
    if fidxRead == (fidx-1)
%         continue;
    else
        error('File index inconsistent!\n');
    end
    fid = fopen(fullfile(filepath,filenames(fidx).name));
    datatmp = fread(fid,[1 lenAline],'int32');
    fclose(fid);
    dataFrame(:,fidx) = datatmp;

end

% for fidx = 1:length(filenames)
% end