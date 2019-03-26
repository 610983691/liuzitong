clear all;
N1 = 100;
lats = 60;
lons = 20;
highs = 700;
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
space = 6371*acos(6371/7071);
lon_change = abs(acos(6371/7071)/cos((90-lats)*pi/180))*180/pi;
lons_up = mod(lons+lon_change,360);
lons_down = mod(lons-lon_change,360);
lat_change = acos(6371/7071)*180/pi;
lats_up = lats + lat_change;
if lats_up>180
    lats_up = 180;
end
lats_down = lats - lat_change;
if lats_down<0
    lats_down = 0;
end
plane_lon = zeros(1,N1);
plane_lat = zeros(1,N1);
plane_lon_path = zeros(1,N1);
for i = 1:N1
    lon =  rand()*(lons_up-lons_down)+lons_down;
    lat =  rand()*(lats_up-lats_down)+lats_down;
    r = [6371*sin(lat*pi/180)*cos(lon*pi/180),6371*sin(lat*pi/180)*sin(lon*pi/180),6371*cos(lat*pi/180)];
    while (norm(r-rs)>sqrt(7071^2-6371^2))
         lon = rand()*(lons_up-lons_down)+lons_down;
         lat = rand()*(lats_up-lats_down)+lats_down;
    end
    plane_lon(i) = lon;
    plane_lat(i) = lat;
    if plane_lon(i)>180
       plane_lon_path(1,i) = plane_lon(i)-360;
    else
       plane_lon_path(1,i) = plane_lon(i); 
    end
end
    plane_lat_path = 90-plane_lat;
    write_init_lon_data_2_file(plane_lon_path);
write_init_lat_data_2_file(plane_lat_path);
