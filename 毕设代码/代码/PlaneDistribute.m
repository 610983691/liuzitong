 function [plane] = PlaneDistribute(lons,lats,highs,N1,goss_plane_num_arr,goss_center_info,goss_para)% 卫星的经度维度高度,均匀分布个数,每个高斯分布区域飞机个数，高斯分布中心点信息 
%N1 = 10;%均匀分布飞机个数
goss_num = size(goss_plane_num_arr,2);%高斯分布区域个数
goss_plane_num = goss_plane_num_arr;%每个高斯分布的飞机个数，这是个数组
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180);(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180);(highs+6371)*cos(lats*pi/180)];
N = N1;
for i = 1:goss_num
    N = N+goss_plane_num(i);
end
plane = zeros(7,N);
space = 6371*acos(6371/7071);%球面距离半径
r = space*sqrt(rand(1,N1));
plane_lon_path = zeros(1,N1);
plane_lat_path = zeros(1,N1);
lon = zeros(1,N1);
lat = zeros(1,N1);
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
for i = 1:N1
    lon(i) = mod(rand()*(lon_up-lon_down)+lon_down,360);
    lat(i) = rand()*(lat_up-lat_down)+lat_down;
    r3 = [6371*sin(lat(i)*pi/180)*cos(lon(i)*pi/180);6371*sin(lat(i)*pi/180)*sin(lon(i)*pi/180);6371*cos(lat(i)*pi/180)];
    while(norm(r3-rs)>sqrt((highs+6371)^2-6371^2))
         lon(i) = mod(rand()*(lon_up-lon_down)+lon_down,360);
         lat(i) = rand()*(lat_up-lat_down)+lat_down;  
         r3 = [6371*sin(lat(i)*pi/180)*cos(lon(i)*pi/180);6371*sin(lat(i)*pi/180)*sin(lon(i)*pi/180);6371*cos(lat(i)*pi/180)];
    end
    plane(1,i) = lon(i);
    plane(2,i) = lat(i);
    
%     x(i)= r(i).*cos(phy(i));
%     y(i) =r(i).*sin(phy(i));
%     lon_change(i) = x(i)/(2*pi*6371*cos(90-lats)/360);
%     lat_change(i) = y(i)/(2*pi*6371/360);
%     plane(1,i) = mod(lons+lon_change(i),360);
%     plane(2,i) = mod(lats+lat_change(i),180);
% %     r_plane = [6371*sin(lat*pi/180)*cos(lon*pi/180),6371*sin(lat*pi/180)*sin(lon*pi/180),6371*cos(lat*pi/180)];
    if  plane(1,i)>180
       plane_lon_path(i) = plane(1,i)-360;
    else
       plane_lon_path(i) =  plane(1,i);
    end
    plane_lat_path(i) = 90- plane(2,i);
end

if goss_num~=0
    for i = 1:goss_num
        for j = 1:goss_plane_num(i)
            plane(1,N1+j) = mod(goss_center_info(i,1)*sqrt(goss_para(1,i))+randn(),360);
            plane(2,N1+j) = goss_center_info(i,2)*sqrt(goss_para(1,i))+randn();
            if plane(2,N1+j)>180
               plane(2,N1+j) = 180-(plane(2,N1+j)-180);
            end
        end
        N1 = N1+goss_plane_num(i);
    end
end

%随机分配速度、航向角、功率
for i = 1:N
    plane(3,i) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
    plane(4,i) = (rand()*2+800)/3600;
    plane(5,i) = rand()*360*pi/180;
    plane(6,i) = rand()*4+50;%dnm
    plane(7,i) = randi(8)*64;%英尺每分钟
end
 end


