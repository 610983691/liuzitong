function [time_asix,mess_rec_all,plane_lon,plane_lat,plane_high,planes_id] =no_satellite_mul_plane_main(plane_para,simu_time,planes_id)

plane_ann_num = 1;
simu_step =1e-7;%s
ratio = 6371;%KM
rs = 1*10^6;
fs = 200*10^6;
fc_mid = 40*10^6; %中频载波频率40MHz



N= size(plane_para,2);
plane_lon = zeros(N,simu_time/simu_step);
plane_lat = zeros(N,simu_time/simu_step);
plane_high = zeros(N,simu_time/simu_step);
velocity = zeros(N,simu_time/simu_step);
for i = 1:N
plane_lon(i,1) = plane_para(1,i);
plane_lat(i,1) = plane_para(2,i);
plane_high(i,1) = plane_para(3,i);
velocity(i,1) = plane_para(4,i);
end

plane_ICAO_double = zeros(N,4);
plane_ID_double = zeros(N,8);
for i = 1:N
   plane_ICAO_double(i,:) = double(planes_id{1,i});
   plane_ID_double(i,:) = double(planes_id{2,i});
end

code_heading = zeros(N,32);
for i = 1:N
    icaobin = zeros(1,24);
    for j = 1:4 
            icaobin(1,(j*6-5):(j*6)) = bitand(bitget(plane_ICAO_double(i,j),6:-1:1),[1,1,1,1,1,1]);  
     end
    code_heading(i,:) = [1 ,0 ,0 ,0, 1,0,1,0,icaobin]; %DF CA AA
end



%信息的不同主要体现在ME字段的不同所以ME字段前面的编码可以在程序前就直接写好



time_rec_all = [];

cpr = randi(2,1,N)-1;%0表示奇编码；1表示偶编码



%飞机类
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,plane_para(1,i),plane_para(2,i),plane_para(3,i),plane_para(4,i),plane_para(5,i),ceil(rand(1)*10),plane_para(7,i));
%仿真时长，仿真步进，经度，纬度，高度，速度，加速度，航向角，仰角
end



for i = 1:N
    clock = 0;
    flag = 0;%记录报文个数
    type = randi(4);
    type_code(1,:) = bitget(type,5:-1:1); 
    even_old = cpr(i);   
%     cpr_all = [];
while(clock<(simu_time/simu_step))  
    plane{i} = ChangePosition(plane{i},ratio);
    switch plane_ann_num
        case 1
        plane{i} = BroadCast(plane{i},clock); 
        case 2
        plane{i} = BroadCast1(plane{i},clock); 
    end
            
    clock = clock + 1;
    
    plane_lon(i,clock) = plane{i}.longitude;
    plane_lat(i,clock) = plane{i}.latitude;
    plane_high(i,clock) = plane{i}.hight;
    

    %编码过程
    if plane{i}.broad_times(1,clock) ~= 0
                
     flag = flag+1;%报文数量增加
      cpr_flag = 0;  
    if plane{i}.broad_times(1,clock)==1%位置信息是奇编码还是偶编码，首先判断是否是位置信息
       even_old =  mod(even_old+1,2);%不考虑上下天线时的cpr情况
%        cpr_all= [cpr_all,[even_old;flag]];%不考虑上下天线时的这一架飞机的所有cpr情况，并且记录下这是飞机的第几个报文
       cpr_flag = even_old+1;%不考虑上下天线时最后的输入列表中表示奇偶编码的变量
    end
        

    
    %编码过程
    [mecode,mess] = messcode(clock,plane{i}.broad_times,plane{i}.longitude,plane{i}.latitude,plane{i}.hight,even_old,...
    plane{i}.velocity,plane{i}.path_angle,type_code,plane_ID_double(i,:),i,plane_para(7,i));%最后一个是飞机的垂直速度
    mess112 = crcencode(code_heading(i,:),mecode);
    
    %加上损耗增益等
    
    peakU = 10^6*sqrt(2* 10^(plane_para(6,i)/10)/10^3);
    %信息放在同一个矩阵
    plane{i}.mess_all = [plane{i}.mess_all;plane_para(6,i),mess(1,2:8)];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time =[plane{i}.rec_time,[plane{i}.last_broadtime*simu_step*10^3;i;flag;plane_para(6,i);plane{i}.longitude;...
                         plane{i}.latitude;plane{i}.hight;plane{i}.NS_v*3600/1.852;plane{i}.WE_v*3600/1.852;plane{i}.rate_v;plane{i}.broad_times(1,clock);even_old]];%发报时间要加上时间 的抖动
    %ppm调制
    fd = 0;
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid);%z中频信号
    ppm_value = ppm*peakU;
    plane{i}.ppmseq = [plane{i}.ppmseq;ppm];
    plane{i}.seq_mid = [plane{i}.seq_mid;ppm_value]; 
    end
end
   time_rec_all = [time_rec_all , plane{i}.rec_time];
end
time_asix = zeros(size(time_rec_all,1),size(time_rec_all,2));%没有接收时间
[time_asix(1,:),index] = sort(time_rec_all(1,:));%根据发送时间排序 

for i = 1:size(time_rec_all,2)
    for j = 2:size(time_rec_all,1)
    time_asix(j,i) = time_rec_all(j,index(i));
    end
end
  mess_rec_all = [];
  for i = 1:size(time_rec_all,2)
          A = [time_asix(:,i);plane_para(6,time_asix(2,i));plane{time_asix(2,i)}.seq_mid(time_asix(3,i),:)'];
          mess_rec_all = [mess_rec_all,A];
     end
end
