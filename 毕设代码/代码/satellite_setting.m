function [lon,lat,high,velocity,path,ann_num,ann_power,ann_width] = satellite_setting()
lon = rand()*360;
lat = rand()*180;
high = 700;
velocity = 7.4;
path =rand()*360*pi/180;
ann_num = randi(2);
ann_power = randi(5)+9;
ann_width = randi(40);
end
