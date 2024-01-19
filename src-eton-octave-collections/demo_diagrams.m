#{
eton@240119 learn all diagrams in matlab:Doc15.2 High-Level Plotting
- plot;
- mesh, surf;
- image, imagesc;
- stem (in xcorr);
- bar, bar3( Bar graph);
- polarplot, polarscatter;
#}
clearvars;
pkg load image;
pkg load signal;

#{
##########################{mesh , surf}##################
############
## mesh: mesh(X,Y,Z) creates a mesh plot, which is a three-dimensional surface that has solid edge colors and no face colors.
############
[X,Y] = meshgrid(-8:.5:8);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./R;
figure("Name", "Mesh");mesh(X,Y,Z);colorbar;
xlabel('X')
ylabel('Y')
zlabel('Z')
############
##surf: surf(X,Y,Z) creates a three-dimensional surface plot, which is a three-dimensional surface that has solid edge colors and solid face colors.
############
figure("Name", "surf");surf(X,Y,Z);colorbar;
#}

#{
#########################{plot, plot3}#################
############
##plot3:
############

figure("Name", "subplot-plot3");
t = 0:pi/20:10*pi;
xt1 = sin(t);
yt1 = cos(t);
#tiledlayout(1,2), replaces by subplot(2, 1, 1);
% Left plot
subplotIdx=1;
ax1 = subplot(1, 2, subplotIdx++);
plot3(ax1,xt1,yt1,t)
xlabel('X')
ylabel('Y')
zlabel('Z')

% Right plot
ax2 = subplot(1, 2, subplotIdx++);
plot3(ax2,xt1,yt1,t)
xlabel('X')
ylabel('Y')
zlabel('Z')

view(ax2,[90 0]);
############
##plot:
############
figure("Name", "subplot-plot");

subplot(2,2,1);
x = linspace(-3.8,3.8);
y_cos = cos(x);
plot(x,y_cos);
title('Subplot 1: Cosine')

subplot(2,2,2);
y_poly = 1 - x.^2./2 + x.^4./24;
plot(x,y_poly,'g');
title('Subplot 2: Polynomial')

subplot(2,2,[3,4]);
plot(x,y_cos,'b',x,y_poly,'g');
title('Subplot 3 and 4: Both');
legend('cos', 'poly');#in position sequence match;
#}
#########################{bar, bar3}#################
############
##bar:
############
figure("Name", "Bar graph");
x = 1900:10:2000;
y = [75 91 105 123.5 131 150 179 203 226 249 281.5];
bar_width=0.3;
subplot(2,2,1);
bar(x,y, bar_width);title('Specify the bar locations along the x-axis.');
#figure("Name", "groups Bar graph");
subplot(2,2,2);
y2 = [2 2 3; 2 5 6; 2 8 9; 2 11 12];
bar(y2);title('Display four groups of three bars..');
subplot(2,2,[3,4]);
y = [2 2 3; 2 5 6; 2 8 9; 2 11 12];
bar(y,'stacked');title('Display one bar for each row of the matrix. The height of each bar is the sum of the elements in the row.');
############
##bar3:
############
figure("Name", "Bar3 graph");
z = [1 4 7; 2 5 8; 3 6 9; 4 7 10];
bar3(z);
return;


