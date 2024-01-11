close all;clearvars;
#eton@240110 add SNR calculation demo;
Tpulse = 20e-3;
Fs = 10e3;
t = -1:1/Fs:1;
x = rectpuls(t,Tpulse);
plot(x);
SNR = 53;
y = randn(size(x))*std(x)/db2mag(SNR);
figure;plot(y);
signal=x+y;
figure;plot(signal);
# pulseSNR = snr(x,y);
powfund=( sum(x.^2) / length(x));
varnoise=( sum(y.^2)/length(y));
#sqrt is no need for 10*log10;;
#powfund = max(x);


defSNR = 10*log10(powfund/varnoise);#should be 35;
