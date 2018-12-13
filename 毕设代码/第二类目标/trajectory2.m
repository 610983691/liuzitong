clear;
clc;
R = 6371;
v0 = 300;
a = 200;
theta = 30*pi/180;
phy = 60*pi/180;
lat0 = 20;
lon0 = 10;
h0 = 0;
v = zeros(1,201);
lat = zeros(1,201);
lon = zeros(1,201);
h = zeros(1,201);
v(1) = v0;
lat(1) = lat0;
lon(1) = lon0;
h(1) = h0;
for t = 0.005:0.005:1
    v(round(t/0.005+1)) = v0 + a*t;
    h(round(t/0.005+1)) = h(round(t/0.005))+(v(round(t/0.005))*0.005+1/2*a*0.005^2)*sin(phy);
    lat(round(t/0.005+1)) = lat(round(t/0.005))+v(round(t/0.005))*cos(phy)*0.005*cos(theta)/(R+h(round(t/0.005)));
    lon(round(t/0.005+1)) = lon(round(t/0.005))+v(round(t/0.005))*cos(phy)*0.005*sin(theta)/(R+h(round(t/0.005)))/cos(lat(round(t/0.005+1)));
end
plot3(lat,lon,h),xlabel('纬度'),ylabel('经度'),zlabel('高度');
grid on;