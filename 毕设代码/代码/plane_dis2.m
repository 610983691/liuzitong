clear all;
N1 = 2000;
lats =90;
lons = 0;
highs = 700;
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
space = 6371*acos(6371/7071);%ÇòÃæ¾àÀë°ë¾¶
r = space*sqrt(rand(1,N1));
phy = 2*pi*rand(1,N1);
num1 = 500;
plane_lon_path = zeros(1,N1+num1);
plane_lat_path = zeros(1,N1+num1);
x = zeros(1,N1);
y = zeros(1,N1);
lon_change = zeros(1,N1);
lat_change = zeros(1,N1);
d = zeros(1,N1);
lon = zeros(1,N1+num1);
lat = zeros(1,N1+num1);
for i = 1:N1
    x(i)= r(i).*cos(phy(i));
    y(i) =r(i).*sin(phy(i));
    lon_change(i) = x(i)/(2*pi*6371*cos(90-lats)/360);
    lat_change(i) = y(i)/(2*pi*6371/360);
    lon(i) = mod(lons+lon_change(i),360);
    lat(i) = mod(lats+lat_change(i),180);
    r_plane = [6371*sin(lat(i)*pi/180)*cos(lon(i)*pi/180),6371*sin(lat(i)*pi/180)*sin(lon(i)*pi/180),6371*cos(lat(i)*pi/180)];
    d(i) = norm(r_plane-rs);
    if lon(i)>180
       plane_lon_path(i) = lon(i)-360;
    else
       plane_lon_path(i) = lon(i);
    end
    plane_lat_path(i) = 90-lat(i);
end
% goss_center_info = [lon(1,randi(N1)),lat(1,randi(N1))];
% for i = 1:num1
%     lon(1,N1+i) = mod(goss_center_info(1,1)+randn(),360);
%     lat(1,N1+i) = mod(goss_center_info(1,2)+randn(),180);
%     if lon(N1+i)>180
%        plane_lon_path(N1+i) = lon(N1+i)-360;
%     else
%        plane_lon_path(N1+i) = lon(N1+i);
%     end
%     plane_lat_path(N1+i) = 90-lat(N1+i);
% end

t = 0:0.02:2*pi;
plot(space*cos(t),space*sin(t),'r');
axis square
hold on
plot(x,y,'*');
lats = 30;
write_init_lon_data_2_file(plane_lon_path);
write_init_lat_data_2_file(plane_lat_path);
write_satellite_location(lons,lats,highs);
