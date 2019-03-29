 function [plane] = PlaneDistribute(lons,lats,highs,N1,goss_plane_num_arr,goss_center_info)% ���ǵľ���ά�ȸ߶�,���ȷֲ�����,ÿ����˹�ֲ�����ɻ���������˹�ֲ����ĵ���Ϣ 
%N1 = 10;%���ȷֲ��ɻ�����
goss_num = size(goss_plane_num_arr,2);%��˹�ֲ��������
goss_plane_num = goss_plane_num_arr;%ÿ����˹�ֲ��ķɻ����������Ǹ�����
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
N = N1;
for i = 1:goss_num
    N = N+goss_plane_num(i);
end
plane = zeros(7,N);
space = 6371*acos(6371/7071);%�������뾶
r = space*sqrt(rand(1,N1));
phy = 2*pi*rand(1,N1);
plane_lon_path = zeros(1,N1);
plane_lat_path = zeros(1,N1);
x = zeros(1,N1);
y = zeros(1,N1);
lon_change = zeros(1,N1);
lat_change = zeros(1,N1);
for i = 1:N1
    x(i)= r(i).*cos(phy(i));
    y(i) =r(i).*sin(phy(i));
    lon_change(i) = x(i)/(2*pi*6371*cos(90-lats)/360);
    lat_change(i) = y(i)/(2*pi*6371/360);
    plane(1,i) = mod(lons+lon_change(i),360);
    plane(2,i) = mod(lats+lat_change(i),180);
%     r_plane = [6371*sin(lat*pi/180)*cos(lon*pi/180),6371*sin(lat*pi/180)*sin(lon*pi/180),6371*cos(lat*pi/180)];
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
            plane(1,N1+j) = mod(goss_center_info(i,1)+randn(),360);
            plane(2,N1+j) = mod(goss_center_info(i,2)+randn(),180);

        end
        N1 = N1+goss_plane_num(i);
    end
end

%��������ٶȡ�����ǡ�����
for i = 1:N
    plane(3,i) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
    plane(4,i) = (rand()*2+800)/3600;
    plane(5,i) = rand()*360*pi/180;
    plane(6,i) = rand()*4+50;%dnm
    plane(7,i) = randi(8)*64;%Ӣ��ÿ����
end
 end


