clear;
clc;
R = 6371;
v0 = 7.4;
a = 0;
theta = 45*pi/180;
phy = 0;
lat0 = 30;
lon0 = 20;
h0 = 700;
v = zeros(1,20001);
lat = zeros(1,20001);
lon = zeros(1,20001);
h = zeros(1,20001);
% x1 = zeros(1,20001);
% y1 = zeros(1,20001);
% z1 = zeros(1,20001);

v(1) = v0;
lat(1) = lat0;
lon(1) = lon0;
h(1) = h0;
for t = 0.05:0.05:50
    v(round(t/0.05+1)) =  v(round(t/0.05)) - a*t;
    h(round(t/0.05+1)) = h(round(t/0.05))-(v(round(t/0.05))*cos(phy)*0.05-1/2*a*0.05^2)*sin(phy);
    lat(round(t/0.05+1)) = lat(round(t/0.05))-v(round(t/0.05))*cos(phy)*0.05*cos(theta)/(R+h(round(t/0.05)));
    lon(round(t/0.05+1)) = lon(round(t/0.05))+v(round(t/0.05))*0.05*sin(theta)/(R+h(round(t/0.05)))/cos(lat(round(t/0.05+1))*pi/180);
end
% for t = 1:20001
%    x1(t) = (R+h(t))*cos(lat(t)*pi/180)*cos(lon(t)*pi/180);
%    y1(t) = (R+h(t))*cos(lat(t)*pi/180)*sin(lon(t)*pi/180);
%    z1(t) = (R+h(t))*sin(lat(t)*pi/180);
% end
% sphere(50);
% [x,y,z] = sphere();
% surf(6371*x,6371*y,6371*z);
% hold on;
% plot3(x1,y1,z1),xlabel('纬度'),ylabel('经度'),zlabel('高度');
% grid on;
plot3(lat,lon,h),xlabel('纬度'),ylabel('经度'),zlabel('高度');
grid on;