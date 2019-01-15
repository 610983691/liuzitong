clear;
clc;

simu_time =100;% ��λs
simu_step =1e-3;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 500*10^6;
fc_mid = 40*10^6; %��Ƶ�ز�Ƶ��40MHz
fc = 1090;%����Ƶ��1090MHz  

%���÷ɻ��Ĳ���
N = 1;%�ɻ�����

%�������й����зɻ���������γ�ȡ��߶ȡ����ʡ��ٶȡ����ٶ�
plane_lon = zeros(N,simu_time/simu_step);
plane_lat = zeros(N,simu_time/simu_step);
plane_high = zeros(N,simu_time/simu_step);
plane_power = zeros(1,N);
velocity = zeros(N,simu_time/simu_step);
acc_v = zeros(1,N);%�ɻ����ٶ�
elevation = zeros(1,N);%�ɻ�����
pathangle = zeros(1,N);%�ɻ������


%�ɻ���
plane = AIRCRAFT(simu_time,simu_step,10,40,10,800,0,45*pi/180,0 );
                %����ʱ�������沽�������ȣ�γ�ȣ��߶ȣ��ٶȣ����ٶȣ�����ǣ�����
                