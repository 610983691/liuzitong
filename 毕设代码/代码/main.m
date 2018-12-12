clear;
clc;

simu_time =100;% 单位s
simu_step =1e-3;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 500*10^6;
fc_mid = 40*10^6; %中频载波频率40MHz
fc = 1090;%发射频率1090MHz  

%设置飞机的参数
N = 1;%飞机数量

%设置飞机初始参数




plane = AIRCRAFT(10,20,0,100,0.8,30*pi/180,60*pi/180,...
                 simu_time,simu_step);%hangxiang角，yangjiao角