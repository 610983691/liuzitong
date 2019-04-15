function [ mess_112_hex,time_asix,mess_rec_all,mess_rec_all1,mess_rec_all2,plane_lon,plane_lat,plane_high,planes_id] = satellite_simple_gui_main(plane_para,simu_time,lon_s,lat_s,high_s,velocity_s,path_s,ann_num,ann_power,ann_width,planes_id,min_rec_power)

simu_step =1e-3;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 300*10^6;
fc_mid = 40*10^6; %中频载波频率40MHz
fc = 1090;%发射频率1090MHz  


%卫星的参数设置

satellite_lon = zeros(1,simu_time/simu_step);
satellite_lat = zeros(1,simu_time/simu_step);
satellite_high = zeros(1,simu_time/simu_step);


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

cpr = randi(2,1,N)-1;%0表示奇编码；1表示偶编码

mess_112_all = [];
time_rec_all = [];

%天线增益
theta = 0:pi/180:pi/2;
value = xlsread('天线增益实测值.xls','M:M')';
X =0:pi/10000:pi/2;
measured_value = spline(theta,value,X);



%飞机类
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,plane_para(1,i),plane_para(2,i),plane_para(3,i),plane_para(4,i),plane_para(5,i),ceil(rand(1)*10),plane_para(7,i) );
%仿真时长，仿真步进，经度，纬度，高度，速度，加速度，航向角，仰角
end
%卫星类
satellite = PLANET(simu_time,simu_step,lon_s,lat_s,high_s,velocity_s,path_s,ann_num);%卫星的经纬高、速度、航向角。


for i = 1:N
    clock = 0;
    flag = 0;%记录报文个数
    type = randi(4);
    type_code(1,:) = bitget(type,5:-1:1);
    even_old = cpr(i);
while(clock<(simu_time/simu_step))  
    plane{i} = ChangePosition(plane{i},ratio);
    plane{i} = BroadCast(plane{i},clock); 
    satellite = ChangePositionS(satellite,ratio);

    
    plane_lon(i,clock+1) = plane{i}.longitude;
    plane_lat(i,clock+1) = plane{i}.latitude;
    plane_high(i,clock+1) = plane{i}.hight;
    
    satellite_lon(1,clock+1) = satellite.longitude;
    satellite_lat(1,clock+1) = satellite.latitude;
    satellite_high(1,clock+1) = satellite.hight;

    %编码过程
    if norm(plane{i}.r_h-satellite.r)<=sqrt((ratio+high_s)^2-ratio^2);
    if plane{i}.broad_times(1,clock+1) ~= 0
        cpr_flag = 0;  
    if plane{i}.broad_times(1,clock+1)==1%位置信息是奇编码还是偶编码，首先判断是否是 位置信息
       even_old =  mod(even_old+1,2);%奇偶编码0,1交替出现
       cpr_flag = even_old;
    end
    
    
    flag = flag+1;%报文数量增加
    
    %编码过程
    [mecode,mess] = messcode(clock,plane{i}.broad_times,plane{i}.longitude,plane{i}.latitude,plane{i}.hight,even_old,...
    plane{i}.velocity,plane{i}.path_angle,type_code,plane_ID_double(i,:),i,plane_para(7,i));
    mess112 = crcencode(code_heading(i,:),mecode);
    mess_112_all = [mess_112_all;mess112];
    
    %加上损耗增益等
    
    %单天线场景
    if ann_num==1
    [loss,gain,fd,dely_time] = parameter1(plane{i}.r,plane{i}.v,satellite.r,satellite.v,fc,c,measured_value,ann_width,ann_power);%c 参数计算函数;
    rec_power = plane_para(6,i)+gain-loss;%接收功率
    if rec_power>=min_rec_power
      plane{i}.power = [plane{i}.power,rec_power];%w
      peakU = sqrt(2* 10^(rec_power/10)/10^3);
      rec_time = clock*simu_step+dely_time;
    %信息放在同一个矩阵
     plane{i}.LOSS = [plane{i}.LOSS,loss];
     plane{i}.shift_f = [plane{i}.shift_f,fd];
     plane{i}.ant_gain = [plane{i}.ant_gain,gain];
     plane{i}.mess_all = [plane{i}.mess_all;rec_time,plane_para(6,i),loss,gain,rec_power,fd,mess(1,2:8)];
     plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
     plane{i}.rec_time = [plane{i}.rec_time,[rec_time;clock*simu_step*10^3;i;flag;rec_power;plane{i}.longitude;...
                         plane{i}.latitude;plane{i}.hight;plane{i}.NS_v*3600/1.852;plane{i}.WE_v*3600/1.852;plane{i}.rate_v;plane{i}.broad_times(1,clock+1);cpr_flag]];
    %ppm调制
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid);%z中频信号
    ppm_value1 = ppm*peakU;
    ppm_value=ppm_value1*10^4;
    plane{i}.ppmseq = [plane{i}.ppmseq;ppm];
    plane{i}.seq_mid = [plane{i}.seq_mid;ppm_value]; 
    end
    end
    
    %双天线场景
    if ann_num==2
    [loss,gain1,gain2,fd,dely_time] = parameter2(plane{i}.r,plane{i}.v,satellite.r,satellite.v,fc,c,measured_value,ann_width,satellite.ann1,satellite.ann2,ann_power);%c 参数计算函数;   
    rec_power1 = plane_para(6,i)+gain1-loss;%接收功率
    rec_power2 = plane_para(6,i)+gain2-loss;%接收功率
    if (rec_power1>=min_rec_power)||(rec_power2>=min_rec_power)
       plane{i}.power = [plane{i}.power,[rec_power1;rec_power2]];
       peakU1 = 10^6*sqrt(2* 10^(rec_power1/10)/10^3);
       peakU2 = 10^6*sqrt(2* 10^(rec_power2/10)/10^3);
       rec_time = clock*simu_step+dely_time;
    
    
       plane{i}.LOSS = [plane{i}.LOSS,loss];
       plane{i}.shift_f = [plane{i}.shift_f,fd];    
       plane{i}.ant_gain = [plane{i}.ant_gain,[gain1;gain2]];
       plane{i}.mess_all = [plane{i}.mess_all;rec_time,plane_para(6,i),loss,gain1,gain2,rec_power1,rec_power2,fd,mess(1,2:8)];
       plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
       plane{i}.rec_time = [plane{i}.rec_time,[rec_time;clock*simu_step;i;flag;rec_power1;rec_power2;plane{i}.longitude;...
                         plane{i}.latitude;plane{i}.hight;plane{i}.NS_v*3600/1.852;plane{i}.WE_v*3600/1.852;plane{i}.rate_v;plane{i}.broad_times(1,clock+1);cpr_flag]];

  
    
    %ppm调制
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid);%z中频信号
    ppm_value1 = ppm*peakU1;
    ppm_value2 = ppm*peakU2;
    plane{i}.ppmseq = [plane{i}.ppmseq;ppm];
    plane{i}.seq_mid1 = [plane{i}.seq_mid1;ppm_value1]; 
    plane{i}.seq_mid2 = [plane{i}.seq_mid2;ppm_value2]; 
    end
    end
    
    end
    end
    
    
   
       %开始进行位置信息编码，最重要的是经纬度编码和高度编码
        clock = clock + 1;   
        
end

time_rec_all = [time_rec_all , plane{i}.rec_time];
end

% t = 0:1/fs*rs:120-1/fs*rs;
% plot(t,plane{1}.ppmseq(1,:),'r');
% xlabel('采样点');30
% ylabel('amplitude');
time_asix = zeros(size(time_rec_all,1),size(time_rec_all,2));%没有接收时间
[time_asix(1,:),index] = sort(time_rec_all(1,:));%根据发送时间排序 

for i = 1:size(time_rec_all,2)
    for j = 2:size(time_rec_all,1)
    time_asix(j,i) = time_rec_all(j,index(i));
    end
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

% mess_rec_all = [];
% for i = 1:length(time_rec_all)
%     A = [time_asix(:,i);plane{time_asix(3,i)}.mess_all(time_asix(4,i),2:14)'];
%      mess_rec_all = [mess_rec_all,A];
% end
   mess_rec_all = [];
   mess_rec_all1 = [];
   mess_rec_all2 = [];
if ann_num==1
%将角度变成经纬度 6、7行
     for  i = 1:size(time_rec_all,2)
            if time_asix(6,i)>180
                time_asix(6,i) = time_asix(6,i)-360;
            end
            time_asix(7,i) = 90-time_asix(7,i);
     end    
     for i = 1:size(time_rec_all,2)
          A = [time_asix(:,i);plane{time_asix(3,i)}.power(time_asix(4,i));plane{time_asix(3,i)}.seq_mid(time_asix(4,i),:)'];
          mess_rec_all = [mess_rec_all,A];
     end
    for i = 1:size(time_rec_all,2)-1
      if time_asix(1,i+1)-time_asix(1,i)<120*10^-6
          time_diff =ceil((time_asix(1,i+1)-time_asix(1,i))*10^6*fs/rs);
          asix_mess = zeros(1,120*fs/rs+time_diff);
          asix_mess =asix_mess+[plane{time_asix(3,i)}.seq_mid(time_asix(4,i),:),zeros(1,time_diff)];
          asix_mess =asix_mess +[zeros(1,time_diff),plane{time_asix(3,i+1)}.seq_mid(time_asix(4,i+1),:)];
      end
   end
end
if ann_num==2
%将角度变成经纬度 7、8行
     for  i = 1:size(time_rec_all,2)
            if time_asix(7,i)>180
                time_asix(7,i) = time_asix(7,i)-360;
            end
            time_asix(8,i) = 90-time_asix(8,i);
     end  
     for i = 1:size(time_rec_all,2)
         if plane{time_asix(3,i)}.power(1,time_asix(4,i))>=min_rec_power
         A = [time_asix(:,i);plane{time_asix(3,i)}.power(1,time_asix(4,i));plane{time_asix(3,i)}.seq_mid1(time_asix(4,i),:)'];
          mess_rec_all1 = [mess_rec_all1,A];
         end
     end  

     for i = 1:size(time_rec_all,2)
         if plane{time_asix(3,i)}.power(2,time_asix(4,i))>=min_rec_power
          A = [time_asix(:,i);plane{time_asix(3,i)}.power(2,time_asix(4,i));plane{time_asix(3,i)}.seq_mid2(time_asix(4,i),:)'];
          mess_rec_all2 = [mess_rec_all2,A];
         end
     end  
end   
end


  
