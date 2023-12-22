#show rf-data frequency spectrum--eton@231218
dataHome="/home/eton/42workspace.lnk/51-develop/33-data-analyse/231215-5mhz";
metadataFile="acr_debugDataBufF0013L%03d.bin";


function retval = showOneData()
  dataHome="/home/eton/42workspace.lnk/51-develop/33-data-analyse/231215-5mhz";
  metadataFile="acr_debugDataBufF0013L%03d.bin";
  for datafIdx=0:1:511
    dataFile=sprintf(metadataFile, datafIdx);
    absfile=fullfile(dataHome, dataFile);
    printf("data file name=%s\n", absfile);

    fdata=fopen(absfile, 'r');
    datas=fread(fdata, Inf, "int32");
    fclose(fdata);

    x=datas;
    fs=250e6;
    y=fft(x);
    if false #show origin datas in time domain;
      plot(datas);
      hold on;
    endif
    n = length(x);          % number of samples

    f = (0:n-1)*(fs/n/1e6);     % frequency range
    power = abs(y).^2/n;    % power of the DFT

    plot(f,power);
    xlabel('Frequency(MHZ)');
    ylabel('Power');
    title (dataFile);
    #legend('A','B')
    #plot.show();

    ret=waitforbuttonpress();
  endfor
endfunction

frame=zeros(512,1792);
for datafIdx=0:1:511
    dataFile=sprintf(metadataFile, datafIdx);
    absfile=fullfile(dataHome, dataFile);
    printf("data file name=%s\n", absfile);

    fdata=fopen(absfile, 'r');
    datas=fread(fdata, Inf, "int32");
    length(datas)
    fclose(fdata);
    frame(datafIdx,:)=datas
endfor

#showOneData();
t=1:1:8192;
x=t*255/8192;
N=length(x);
Alpha=0.1
y=log10(1+Alpha*x)./log10(1+Alpha);#signal = log10(1 + a * signal) ./ log10(1 + a).
plot(t,x);
hold on;
plot(t, y);
hold off;

#//exit(0);
#///
centeralFreq=false;
if centeralFreq
  y0 = fftshift(y);         % shift y values
  f0 = (-n/2:n/2-1)*(fs/n); % 0-centered frequency range
  power0 = abs(y0).^2/n;    % 0-centered power

  plot(f0,power0)
  xlabel('Frequency')
  ylabel('Power')
end

