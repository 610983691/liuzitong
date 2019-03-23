% function [lon,lat,high] = PlaneDistribute(lons,lats,highs)
clear all;
clc;
lons = 20;
lats = 30;
highs = 700;
theta = asin(6371/(6371+highs));
phy = rand()*360*pi/180;
theta1= rand()*theta;
%通过theta1和phy求出飞机和卫星之间的距离。
syms x;
result = solve(x^2-2*x*(6371+highs)*cos(theta1)+(6371+highs)^2-6371^2 == 0, x );
result = double(result);
for i = 1:length(result)
    if (result(i)<=sqrt((6371+highs)^2-6371^2))&& (result(i)>=highs)
        R = result(i);
    end
end
%转换成卫星站心坐标系
r1 = [R*cos(pi-theta1); -R*sin(pi-theta1)*cos(phy); R*sin(pi-theta)*sin(phy)];%er,etheta,rphy
 %转换成直角坐标系
r2 = [r1(1)*sin(lats*pi/180)*cos(lons*pi/180)+r1(2)*cos(lats*pi/180)*cos(lons*pi/180)-r1(3)*sin(lons*pi/180);...
      r1(1)*sin(lats*pi/180)*sin(lons*pi/180)+r1(2)*cos(lats*pi/180)*sin(lons*pi/180)+r1(3)*cos(lons*pi/180);...
      r1(1)*cos(lats*pi/180)-r1(2)*sin(lats*pi/180)];
  lat = acos(r2(3)/R)*180/pi;
  lon = atan(r2(2)/r2(1))*180/pi;


