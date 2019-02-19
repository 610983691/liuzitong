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

%用一个矩阵来表示飞机不同信息的接收时间以及携带的信息内容
mess_all = [];
mecode_all = [];
time_rec = [];
type = randi(4);                         %在飞机ID编码中的设备类型 D C B A选择，随机选择
type_code(1,:) = bitget(type,5:-1:1);
v_rate = randi(2)-1;

%信息的不同主要体现在ME字段的不同所以ME字段前面的编码可以在程序前就直接写好
code_heading = [1 0 0 0 1,zeros(1,26)]; %DF CA AA
mecode = zeros(1,88);


%飞机类
plane = AIRCRAFT(simu_time,simu_step,10,40,10,800,0,45*pi/180,0,ceil(rand(1)*10),{'A','B','1','4','7','2','3','9'} );
%仿真时长，仿真步进，经度，纬度，高度，速度，加速度，航向角，仰角
clock = 0;
while(clock<(simu_time/simu_step))  
    plane = ChangePosition(plane,ratio);
    plane = BroadCast(plane,clock); 
    clock = clock + 1;
    
    plane_lon(1,clock) = plane.longitude;
    plane_lat(1,clock) = plane.latitude;
    plane_high(1,clock) = plane.hight;
    
    %编码过程
    if plane.broad_times(1,clock) ~= 0
    [mecode,mess] = messcode(clock,plane.broad_times,plane.longitude,plane.latitude,plane.hight,plane.cpr_f,...
    plane.velocity,plane.ele_angle,plane.path_angle,type_code,v_rate,plane.ID);
    mess_all = [mess_all;mess];
    mecode_all = [mecode_all;mecode];
    end
    
   
       %开始进行位置信息编码，最重要的是经纬度编码和高度编码
       
        
end
plot3(plane_lat,plane_lon,plane_high),xlabel('纬度'),ylabel('经度'),zlabel('高度');
grid on;                