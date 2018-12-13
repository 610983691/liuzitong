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

%�������й����зɻ���������γ�ȡ��߶�
plane_lon = zeros(N,simu_time/simu_step);
plane_lat = zeros(N,simu_time/simu_step);
plane_high = zeros(N,simu_time/simu_step);
plane_power = zeros(1,N);
velocity = zeros(N,simu_time/simu_step);
acc_v = zeros(1,N);%�ɻ����ٶ�

time_rec_all = [];



plane = AIRCRAFT(10,20,0,100,0.8,30*pi/180,60*pi/180,...
                 simu_time,simu_step);%hangxiang�ǣ�yangjiao��