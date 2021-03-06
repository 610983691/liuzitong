clear all;
N1 = 2000;
lats =50;
lons = 20;
highs = 700;
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180);(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180);(highs+6371)*cos(lats*pi/180)];
space = 6371*acos(6371/7071);%球面距离半径
r = sin(acos(6371/(6371+highs)))*6371*sqrt(rand(1,N1));
phy = 2*pi*rand(1,N1);
num1 = 500;
plane_lon_path = zeros(1,N1+num1);
plane_lat_path = zeros(1,N1+num1);
x = zeros(1,N1);
y = zeros(1,N1);
% lon_change = zeros(1,N1);
% lat_change = zeros(1,N1);
d = zeros(1,N1);
lon = zeros(1,N1+num1);
lat = zeros(1,N1+num1);
for i = 1:N1
    x(i)= r(i).*cos(phy(i));
    y(i) =r(i).*sin(phy(i));
    %将这个点转换成卫星地心坐标系下的坐标表示方法
    %首先通过球面距离r(i)求出角度theta
    theta1 = r(i)/(2*pi*6371/360);
    distance = sqrt(6371^2+(6371+highs)^2-2*cos(theta1*pi/180)*6371*(6371+highs));
    theta = asin(6371*sin(theta1*pi/180)/distance);
    r_in_satellite = [distance*sin(pi-theta)*cos(phy(i));-distance*sin(pi-theta)*sin(phy(i));distance*cos(pi-theta)];
    A = [-sin(lons*pi/180),cos(lons*pi/180),0;cos(lats*pi/180)*cos(lons*pi/180),cos(lats*pi/180)*sin(lons*pi/180),...
        -sin(lats*pi/180);sin(lats*pi/180)*cos(lons*pi/180),sin(lats*pi/180)*sin(lons*pi/180),cos(lats*pi/180)];
    r_in_earth = A^-1*r_in_satellite+rs;  
%     lon_change(i) = x(i)/(2*pi*6371*cos((90-lats)*pi/180)/360);
%     lat_change(i) = y(i)/(2*pi*6371/360);
%     lon(i) = mod(lons+lon_change(i),360);
%     lat(i) = mod(lats+lat_change(i),180);
    lat(i)= acos(r_in_earth(3)/6371)*180/pi;
    if (r_in_earth(1)>=0)&&(r_in_earth(2)>=0)
        lon(i) = atan(r_in_earth(2)/r_in_earth(1))*180/pi;
    else
        if (r_in_earth(1)>=0)&&(r_in_earth(2)<0)
        lon(i) = atan(r_in_earth(2)/r_in_earth(1))*180/pi+360;
        else
            if (r_in_earth(1)<=0)&&(r_in_earth(2)>0)
                lon(i) = atan(r_in_earth(2)/r_in_earth(1))*180/pi+180;
            else
                if (r_in_earth(1)<0)&&(r_in_earth(2)<=0)
                lon(i) = atan(r_in_earth(2)/r_in_earth(1))*180/pi+180;
                end
            end
        end
    end      
    r_plane = [6371*sin(lat(i)*pi/180)*cos(lon(i)*pi/180);6371*sin(lat(i)*pi/180)*sin(lon(i)*pi/180);6371*cos(lat(i)*pi/180)];
    d(i) = norm(r_plane-rs);
    if lon(i)>180
       plane_lon_path(i) = lon(i)-360;
    else
       plane_lon_path(i) = lon(i);
    end
    plane_lat_path(i) = 90-lat(i);
end
flag = 0;
for i = 1:2000
    if lat(i)>lats
        flag = flag+1;
    end
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
lats = 90-lats;
write_init_lon_data_2_file(plane_lon_path);
write_init_lat_data_2_file(plane_lat_path);
write_satellite_location(lons,lats,highs);
