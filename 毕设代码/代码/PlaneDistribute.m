 function [plane] = PlaneDistribute(~,~,~)
clear all;
clc;
N1 = 10;
N2 = 2;
lons = 20;
lats = 30;
highs = 700;
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
theta = asin(6371/(6371+highs));
plane = zeros(6,N1+N2);
for i = 1:N1
   phy = rand()*360*pi/180;
   theta1= rand()*theta;
%通过theta1和phy求出飞机和卫星之间的距离。
    syms x;
    result = solve(x^2-2*x*(6371+highs)*cos(theta1)+(6371+highs)^2-6371^2 == 0, x );
    result = double(result);
   for j = 1:length(result)
      if (result(j)<=sqrt((6371+highs)^2-6371^2))&& (result(j)>=highs)
         R = result(j);
      end
   end

%转换成卫星站心坐标系
r1 = [ R*sin(pi-theta1)*cos(phy); -R*sin(pi-theta1)*sin(phy);R*cos(pi-theta1)];%ephy,etheta,er
 %转换成直角坐标系
 r2 = [-sin(lons*pi/180),cos(lons*pi/180),0;cos(lats*pi/180)*cos(lons*pi/180),cos(lats*pi/180)*sin(lons*pi/180),-sin(lats*pi/180);...
       sin(lats*pi/180)*cos(lons*pi/180),sin(lats*pi/180)*sin(lons*pi/180),cos(lats*pi/180)]^-1*r1+rs';
  plane(2,i) = acos(r2(3)/6371)*180/pi;%纬度
  plane(1,i) = atan(r2(2)/r2(1))*180/pi;
  plane(3,i) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
end


%高斯分布 在均匀分布的随机点中选一个点作为高斯分布中心
position_center =[plane(1,randi(N1+1)),plane(2,randi(N1+1))];
for i = 1:N2
    plane(1,N1+i) = position_center(1)+randn();
    plane(2,N1+i) = position_center(2)+randn();
    plane(3,N1+i) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
end

%随机分配速度、航向角、功率
for i = 1:N1+N2
    plane(4,i) = (rand()*2+800)/3600;
    plane(5,i) = rand()*360*pi/180;
    plane(6,i) = rand()*4+50;%dnm
end
 end



