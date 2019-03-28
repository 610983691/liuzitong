function signal_main_tj(plane_para,simu_time,lon_s,lat_s,high_s,velocity_s,path_s,ann_num,ann_power,ann_width)

simu_step =1e-2;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 500*10^6;
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


character_select = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N',...
                    'O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1',...
                    '2','3','4','5','6','7','8','9',' '};
plane_ID =cell(N,8);
select1 = unidrnd(37,N,8);
for i = 1:N
    for j = 1:8
       plane_ID{i,j} = character_select(select1(i,j));
    end
end
plane_ID1 = zeros(N,8);
for i = 1:N
    for j = 1:8
        plane_ID1(i,j) = cell2mat(plane_ID{i,j});
    end
end

plane_ICAO = cell(N,4);
select2 = unidrnd(26,N,4);
for i = 1:N
    for j = 1:4
       plane_ICAO{i,j} = character_select(select2(i,j));
    end
end
plane_ICAO1 = zeros(N,4);
for i = 1:N
    for j = 1:4
        plane_ICAO1(i,j) = cell2mat(plane_ICAO{i,j});
    end
end
ICAO = zeros(N,24);
code_heading = zeros(N,32);
for i = 1:N
    icaobin = zeros(1,24);
    for j = 1:4 
            icaobin(1,(j*6-5):(j*6)) = bitand(bitget(plane_ICAO1(i,j),6:-1:1),[1,1,1,1,1,1]);  
     end
    code_heading(i,:) = [1 ,0 ,0 ,0, 1,0,1,0,icaobin]; %DF CA AA
end



%信息的不同主要体现在ME字段的不同所以ME字段前面的编码可以在程序前就直接写好

mecode = zeros(1,56);


time_rec_all = [];

%天线增益
theta = 0:pi/180:pi/2;
value = xlsread('天线增益实测值.xls','M:M')';
X =0:pi/10000:pi/2;
measured_value = spline(theta,value,X);



%飞机类
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,plane_para(1,i),plane_para(2,i),plane_para(3,i),plane_para(4,i),plane_para(5,i),ceil(rand(1)*10) );
%仿真时长，仿真步进，经度，纬度，高度，速度，加速度，航向角，仰角
end
%卫星类
satellite = PLANET(simu_time,simu_step,lon_s,lat_s,high_s,velocity_s,path_s,ann_num);%卫星的经纬高、速度、航向角。


for i = 1:N
    clock = 0;
    flag = 0;%记录报文个数
    type = randi(4);
    type_code(1,:) = bitget(type,5:-1:1); 
while(clock<(simu_time/simu_step))  
    plane{i} = ChangePosition(plane{i},ratio);
    plane{i} = BroadCast(plane{i},clock); 
    satellite = ChangePositionS(satellite,ratio);
    clock = clock + 1;
    
    plane_lon(i,clock) = plane{i}.longitude;
    plane_lat(i,clock) = plane{i}.latitude;
    plane_high(i,clock) = plane{i}.hight;
    
    satellite_lon(1,clock) = satellite.longitude;
    satellite_lat(1,clock) = satellite.latitude;
    satellite_high(1,clock) = satellite.hight;

    %编码过程
    if norm(plane{i}.r_h-satellite.r)<=3074 
    if plane{i}.broad_times(1,clock) ~= 0
    

    flag = flag+1;%报文数量增加
    
    %编码过程
    [mecode,mess] = messcode(clock,plane{i}.broad_times,plane{i}.longitude,plane{i}.latitude,plane{i}.hight,plane{i}.cpr_f,...
    plane{i}.velocity,plane{i}.path_angle,type_code,plane_ID1(i,:),i);
    mess112 = crcencode(code_heading(i,:),mecode);
    
    %加上损耗增益等
    
    %单天线场景
    if ann_num==1
    [loss,gain,fd,dely_time] = parameter1(plane{i}.r,plane{i}.v,satellite.r,satellite.v,fc,c,measured_value,ann_width);%c 参数计算函数;
    rec_power = plane_para(6,i)+gain-loss;%接收功率
    plane{i}.power = [plane{i}.power,rec_power];%w
    peakU = 10^6*sqrt(2* 10^(rec_power/10)/10^3);
    rec_time = clock*simu_step+dely_time;
    %信息放在同一个矩阵
    plane{i}.LOSS = [plane{i}.LOSS,loss];
    plane{i}.shift_f = [plane{i}.shift_f,fd];
    plane{i}.ant_gain = [plane{i}.ant_gain,gain];
    plane{i}.mess_all = [plane{i}.mess_all;rec_time,plane_para(6,i),loss,gain,rec_power,fd,mess(1,2:8)];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time = [plane{i}.rec_time,[clock*simu_step;rec_time;i;flag]];
    %ppm调制
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid);%z中频信号
    ppm_value = ppm*peakU;
    plane{i}.ppmseq = [plane{i}.ppmseq;ppm];
    plane{i}.seq_mid = [plane{i}.seq_mid;ppm_value]; 
    end
    
    %双天线场景
    if ann_num==2
    [loss,gain1,gain2,fd,dely_time] = parameter2(plane{i}.r,plane{i}.v,satellite.r,satellite.v,fc,c,measured_value,ann_width,satellite.ann1,satellite.ann2);%c 参数计算函数;   
    rec_power1 = plane_para(6,i)+gain1-loss;%接收功率
    rec_power2 = plane_para(6,i)+gain2-loss;%接收功率
    plane{i}.power = [plane{i}.power,[rec_power1;rec_power2]];
    peakU1 = 10^6*sqrt(2* 10^(rec_power1/10)/10^3);
    peakU2 = 10^6*sqrt(2* 10^(rec_power2/10)/10^3);
    rec_time = clock*simu_step+dely_time;
    
    
    plane{i}.LOSS = [plane{i}.LOSS,loss];
    plane{i}.shift_f = [plane{i}.shift_f,fd];    
    plane{i}.ant_gain = [plane{i}.ant_gain,[gain1;gain2]];
    plane{i}.mess_all = [plane{i}.mess_all;rec_time,plane_para(6,i),loss,gain1,gain2,rec_power1,rec_power2,fd,mess(1,2:8)];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time = [plane{i}.rec_time,[clock*simu_step;rec_time;i;flag]];

  
    
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
    
    
   
       %开始进行位置信息编码，最重要的是经纬度编码和高度编码
       
        
end
time_rec_all = [time_rec_all , plane{i}.rec_time];
end

% t = 0:1/fs*rs:120-1/fs*rs;
% plot(t,plane{1}.ppmseq(1,:),'r');
% xlabel('采样点');30
% ylabel('amplitude');
time_asix = zeros(4,length(time_rec_all));
[time_asix(2,:),index] = sort(time_rec_all(2,:)); 

for i = 1:length(time_rec_all)
    time_asix(1,i) = time_rec_all(1,index(i));
    time_asix(3,i) = time_rec_all(3,index(i));
    time_asix(4,i) = time_rec_all(4,index(i));
end

% mess_rec_all = [];
% for i = 1:length(time_rec_all)
%     A = [time_asix(:,i);plane{time_asix(3,i)}.mess_all(time_asix(4,i),2:14)'];
%      mess_rec_all = [mess_rec_all,A];
% end
if ann_num==1
   mess_rec_all = [];
     for i = 1:length(time_rec_all)
          A = [time_asix(:,i);plane{time_asix(3,i)}.power(time_asix(4,i));plane{time_asix(3,i)}.seq_mid(time_asix(4,i),:)'];
          mess_rec_all = [mess_rec_all,A];
     end
end
if ann_num==2
      mess_rec_all1 = [];
     for i = 1:length(time_rec_all)
         A = [time_asix(:,i);plane{time_asix(3,i)}.power(1,time_asix(4,i));plane{time_asix(3,i)}.seq_mid1(time_asix(4,i),:)'];
          mess_rec_all1 = [mess_rec_all1,A];
     end  
     mess_rec_all2 = [];
     for i = 1:length(time_rec_all)
          A = [time_asix(:,i);plane{time_asix(3,i)}.power(2,time_asix(4,i));plane{time_asix(3,i)}.seq_mid2(time_asix(4,i),:)'];
          mess_rec_all2 = [mess_rec_all2,A];
     end  
 end

   
end


  
