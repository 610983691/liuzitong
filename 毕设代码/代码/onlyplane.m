clear all;
clc;
simu_time =10;% ��λs
simu_step =1e-3;%s
ratio = 6371;%KM
lat = 30;
lon = 20;
high_num = unidrnd(12);
high = 8.4+(high_num-1)*300+(rand(1)*2-1)*20;
velocity = 2.5;%�ٶ��и�ת����������KM/h��������KM/s
head = pi/4;
power = 57;%dbm
acc_v  = 0;
elevation = 0;
plane_ID = [];
character_select = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N',...
                    'O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1',...
                    '2','3','4','5','6','7','8','9',' '};
for i = 1:8
    plane_ID = [plane_ID,character_select(unidrnd(37))];
end
                

plane_lon = zeros(1,simu_time/simu_step);
plane_lat = zeros(1,simu_time/simu_step);
plane_high = zeros(1,simu_time/simu_step);

plane = AIRCRAFT(simu_time,simu_step,lon,lat,high,velocity,acc_v,head,elevation,ceil(rand(1)*10),plane_ID );
%����ʱ�������沽�������ȣ�γ�ȣ��߶ȣ��ٶȣ����ٶȣ�����ǣ�����

clock = 1;
while(clock<(simu_time/simu_step)) 
        plane = ChangePosition(plane,ratio);
        plane = BroadCast(plane,clock); 
        clock = clock + 1;
        plane_lon(1,clock) = plane.longitude;
        plane_lat(1,clock) = plane.latitude;
        plane_high(1,clock) = plane.hight;
end
