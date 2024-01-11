pkg load signal;
# example from https://octave.sourceforge.io/signal/function/specgram.html belong to : Octave Forge

close all;
clearvars;

Fs=1000;
Freq1=500;
T1=2;
tArray=[0:1/Fs:2];
swepType='quadratic';#Sweep method,  specified as 'linear', 'quadratic', or 'logarithmic'.
x = chirp(tArray,0, T1,Freq1, swepType);  # freq. sweep from 0-500 over 2 sec.
plot(tArray, x);
step=ceil(20*Fs/1000);    # one spectral slice every 20 ms
window=ceil(100*Fs/1000); # 100 ms data window
figure("Name","Spectrum");
## test of automatic plot
[S, f, t] = specgram(x);
specgram(x, 2^nextpow2(window), Fs, window, window-step);

return;

# example form zhihu;
% 参数设置
A = 4;
phi_0 = 0;
f_0 = 500;
f_end = 1500;
T_period = 0.1;

% 采样参数
Fs = 15000; % 采样频率
T = 1/Fs;   % 采样周期
t = 0:T:T_period-T; % 从0到周期进行采样

% 生成信号
c = (f_end - f_0) / T_period; % 计算线性调频斜率
x_t = A * cos(phi_0 + 2 * pi * (f_0 * t + 0.5 * c * t.^2));

% 绘制时域图像
figure;
plot(t, x_t);
title('时域图像');
xlabel('时间 (s)');
ylabel('幅度');

% 创建新的图窗, 绘制频域图像
figure;
frequencies = linspace(-Fs/2, Fs/2, length(t)); % 调整频率范围
X_f = fftshift(fft(x_t));
plot(frequencies, abs(X_f));
title('频域图像');
xlabel('频率 (Hz)');
ylabel('幅度');

% 创建新的图窗, 绘制时频域图像
figure;
spectrogram(x_t, hamming(128), 120, 128, Fs, 'yaxis');
title('时频域图像');

return;

#example from matlab;
t = 0:1/1e3:2;
fo = 400;
f1 = 300;
# this is matlab version; last two inverst with octage; #y = chirp(t,fo,1,f1,'quadratic',[],'convex');
y = chirp(t,fo,1,f1);
plot(t, y);
