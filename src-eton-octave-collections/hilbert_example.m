%hilbertEnv--eton@231124.
#{
Envelope Extraction
https://ww2.mathworks.cn/help/signal/ug/envelope-extraction-using-the-analytic-signal.html
#}
#--{
pkg load signal
t = 0:1/1024:1;
x = sin(2*pi*60*t);
#-}
#{
t = 0:1e-4:0.1;#start, step, end
x = (1+cos(2*pi*50*t)).*cos(2*pi*1000*t);
#}
y = hilbert(x);
env=abs(y)

#plot(t(1:50),real(y(1:50)))
plot(t,real(y))
xlim([0 0.1])
hold on
plot(t(1:50),imag(y(1:50)))
hold on
plot(t, env)
hold off
#axis([0 0.05 -1.1 2])
legend('Real Part','Imaginary Part', "ABS")
