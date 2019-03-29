clear all;
N1 = 2000;
lats =90;
lons = 0;
highs = 700;
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
space = 6371*acos(6371/7071);%�������뾶
r = space*sqrt(rand(1,N1));
phy = 2*pi*rand(1,N1);
plane_lon_path = zeros(1,N1);
plane_lat_path = zeros(1,N1);
x = zeros(1,N1);
y = zeros(1,N1);
lon_change = zeros(1,N1);
lat_change = zeros(1,N1);
d = zeros(1,N1);
for i = 1:N1
    x(i)= r(i).*cos(phy(i));
    y(i) =r(i).*sin(phy(i));
    lon_change(i) = x(i)/(2*pi*6371*cos(90-lats)/360);
    lat_change(i) = y(i)/(2*pi*6371/360);
    lon = mod(lons+lon_change(i),360);
    lat = mod(lats+lat_change(i),180);
    r_plane = [6371*sin(lat*pi/180)*cos(lon*pi/180),6371*sin(lat*pi/180)*sin(lon*pi/180),6371*cos(lat*pi/180)];
    d(i) = norm(r_plane-rs);
    if lon>180
       plane_lon_path(i) = lon-360;
    else
       plane_lon_path(i) = lon;
    end
    plane_lat_path(i) = 90-lat;
end
t = 0:0.02:2*pi;
plot(space*cos(t),space*sin(t),'r');
axis square
hold on
plot(x,y,'*');
lats = 30;
write_init_lon_data_2_file(plane_lon_path);
write_init_lat_data_2_file(plane_lat_path);
write_satellite_location(lons,lats,highs);
