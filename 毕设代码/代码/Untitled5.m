clear all;
N = 2000;
lons = 20;
lats = 120;
highs=700;
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180);(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180);(highs+6371)*cos(lats*pi/180)];
[lon_down,lon_up] = goss_lon_range(lons,lats,highs);
[lat_down,lat_up] = goss_lat_range(lons,lats,highs,lon_down,lon_up,lons);
lat_down = 90-lat_down;
lat_up = 90-lat_up;
if lon_up<0
    lon_up = lon_up+360;
end
if lon_down<0
    lon_down = lon_down+360;
end 
if lon_down>lon_up
    lon_up = lon_up+360;
end
lon = zeros(1,N);
lat = zeros(1,N);
plane_lon_path = zeros(1,N);
plane_lat_path = zeros(1,N);
for i = 1:N
    lon(i) = mod(rand()*(lon_up-lon_down)+lon_down,360);
    lat(i) = rand()*(lat_up-lat_down)+lat_down;
    r = [6371*sin(lat(i)*pi/180)*cos(lon(i)*pi/180);6371*sin(lat(i)*pi/180)*sin(lon(i)*pi/180);6371*cos(lat(i)*pi/180)];
    while(norm(r-rs)>sqrt((highs+6371)^2-6371^2))
         lon(i) = mod(rand()*(lon_up-lon_down)+lon_down,360);
         lat(i) = rand()*(lat_up-lat_down)+lat_down;  
         r = [6371*sin(lat(i)*pi/180)*cos(lon(i)*pi/180);6371*sin(lat(i)*pi/180)*sin(lon(i)*pi/180);6371*cos(lat(i)*pi/180)];
    end
end
for i = 1:N
    if lon(i)>180
        plane_lon_path(i) = lon(i)-360;
    else
        plane_lon_path(i) = lon(i);
    end
    plane_lat_path(i) = 90-lat(i);
end
flag = 0;
for i = 1:N
    if (lat(i)>lats)
        flag = flag+1;
    end
end
flag1 = 0;
for i = 1:N
    if (lat(i)<lats)
        flag1 = flag1+1;
    end
end
if lons>180
    lons = lons-360;
end
lats = 90-lats;
write_init_lon_data_2_file(plane_lon_path);
write_init_lat_data_2_file(plane_lat_path);
write_satellite_location(lons,lats,highs);
          

