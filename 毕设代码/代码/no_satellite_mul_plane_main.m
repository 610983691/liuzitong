function [mess_test,mess_112_hex,time_asix,mess_rec_all,plane_lon,plane_lat,plane_high,planes_id] =no_satellite_mul_plane_main(plane_para,simu_time,planes_id)

plane_ann_num = 1;
simu_step =1e-3;%10us
ratio = 6371;%KM
rs = 1*10^6;
fs = 300*10^6;
fc_mid = 40*10^6; %中频载波频率40MHz



N= size(plane_para,2);
plane_lon = zeros(N,round(simu_time/simu_step/100));
plane_lat = zeros(N,round(simu_time/simu_step/100));
plane_high = zeros(N,round(simu_time/simu_step/100));
velocity = zeros(N,round(simu_time/simu_step));
% rec_position_lon = zeros(N,2);
% rec_position_lat = zeros(N,2);
for i = 1:N
plane_lon(i,1) = plane_para(1,i);
plane_lat(i,1) = plane_para(2,i);
plane_high(i,1) = plane_para(3,i);
velocity(i,1) = plane_para(4,i);
end

plane_ICAO_double = zeros(N,1);
plane_ID_double = zeros(N,8);
for i = 1:N
   plane_ICAO_double(i,1) = hex2dec(planes_id{1,i});
   plane_ID_double(i,:) = double(planes_id{2,i});
end

code_heading = zeros(N,32);
for i = 1:N
    icaobin = bitget(plane_ICAO_double(i,1),24:-1:1);  
    code_heading(i,:) = [1 ,0 ,0 ,0, 1,0,1,0,icaobin]; %DF CA AA
end



%信息的不同主要体现在ME字段的不同所以ME字段前面的编码可以在程序前就直接写好


mess_112_all = [];
time_rec_all = [];

cpr = randi(2,1,N)-1;%0表示奇编码；1表示偶编码



%飞机类
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,plane_para(1,i),plane_para(2,i),plane_para(3,i),plane_para(4,i),plane_para(5,i),simu_step,plane_para(7,i));
%仿真时长，仿真步进，经度，纬度，高度，速度，加速度，航向角，仰角
end



for i = 1:N
    clock = 0;
    flag = 0;%记录报文个数
%     flag_position = 0;
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
    if mod(clock,100)==0
       plane_lon(i,round(clock/100)+1) = plane{i}.longitude;
       plane_lat(i,round(clock/100)+1) = plane{i}.latitude;
       plane_high(i,round(clock/100)+1) = plane{i}.hight;
    end
    

    %编码过程
    if plane{i}.broad_times(1,clock+1) ~= 0
                
     flag = flag+1;%报文数量增加
     cpr_flag= 0;
    if plane{i}.broad_times(1,clock+1)==1%位置信息是奇编码还是偶编码，首先判断是否是位置信息
%         flag_position = flag_position+1;
       even_old =  mod(even_old+1,2);%不考虑上下天线时的cpr情况
%        cpr_all= [cpr_all,[even_old;flag]];%不考虑上下天线时的这一架飞机的所有cpr情况，并且记录下这是飞机的第几个报文
       cpr_flag = even_old;%不考虑上下天线时最后的输入列表中表示奇偶编码的变量
    end
        

    
    %编码过程
    [mecode,mess] = messcode(clock,plane{i}.broad_times,plane{i}.longitude,plane{i}.latitude,plane{i}.hight,even_old,...
    plane{i}.velocity,plane{i}.path_angle,type_code,plane_ID_double(i,:),i,plane_para(7,i));%最后一个是飞机的垂直速度
    mess112 = crcencode(code_heading(i,:),mecode);
%     if flag_position==1%第一个报文信息
%        lat1 = mess112(1,55:71);
%        lon1 = mess112(1,71:88);
%        cpr1 = mess112(1,54);
%     end
%    if flag_position==2%第二个报文信息
%        lat2 = mess112(1,55:71);
%        lon2= mess112(1,71:88);
%        cpr2 = mess112(1,54);
%        %CPR解码
%        [rec_position_lon(i,1),rec_position_lat(i,1)] = cprdecode(lat1,lon1,cpr1,lat2,lon2);      
%     end
    mess_112_all = [mess_112_all;mess112];
    
    %加上损耗增益等
    peakU = 10^6*sqrt(2* 10^(plane_para(6,i)/10)/10^3);
    %信息放在同一个矩阵
    plane{i}.mess_all = [plane{i}.mess_all;plane_para(6,i),mess(1,2:8)];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time =[plane{i}.rec_time,[clock*simu_step*10^3;i;flag;plane_para(6,i);plane{i}.longitude;...
                         plane{i}.latitude;plane{i}.hight;plane{i}.NS_v*3600/1.852;plane{i}.WE_v*3600/1.852;plane{i}.rate_v;plane{i}.broad_times(1,clock+1);cpr_flag]];%发报时间要加上时间 的抖动
    %ppm调制
    fd = 0;
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid);%z中频信号
    ppm_value = ppm*peakU;
    plane{i}.ppmseq = [plane{i}.ppmseq;ppm];
    plane{i}.seq_mid = [plane{i}.seq_mid;ppm_value]; 
    end
     clock = clock + 1;
end
% if plane{i}.rec_time(5,flag)>180
%     rec_position_lon(i,2)  = plane{i}.rec_time(5,flag)-360;
% else
%     rec_position_lon(i,2)  = plane{i}.rec_time(5,flag);
% end
%     rec_position_lat(i,2)  = 90-plane{i}.rec_time(6,flag);
   time_rec_all = [time_rec_all , plane{i}.rec_time];
end
time_asix = zeros(size(time_rec_all,1),size(time_rec_all,2));%没有接收时间
[time_asix(1,:),index] = sort(time_rec_all(1,:));%根据发送时间排序 

for i = 1:size(time_rec_all,2)
    for j = 2:size(time_rec_all,1)
    time_asix(j,i) = time_rec_all(j,index(i));
    end
end
%将角度变成经纬度 第5、6行
for  i = 1:size(time_rec_all,2)
            if time_asix(5,i)>180
                time_asix(5,i) = time_asix(5,i)-360;
            end
            time_asix(6,i) = 90-time_asix(6,i);
end
           
mess_112_hex = cell(4,size(time_rec_all,2));%报文个数%用四个位置储存112bit的数据，每个位置是七位的16进制
for i = 1:size(time_rec_all,2)
    dec112 = zeros(1,4);
    for j = 1:4
           dec112(1,j) = 0; 
        for k = 1:28
           dec112(1,j) = dec112(1,j)+mess_112_all(index(i),(j-1)*28+k)*2^(28-k) ;
        end
        mess_112_hex{j,i} = dec2hex(dec112(1,j));
    end
end

  mess_rec_all = [];
  for i = 1:size(time_rec_all,2)
          A = [time_asix(:,i);plane_para(6,time_asix(2,i));plane{time_asix(2,i)}.seq_mid(time_asix(3,i),:)'];
          mess_rec_all = [mess_rec_all,A];
  end

  max_time  = max(time_asix(1,:));
  mess_test = [];
  for i = 1:size(time_asix,2)
      mess_test = [mess_test,mess_rec_all(14:size(mess_rec_all,1),i)'];
      if i<=size(time_asix,2)-1
         time = (time_asix(1,i+1)-time_asix(1,i))/10^7;
         mess_test = [mess_test,zeros(1,ceil(time/(rs/fs)))];
      end

  end
  mess_all=[];
% for i = 1:size(time_asix,2)-1
%     if (time_asix(1,i+1)-time_asix(1,i)<120*10^-6)
%         mess=
        
  
end
