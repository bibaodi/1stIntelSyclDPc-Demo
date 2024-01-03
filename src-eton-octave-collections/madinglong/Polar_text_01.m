function [polar_out_1] = Polar_text_01(polar_in_1, img_d)
aa_a = min(min(polar_in_1));
polar_out_1 = zeros(img_d,img_d);                 %设定成像矩阵的长度
[line_len,line_num] = size(polar_in_1);           %获取原始数据的行和列
delta_r = (2*line_len)/(img_d-1);              %距离因子
delta_t = 2*pi/line_num;                       %角度因子
center_x = (img_d - 1) / 2.0;                %设置原点横坐标
center_y = (img_d - 1) / 2.0;                %设置原点纵坐标
daa = zeros(img_d,img_d);
dab = zeros(img_d,img_d);
dac = zeros(img_d,img_d);
dad = zeros(img_d,img_d);
dqq = zeros(img_d,img_d);
img_r = (img_d-1)/2;                    %设置图像半径
for i=1:1:img_d
    for j=1:1:img_d
        rx=j-center_x;               %图像坐标转换为实际坐标 横坐标
        ry=center_y-i;               %图像坐标转换为实际坐标 纵坐标
        r=sqrt(rx*rx + ry*ry);       %计算距离原点的长度
        if r<=img_r                  %用于设定边界
            ri = r * delta_r;        %将实际距离换算为对应于原始数据矩阵的行数，用于双线性插值
            rf = floor(ri);          %行数向下取整
            rc = ceil(ri);           %行数向上取整
            if rf<1                  %行数边界识别
                rf=1;
            end
            if rc>(line_len-1)       %行数边界识别
                rc=(line_len-1);
            end
            t=atan2(ry,rx);          %计算角度
            if t<0                   %边界识别
                t=t+2*pi;
            end
            ti =t/delta_t;           %将实际距离换算为对应于原始数据矩阵的列数，用于双线性插值
             dqq(i,j)=ti;
            tf =floor(ti);           %列数向下取整
            tc =ceil(ti);            %列数向下取整
            if tf<=1                 %列数边界识别
                tf=1;
            end
            if tc>(line_num-1)       %列数边界识别
                tc=line_num-1;
            end
            if tc==0
                tc=1;
            end
            if rc==0
                rc=1;
            end
            if rf==rc&&tc==tf
                polar_out_1(i,j)=polar_in_1(rc,tc);
            else if rf==rc
                    polar_out_1(i,j)=(ti-tf)*polar_in_1(rf,tc)+(tc-ti)*polar_in_1(rf,tf);
                else if tf==tc
                        polar_out_1(i,j)=(ri-rf)*polar_in_1(rc,tf)+(rc-ri)*polar_in_1(rf,tf);
                    else
                        aa=ti-tf;     
                        bb=1-aa;
                        cc=ri-rf;
                        dd=1-cc;
                        daa(i,j)=aa;
                        dab(i,j)=cc;
                        dac(i,j)=rf;
                        dad(i,j)=tf;
                        polar_out_1(i,j)=aa*cc*polar_in_1(rc,tc)+bb*cc*polar_in_1(rc,tf)+aa*dd*polar_in_1(rf,tc)+bb*dd*polar_in_1(rf,tf);
                    end
                end
            end
        else
            polar_out_1(i,j)=aa_a;
        end
    end
end
% polar_out_1(752,:) = -10;
polar_out_1(750,:) = (polar_out_1(752,:)-polar_out_1(749,:))*0.33+polar_out_1(749,:);
polar_out_1(751,:) = (polar_out_1(752,:)-polar_out_1(749,:))*0.66+polar_out_1(749,:);
