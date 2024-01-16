#{
eton@240113 learn correlation and convelotion.
https://ww2.mathworks.cn/help/signal/correlation-and-convolution.html
https://ww2.mathworks.cn/help/matlab/ref/xcorr.html
#}

pkg load signal;
close all;
clearvars;

n = 0:15;
x = 0.84.^n;
plot(x);
figure;
y = circshift(x,5);
plot(y);figure;
[c,lags] = xcorr(x,y);
plot(c);
figure;
stem(lags,c); # The data values are indicated by circles terminating each stem.

