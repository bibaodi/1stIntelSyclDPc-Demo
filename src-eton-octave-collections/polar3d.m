slCharacterEncoding('GBK')
function [Xout, Yout, Zout] = polar3d(Zin,theta_min,theta_max,Rho_min,Rho_max,meshscale,varargin)


% % % % % % % % % % % % % %  % 此区域为提示 % % % % % % % % % % % % %
% % % % % % % % % % % % % %  %% % % % % % % % % % % % % %  % % % % %

if (nargin < 6) %%判断输入变量个数的函数
    disp('Polar3d Error: Too few input arguments.');
    return
elseif (nargin > 8)
    disp('Polar3d Error: Too many input arguments.');
    return
end

[p,q] = size(theta_min);
if (((p ~= 1)|(q ~= 1))|~isreal(theta_min))|ischar(theta_min)
    disp('Polar3d Error: theta_min must be scalar and real.');
    return
end
[p,q] = size(theta_max);
if (((p ~= 1)|(q ~= 1))|~isreal(theta_max))|ischar(theta_max)
    disp('Polar3d Error: theta_max must be scalar and real.');
    return
end
if theta_max <= theta_min
    disp('Polar3d Error: theta_max less than or equal theta_min.');
    return
end
if abs(theta_max - theta_min) > 2*pi
    disp('Polar3d Error: range of theta greater than 2pi.');
    return
end

[p,q] = size(Rho_max);
if (((p ~= 1)|(q ~= 1))|~isreal(Rho_max))|(ischar(Rho_max)|Rho_max < 0)
    disp('Polar3d Error: Rho_max must be scalar, positive and real.');
    return
end
[p,q] = size(Rho_min);
if (((p ~= 1)|(q ~= 1))|~isreal(Rho_min))|(ischar(Rho_min)|Rho_min < 0)
    disp('Polar3d Error: Rho_min must be scalar, positive and real.');
    return
end
if Rho_max <= Rho_min
    disp('Polar3d Error: Rho_max less than or equal Rho_min.');
    return
end

[p,q] = size(meshscale);
if (((p ~= 1)|(q ~= 1))|~isreal(meshscale))|ischar(meshscale)
    disp('Polar3d Warning: mesh scale must be scalar and real.');
    meshscale = 1;
end
if (meshscale <= 0)
    disp('Polar3d Warning: mesh scale must be scalar and positive.');
    meshscale = 1;
end

% % % % % % % % % % % % % %  % 此区域为函数 % % % % % % % % % % % % %
% % % % % % % % % % % % % %  %% % % % % % % % % % % % % %  % % % % %

% 设置默认绘图和插值规格.
str1 = 'mesh';
str2 = 'linear';
if length(varargin) == 2
% 如果两个字符串都给出，请将绘图和插值规范分开.
    str1 = [varargin{1}(:)]';
    str2 = [varargin{2}(:)]';
    g1 = (~isequal(str1,'mesh')&~isequal(str1,'surf'))&~isequal(str1,'off');
    g2 = (~isequal(str1,'meshc')&~isequal(str1,'surfc'));
    g5 = (~isequal(str1,'contour')&~isequal(str1,'meshl'));
    g3 = (~isequal(str2,'cubic')&~isequal(str2,'linear'));
    g4 = (~isequal(str2,'spline')&~isequal(str2,'nearest'));
    if (g1&g2&g5)
        disp('Polar3d Warning: Incorrect plot specification. Default to mesh plot.');
        str1 = 'mesh';
    end
    if (g3&g4)
        disp('Polar3d Warning: Incorrect interpolation specification.');
        disp('Default to linear interpolation.');
        str2 = 'linear';
    end
elseif length(varargin) == 1
% 从单个字符串输入中排列绘图或插值规范.
    str1 = [varargin{1}(:)]';
    g1 = (~isequal(str1,'mesh')&~isequal(str1,'surf'))&~isequal(str1,'off');
    g2 = (~isequal(str1,'meshc')&~isequal(str1,'surfc'));
    g5 = (~isequal(str1,'contour')&~isequal(str1,'meshl'));
    g3 = (~isequal(str1,'cubic')&~isequal(str1,'linear'));
    g4 = (~isequal(str1,'spline')&~isequal(str1,'nearest'));
    if (g1&g2)&(g3&g4&g5)
        disp('Polar3d Error: Incorrect plot or interpolation specification.');
        return
    elseif isequal(str1,'cubic')
        str2 = str1;
        str1 = 'mesh';
    elseif isequal(str1,'linear')
        str2 = str1;
        str1 = 'mesh';
    elseif isequal(str1,'spline')
        str2 = str1;
        str1 = 'mesh';
    elseif isequal(str1,'nearest')
        str2 = str1;
        str1 = 'mesh';
    elseif isequal(str1,'off')
        str2 = 'linear';
    end
end;

% 检查输入数据的尺寸是否可以接受.
[r,c] = size(Zin');
if (r < 5)&(c < 5)
    disp('Polar3d Error: Input matrix dimensions must be greater than (4 x 4).');
    return
end
% Check if input data has two rows or columns or less.
if (r < 3)|(c < 3)
    disp('Polar3d Error: One or more input matrix dimensions too small.');
    return
end

[r,c] = size(Zin);

% 检查meshscale是否与输入数据的维度兼容.
scalefactor = round(max(r,c)/meshscale);
if scalefactor < 3
    disp('Polar3d Error: mesh scale incompatible with dimensions of input data.');
    return
end

% 设置对应于Zin的较大矩阵尺寸的网格
% 如果需要进行内插.
if ~isequal(str1,'meshl')
    n = meshscale;
    if r > c
        L = r;
        L2 = fix(L/n)*n;
        L6 = c;
        L7 = fix(L6/n)*n;
        step = r/(c-1);
        [X1,Y1] = meshgrid(1:c,1:r);
        if n < 1
            [X,Y] = meshgrid(0:n:(L2-n),0:n:(L2-n));
        else
            [X,Y] = meshgrid(1:n:L7,1:n:L2);
        end
        T = interp2(X1,Y1,Zin,X,Y,str2);
    elseif c > r
        L = c;
        L2 = fix(L/n)*n;
        step = c/(r-1);
        [X1,Y1] = meshgrid(1:c,0:step:c);
        if n < 1
            [X,Y] = meshgrid(0:n:(L2-n),0:n:(L2-n));
        else
            [X,Y] = meshgrid(1:n:L2,1:n:L2);
        end
        T = interp2(X1,Y1,Zin,X,Y,str2);
    else
        L = r;
        L2 = fix(L/n)*n;
        [X1,Y1] = meshgrid(1:r,1:r);
        if n < 1
            [X,Y] = meshgrid(0:n:(L2-n),0:n:(L2-n));
        else
            [X,Y] = meshgrid(1:n:L2,1:n:L2);
        end
        T = interp2(X1,Y1,Zin,X,Y,str2);
    end

    [p,q] = size(T);
    L2 = q;
    L8 = p;
%     theta_max=(L8-1)*(theta_max-theta_min)/L8;
    % 设置角度
    angl = theta_min:abs(theta_max-theta_min)/(L8-1):theta_max;
    angl = angl';
    theta = repmat(angl,[1, L2]);

    % 设置径向组件
    Rho1 = Rho_min:abs(Rho_max-Rho_min)/(L2-1):Rho_max;
    Rho = repmat(Rho1,[L8, 1]);

    [Xout Yout Zout] =  pol2cart(theta,Rho,T);

end

% 绘制笛卡尔曲面
switch str1;
case 'mesh'
    colormap([0 0 0]);
    mesh(Xout,Yout,Zout);
    axis off;
    grid off;
case 'meshc'
    colormap([0 0 0]);
    meshc(Xout,Yout,Zout);
    axis off;
    grid off;
case 'surf'
   surf(Xout,Yout,Zout);
%     set(h,'edgecolor','none');
    axis off;
%     grid off;
case 'surfc'
    surfc(Xout,Yout,Zout,'edgecolor','none');
    axis off;
    grid off;
    hold off
case 'contour'
    axis equal;
    h = polar([theta_min theta_max], [Rho_min Rho_max]);
    delete(h)
    hold on
    contour(Xout,Yout,Zout,20);
    hold off
    colorbar;
case 'meshl'
    % Set up mesh plot with polar axes and labels
    angl = theta_min:abs(theta_max-theta_min)/(r-1):theta_max;
    Rho = ones([1 c])*Rho_max*1.005;
    X = Rho'*cos(angl);
    Y = Rho'*sin(angl);
    Z = zeros(size(X));
    % set up output data - this is exactly the same as the input
    Rho = Rho_min:abs(Rho_max-Rho_min)/(c-1):Rho_max;
    Xout = Rho'*cos(angl);
    Yout = Rho'*sin(angl);
    Zout = Zin';
    % plot the data
    axis equal;
    mesh(Xout,Yout,Zout);
    hold on
    % plot the axis
    mesh(X,Y,Z,'edgecolor',[0 0 0]);
    hold on;
    % set up tic mark and labels
    ticangle = round(theta_min*18/pi)*pi/18:pi/18:round(theta_max*18/pi)*pi/18;
    ticlength = [Rho_max*1.005 Rho_max*1.03];
    Xtic = ticlength'*cos(ticangle);
    Ytic = ticlength'*sin(ticangle);
    Ztic = zeros(size(Xtic));
    Xlbl = Rho_max*1.1*cos(ticangle);
    Ylbl = Rho_max*1.1*sin(ticangle);
    Zlbl = zeros(size(Xlbl));
    line(Xtic,Ytic,Ztic,'Color',[0 0 0]);
    if abs(theta_min-theta_max)==2*pi
        Ntext = round(length(ticangle)/2)-1;
    else
        Ntext = round(length(ticangle)/2);
    end
    for i = 1:Ntext
        text(Xlbl(2*i-1),Ylbl(2*i-1),Zlbl(2*i-1),...
            num2str(ticangle(2*i-1)*180/pi),...
            'horizontalalignment','center')
    end
    set(gca,'DataAspectRatio',[1 1 1])
    axis off;
    grid off;
end
return

