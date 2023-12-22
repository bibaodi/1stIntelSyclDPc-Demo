close all;
clear;
clc;
%% �������� %%%%%%%%%%%%%%
N         =  1;                                                      %%  ����ͼ��ѡ��
v         =  100;                                                    %%  ����ѹ������
%%  Ĭ�ϲ���  %%%%%%%%%%%%
A_Line    =  1004;                                                   %%  ����A-Lineѡ�� 
sgnlgt    =  4096*2;                                                   %%  ����A-Line����ѡ��
sgnlgt_1  =  5600;                                                   %%  ͼ��A-Line����ѡ��
%% TDMS���ݶ�ȡ %%%%%%%%%%
TDMS      =  simpleConvertTDMS(false,'F:\Download\22222\12.tdms');   %%  ȷ���Ƿ�����.mat�ļ�,true/false
T_DATA    =  TDMS.Data.MeasuredData(3).Data;                         %%  ��ȡ����
AA_length =  length(T_DATA(:))/(A_Line*sgnlgt);                      %%  ͼ����
%% ���� %%%%%%%%%%%%%%%%%
for i=1:A_Line
   ii=(i-1)*sgnlgt+N*A_Line*sgnlgt+1;                                  %% ����ѡ��
   DATA_1 = T_DATA(ii:ii+sgnlgt-1,1);                       %% ����任
   [output,fft_out,fft_in] = band_pass_filter_V2(DATA_1,10,95,500);    %% �����˲�
   h = hilbert(output);                               %% ϣ�����ر任
   h = abs(h);                                        %% ȡϣ�����ر任���ģ
   H(i,:)=h(1:sgnlgt_1,1);                              %% ������ɾ���
end
 H_1 = log(1+v*H)/log(1+v);                           %% ����-����ѹ��
 H_1 =  H_1';                                         %% ����任
[output] = Polar_text_01( H_1,2001);                  %% ����任��˫���Բ�ֵ
imshow(output, 'border', 'tight', 'initialmagnification', 'fit');  %% ͼ������
t = saveAsTiffdouble(output, [ 'F:\Data',num2str(j),'.tif']);      %% ͼ��洢ΪTiff


caxis([-25,3]);   
set (gcf, 'Position', [0,0, 900, 900]);
% saveas(gcf, [ 'F:\Data',num2str(j),'.png']);
% save(['E:\PO',num2str(j),'.mat'],'input','-v7.3','-nocompression') ;
 
 
%% 
subplot(2,1,1);
plot(DATA_1);
title('�˲����ź�ʱ����');
xlabel('t(s)');
subplot(2,1,2);
plot( output );
title('�˲����źŷ�����');
xlabel('f(hz)');

blf=fft(DATA_1); % ��ɢ����Ҷ�任
def=blf; % ȡblf�����鳤��
def=def*0; % ��def�����������%   

sfft=fft(DATA_1); % calculate Fast Fourier Transform
sfft_mag=abs(sfft); % take abs to return the magnitude of the frequency components
plot(sfft_mag, '-.'); % plot fft result


P2 = abs(Y/L); % ÿ�����������г��� L
P1 = P2(1:L/2+1); % ȡ��������
P1(2:end-1) = 2*P1(2:end-1); % ��������ģֵ����2
plot(f,P1)
