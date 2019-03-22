% clear all;
% clc;

simu_time =10;% 单位s
simu_step =1e-3;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 500*10^6;
fc_mid = 40*10^6; %中频载波频率40MHz
fc = 1090;%发射频率1090MHz  


%卫星的参数设置
lon_s = 20;
lat_s = 30;
high_s = 700;
velocity_s = 7.4;
path_s = pi*45/180;
ann_num = 2;%选择天线的个数
unit_num = 10;%选择天线的波束宽带
satellite_power = 10;%(db)
satellite_lon = zeros(1,simu_time/simu_step);
satellite_lat = zeros(1,simu_time/simu_step);
satellite_high = zeros(1,simu_time/simu_step);


%设置飞机的参数
N = 10;%飞机数量

%整个运行过程中飞机参数：经纬度、高度、功率、速度、加速度
plane_lon = zeros(N,simu_time/simu_step);
plane_lat = zeros(N,simu_time/simu_step);
plane_high = zeros(N,simu_time/simu_step);
velocity = zeros(N,simu_time/simu_step);

tran_power = [250,500,1000];  %飞机的发射功率可能是250,500,1000W 
high_sle = [8.4,8.7,9,9.3,9.6,9.9];

%初始数据赋值,经纬高、速度、航向角、仰角、加速度、和ID、功率
high = zeros(1,N);       % 高度
lon = zeros(1,N);        % 经度
lat = zeros(1,N);        % 纬度
plane_power = zeros(1,N);%功率
plane_v = zeros(1,N);    %飞机初始速度
acc_v = zeros(1,N);      %飞机加速度
elevation = zeros(1,N);  %飞机仰角
pathangle = zeros(1,N);  %飞机航向角


for i = 1:N
    lon(i) =  randi([0,40]);
    lat(i) = randi([10,50]);
    sele_high = randi(6);
    high(i) = high_sle(sele_high);
    sele_power = randi(3);
    plane_power(i) = tran_power(sele_power) ;
    plane_v(i) = 2.5;%km/s
    acc_v(i) = 0;% randi([-5,5]);
    elevation(i) = 0;    
    pathangle(i) = randi([0,360])*pi/180; %130*pi/180;% 
end




time_rec_all = [];


%信息的不同主要体现在ME字段的不同所以ME字段前面的编码可以在程序前就直接写好
code_heading = [1 0 0 0 1,zeros(1,27)]; %DF CA AA
mecode = zeros(1,56);


%天线增益
theta = 0:pi/180:pi/2;
value = xlsread('天线增益实测值.xls','M:M')';
X =0:pi/10000:pi/2;
measured_value = spline(theta,value,X);



%飞机类
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,lon(i),lat(i),high(i),plane_v(i),acc_v(i),pathangle(i),elevation(i),ceil(rand(1)*10),{'A','B','1','4','7','2','3','9'} );
%仿真时长，仿真步进，经度，纬度，高度，速度，加速度，航向角，仰角
end
%卫星类
satellite = PLANET(simu_time,simu_step,lon_s,lat_s,high_s,velocity_s,path_s,ann_num);%卫星的经纬高、速度、航向角。


for i = 1:N
    clock = 0;
    flag = 0;%记录报文个数
    v_rate = randi(2)-1;
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
    if norm(plane{i}.r-satellite.r)<=3074 
    if plane{i}.broad_times(1,clock) ~= 0
    

    flag = flag+1;%报文数量增加
    
    %编码过程
    [mecode,mess] = messcode(clock,plane{i}.broad_times,plane{i}.longitude,plane{i}.latitude,plane{i}.hight,plane{i}.cpr_f,...
    plane{i}.velocity,plane{i}.ele_angle,plane{i}.path_angle,type_code,v_rate,plane{i}.ID,i);
    
    %加上损耗增益等
    
    %单天线场景
    if ann_num==1
    [loss,gain,fd,dely_time] = parameter1(plane{i}.r,plane{i}.v,satellite.r,satellite.v,fc,c,measured_value,unit_num);%c 参数计算函数;
    rec_power = 10*log10(plane_power(1,1)*1000)+gain-loss;%接收功率
    plane{i}.power = [plane{i}.power,rec_power];%w
    peakU = 10^6*sqrt(2* 10^(rec_power/10)/10^3);
    rec_time = clock*simu_step+dely_time;
    %信息放在同一个矩阵
    plane{i}.LOSS = [plane{i}.LOSS,loss];
    plane{i}.shift_f = [plane{i}.shift_f,fd];
    plane{i}.ant_gain = [plane{i}.ant_gain,gain];
    plane{i}.mess_all = [plane{i}.mess_all;rec_time,plane_power(i),loss,gain,rec_power,fd,mess(1,2:9)];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time = [plane{i}.rec_time,[clock*simu_step;rec_time;i;flag]];
    mess112 = [[code_heading,mecode],zeros(1,24)];
    %ppm调制
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid,L1,D1);%z中频信号
    ppm_value = ppm*peakU;
    plane{i}.ppmseq = [plane{i}.ppmseq;ppm];
    plane{i}.seq_mid = [plane{i}.seq_mid;ppm_value]; 
    end
    
    %双天线场景
    if ann_num==2
    [loss,gain1,gain2,fd,dely_time] = parameter2(plane{i}.r,plane{i}.v,satellite.r,satellite.v,fc,c,measured_value,unit_num,satellite.ann1,satellite.ann2);%c 参数计算函数;   
    rec_power1 = 10*log10(plane_power(1,1)*1000)+gain1-loss;%接收功率
    rec_power2 = 10*log10(plane_power(1,1)*1000)+gain2-loss;%接收功率
    plane{i}.power = [plane{i}.power,[rec_power1;rec_power2]];
    peakU1 = 10^6*sqrt(2* 10^(rec_power1/10)/10^3);
    peakU2 = 10^6*sqrt(2* 10^(rec_power2/10)/10^3);
    rec_time = clock*simu_step+dely_time;
    
    
    plane{i}.LOSS = [plane{i}.LOSS,loss];
    plane{i}.shift_f = [plane{i}.shift_f,fd];    
    plane{i}.ant_gain = [plane{i}.ant_gain,[gain1;gain2]];
    plane{i}.mess_all = [plane{i}.mess_all;rec_time,plane_power(i),loss,gain1,gain2,rec_power1,rec_power2,fd,mess(1,2:9)];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time = [plane{i}.rec_time,[clock*simu_step;rec_time;i;flag]];
    mess112 = crcencode(code_heading,mecode);
  
    
    %ppm调制
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid,L1,D1);%z中频信号
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
% xlabel('采样点');
% ylabel('amplitude');
% 
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

% num_all = zeros(1,5);%20-24
% num_all(1,1) = 1;%flag-2~1 ,第一个采样点
% 
% for i =2:5
% %         if flag1==0
% %             break;
% %         else
%            if( time_asix(1,i+19)-time_asix(1,i+18))<120/10^6    %交织
%               diff_num = ceil((time_asix(2,i+19)-time_asix(2,i+19-1))*10^6*fs/rs);  
%                num_all(i) = num_all(i-1)+diff_num;
%            else%不交织
%                diff_num = ceil(((time_asix(2,i+19)-time_asix(2,i+19-1))*10^6-120)/100*fs/rs);  %将间隔时间缩小100倍。
%                num_all(i) = num_all(i-1)+diff_num+59999;
%            end
% end
% %      
% % % end
% % 
% rec_mess = zeros(1,num_all(5)+59999);%所有的采样点
% for i = 1:5
%    rec_mess(1,num_all(i):(num_all(i)+59999)) =  rec_mess(1,num_all(i):num_all(i)+59999)+plane{time_asix(3,i+19)}.seq_mid(time_asix(4,i+19),:);
%       
% end
% 
% t = 0:1/fs*rs:120+(num_all(5)-2)/fs*rs;
% plot(t,rec_mess)
% 
% % flag1 = 0; 
% interwave = zeros(1,length(time_rec_all));
% for i = 1:length(time_asix)-2
%     j = i+1;
%        while (time_asix(1,j)-time_asix(1,i)<120/10^6)&&(j+1<=length(time_asix));%&&((time_asix(1,j+1)-time_asix(1,i))<=120/10^6); %二重交织
% % %            flag1 = i;
% %            break
%             interwave(1,i) = interwave(1,i)+1;
% %             interwave(1,i+1) = interwave(1,j+1)+1;
%             interwave(1,j) = interwave(1,j)+1;
%             j = j+1;
%        end 
% end    
% 



% a = plane{1}.ppmseq(1,:);
% b = plane{1}.ppmseq(10,:);
% t = 0:1/fs*rs:120-1/fs*rs;
% plot(t,a+b,'r');


% a = plane{1}.seq_mid(1,:);
% b = plane{1}.seq_mid(flag,:);
% t = 0:1/fs*rs:120-1/fs*rs;
% plot(t,a,'r');
% hold on
% plot(t,b,'g')

% filter_ppm = filter(HHd,1,a);
% t = 0:1/fs*rs:120-1/fs*rs;
% plot(t,a,'r');
% hold on
% plot(t,filter_ppm);
% hold on
% plot(t,b,'g')

% 
%  a = plane{1}.mecode_all(1,:);

% %检测2重交织
% [time_asix,index] = sort(time_rec_all(1,:)); 
% interwave = zeros(1,length(time_asix));  %交织矩阵
% flag1 = 0;
% % 交织2重检测过程
% for i = 1:length(time_asix)-1
%     j = i+1;
%        while (time_asix(1,j)-time_asix(1,i)<120/10^6)&&(j+1<=length(time_asix));%&&(time_asix(1,j+1)-time_asix(1,i)>=120/10^6
%            flag1 = i;
%            break
% %             interwave(1,i) = interwave(1,i)+1;
% %             interwave(1,i+1) = interwave(1,j+1)+1;
% %             interwave(1,j) = interwave(1,j)+1;
% %             j = j+1;
%        end 
% end
% 
%  
% % inter_index = max(interwave);%求出最大交织数
% % image_inter = zeros(1,inter_index);
% % for i = 1:length(interwave)     %1-最大交织数
% %     if interwave(i)~=0
% %     image_inter(interwave(i)) =image_inter(interwave(i))+1;
% %     end
% % end
%    
%画出交织图形
% for i = 1:length(interwave)
%     if interwave(i)==2
%         flag1 = i;
%         break
%     end
% end
% if (i ==0)||(interwave(flag1-1)==0)
% if flag1~=0
% num_plane1 = time_rec_all(2,index(flag1));%第？个飞机
% num_meg1 = time_rec_all(3,index(flag1));%第？个报文
% num_plane2 = time_rec_all(2,index(flag1+1));%第？个飞机
% num_meg2 = time_rec_all(3,index(flag1+1));%第？个报文
% num_plane3 = time_rec_all(2,index(flag1+2));%第？个飞机
% num_meg3 = time_rec_all(3,index(flag1+2));%第？个报文
% time_diff1 = time_asix(1,flag1+1)-time_asix(1,flag1);
% time_diff2 = time_asix(1,flag1+2)-time_asix(1,flag1);

% else
% num_plane1 = time_rec_all(2,index(flag1));%第？个飞机
% num_meg1 = time_rec_all(3,index(flag1));%第？个报文
% num_plane2 = time_rec_all(2,index(flag1+1));%第？个飞机
% num_meg2 = time_rec_all(3,index(flag1+1));%第？个报文    
% num_plane3 = time_rec_all(2,index(flag1-1));%第？个飞机
% num_meg3 = time_rec_all(3,index(flag1-1));%第？个报文
% time_diff1 = time_asix(1,i)-time_asix(1,flag1-1);
% time_diff2 = time_asix(1,i+1)-time_asix(1,flag1-1);
% end

% time_sim1 = ceil(time_diff1*10^6/(1*rs/fs));%相差的采样点个数
% time_sim2 = ceil(time_diff2*10^6/(1*rs/fs));%相差的采样点个数
% 
% inter_msg1 = [plane{num_plane1}.seq_mid(num_meg1,:),zeros(1,time_sim2)];
% inter_msg2 = [zeros(1,time_sim1),plane{num_plane2}.seq_mid(num_meg2,:),zeros(1,time_sim2-time_sim1)];
% inter_msg3 = [zeros(1,time_sim2),plane{num_plane2}.seq_mid(num_meg2,:)];
% 
% inter_wave = inter_msg1+inter_msg2+inter_msg3;
% 
% 
% 
% 
% t = 0:1/fs*rs:120+(time_sim2-1)/fs*rs;
% plot(t,inter_msg1,'r');
% hold on
% plot(t,inter_msg2,'g');
% hold on
% plot(t,inter_msg3,'y');
% hold on
% plot(t,inter_wave);
% xlabel('采样点');
% ylabel('amplitude');
% end

      



  
