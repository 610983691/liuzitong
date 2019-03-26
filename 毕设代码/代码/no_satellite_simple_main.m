function [mess_rec_all,plane_lon,plane_lat,plane_high] =no_satellite_simple_main(plane_para,simu_time)


simu_step =1e-2;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 500*10^6;
fc_mid = 40*10^6; %中频载波频率40MHz
fc = 1090;%发射频率1090MHz  



N= size(plane_para,2);
plane_para1 = plane_para;
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




%飞机类
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,plane_para(1,i),plane_para(2,i),plane_para(3,i),plane_para(4,i),plane_para(5,i),ceil(rand(1)*10) );
%仿真时长，仿真步进，经度，纬度，高度，速度，加速度，航向角，仰角
end



for i = 1:N
    clock = 0;
    flag = 0;%记录报文个数
    type = randi(4);
    type_code(1,:) = bitget(type,5:-1:1); 
while(clock<(simu_time/simu_step))  
    plane{i} = ChangePosition(plane{i},ratio);
    plane{i} = BroadCast(plane{i},clock); 
    clock = clock + 1;
    
    plane_lon(i,clock) = plane{i}.longitude;
    plane_lat(i,clock) = plane{i}.latitude;
    plane_high(i,clock) = plane{i}.hight;
    

    %编码过程
    if plane{i}.broad_times(1,clock) ~= 0
    

    flag = flag+1;%报文数量增加
    
    %编码过程
    [mecode,mess] = messcode(clock,plane{i}.broad_times,plane{i}.longitude,plane{i}.latitude,plane{i}.hight,plane{i}.cpr_f,...
    plane{i}.velocity,plane{i}.path_angle,type_code,plane_ID1(i,:),i);
    mess112 = crcencode(code_heading(i,:),mecode);
    
    %加上损耗增益等
    
    peakU = 10^6*sqrt(2* 10^(plane_para(6,i)/10)/10^3);
    %信息放在同一个矩阵
    plane{i}.mess_all = [plane{i}.mess_all;plane_para(6,i),mess(1,2:8)];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time = [plane{i}.rec_time,[clock*simu_step;i;flag]];
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
time_asix = zeros(3,length(time_rec_all));%没有接收时间
[time_asix(1,:),index] = sort(time_rec_all(1,:));%根据发送时间排序 

for i = 1:length(time_rec_all)
    time_asix(2,i) = time_rec_all(2,index(i));
    time_asix(3,i) = time_rec_all(3,index(i));
end
  mess_rec_all = [];
  for i = 1:length(time_rec_all)
          A = [time_asix(:,i);plane_para(6,time_asix(2,i));plane{time_asix(2,i)}.seq_mid(time_asix(3,i),:)'];
          mess_rec_all = [mess_rec_all,A];
     end
end
