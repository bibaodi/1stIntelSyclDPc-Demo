function dataFrame = process_frame(dataFolder)
##    read aline data which store in multi files;
##    return: dataFrame a 2d matrix;
##    param: file directory

    useGuiGetDataDir=false;
    if nargin == 1
        filepath = dataFolder;
    else
        useGuiGetDataDir=true;
    end

    if useGuiGetDataDir
        filepath = uigetdir();
    endif

    printf("filepath=%s\n", filepath);

    filenames0 = dir(filepath);
    filenames = filenames0(3:end);#remove '. /..' two special file;

    %check if filenames consistent with format
    NumSamples = filenames(1).bytes/4;# int32 used 4bytes;
    numAline = length(filenames);

    dataFrame = zeros(numAline, NumSamples);
    for fidx = 1:numAline
        fnametmp = filenames(fidx).name;
        if ! endsWith(fnametmp, ".bin")
            continue;
        endif
        tmp = textscan(fnametmp,'acr_debugDataBufF%dL%d.bin');
        fidxRead = tmp{2};
        if fidxRead != (fidx-1)
            error('File index inconsistent!\n');
        endif
        fid = fopen(fullfile(filepath,filenames(fidx).name));
        datatmp = fread(fid,[1 NumSamples],'int32');
        fclose(fid);
        dataFrame(fidx, :) = datatmp;
    end
    printf("finish read from files.\n");
    return;
    ### below is origin version row-first;
    dataFrame = zeros(NumSamples,numAline);
    for fidx = 1:numAline
        fnametmp = filenames(fidx).name;
        tmp = textscan(fnametmp,'acr_debugDataBufF%dL%d.bin');
        fidxRead = tmp{2};
        if fidxRead == (fidx-1)
            printf("index=%d,%d;", fidx, fidxRead);
        else
            error('File index inconsistent!\n');
        end
        fid = fopen(fullfile(filepath,filenames(fidx).name));
        datatmp = fread(fid,[1 NumSamples],'int32');
        fclose(fid);
        dataFrame(:,fidx) = datatmp;

    end

    % for fidx = 1:length(filenames)
    % end
