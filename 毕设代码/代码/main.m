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

%整个运行过程中飞机参数：经纬度、高度、功率、速度、加速度
plane_lon = zeros(N,simu_time/simu_step);
plane_lat = zeros(N,simu_time/simu_step);
plane_high = zeros(N,simu_time/simu_step);
plane_power = zeros(1,N);
velocity = zeros(N,simu_time/simu_step);
acc_v = zeros(1,N);%飞机加速度
elevation = zeros(1,N);%飞机仰角
pathangle = zeros(1,N);%飞机航向角


%飞机类
plane = AIRCRAFT(simu_time,simu_step,10,40,10,800,0,45*pi/180,0 );
                %仿真时长，仿真步进，经度，纬度，高度，速度，加速度，航向角，仰角
                