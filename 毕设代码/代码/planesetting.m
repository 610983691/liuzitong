function [lon,lat,h] = planesetting(N,simu_time ,simu_step,lon_s,lat_s,high_s,velocity_s,path_s,ratio)
longitudes = zeros(1,simu_time/simu_step);
latitudes = zeros(1,simu_time/simu_step);
longitudes(1) = lon_s;
latitudes(1) = lat_s;
%�����λ��ʱ��ֱ���ýǶȱ�ʾ������ʱͨ��ת����ϵ��ɾ�γ�ȡ�
for clock = 1:simu_time/simu_step-1 
   latitudes(clock+1)= latitudes(clock) + velocity_s*cos(path_s)*time_step/(ratio+high_s);
   longitudes(clock+1) = longitudes(clock) + velocity_s*sin(path_s)*time_step/(ratio+high_s)/sin((latitudes(clock)*pi/180));
end
lon_max = max(longitudes);
lat_max = max(latitues);
lon_mix= min(longyitudes);
lat_max = min(latituds);
%�Էɻ����зֲ�

