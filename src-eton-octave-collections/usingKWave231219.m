#eton@231219 using k-wave;
close all;
clear all;
addpath('/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/k-Wave:/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/k-Wave/examples');
addpath('/home/eton/00-src/30-octaves/k-wave-toolbox-version-1.4/datasets');
getkWavePath('helpfiles');

x = logspace(-1,2,10000);
y = logCompression(x,1, true);
loglog(x,y)
grid on

example_us_bmode_phased_array;
return;

#run example;
example_diff_homogeneous_medium_source
#end;



