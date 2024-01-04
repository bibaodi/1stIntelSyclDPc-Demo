#{
;;log compress
eton@231222. for supra using normilazion in logCompression. figure it out;
https://github.com/AnpleLu/K_Wave_Toolbox/blob/main/logCompression.m
% compress signal
if normalise
    mx = max(signal(:));
    signal = mx * (log10(1 + a * signal ./ mx) ./ log10(1 + a));
else
    signal = log10(1 + a * signal) ./ log10(1 + a);
end
#}
signal=1:80:8192;
mx0 = max(signal(:));
b=80;#Decible
a=10^( b/20);
mx2=255;
mx=mx0;
signalY = mx2 * (log10(1 + a * signal ./ mx) ./ log10(1 + a));
plot(signal./mx);
hold on;
plot(signalY./mx2);
hold off;
legend('Ori','Loged');
#{
 comment format;
#}
