%hilbertEnv--eton@231124.
#{
Envelope Extraction
https://ww2.mathworks.cn/help/signal/ug/envelope-extraction-using-the-analytic-signal.html
#}

t = 0:1e-4:0.1;#start, step, end
x = (1+cos(2*pi*50*t)).*cos(2*pi*1000*t);

#plot(t,x)
xlim([0 0.04])

# import signal
pkg load signal

y = hilbert(x);
env = abs(y);
plot_param = {'Color', [0.6 0.1 0.2],'Linewidth',2};

plot(t,x)
hold on
y2=[-1;1]
y3=y2*env
plot(t, env, plot_param{:})
hold off
xlim([0 0.04])
title('Hilbert Envelope')
