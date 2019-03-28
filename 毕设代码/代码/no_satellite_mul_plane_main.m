function [mess_rec_all,plane_lon,plane_lat,plane_high] =no_satellite_mul_plane_main(plane_para,simu_time,planes_id)


simu_step =1e-2;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 500*10^6;
fc_mid = 40*10^6; %��Ƶ�ز�Ƶ��40MHz
fc = 1090;%����Ƶ��1090MHz  



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



%��Ϣ�Ĳ�ͬ��Ҫ������ME�ֶεĲ�ͬ����ME�ֶ�ǰ��ı�������ڳ���ǰ��ֱ��д��



time_rec_all = [];




%�ɻ���
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,plane_para(1,i),plane_para(2,i),plane_para(3,i),plane_para(4,i),plane_para(5,i),ceil(rand(1)*10) );
%����ʱ�������沽�������ȣ�γ�ȣ��߶ȣ��ٶȣ����ٶȣ�����ǣ�����
end



for i = 1:N
    clock = 0;
    flag = 0;%��¼���ĸ���
    type = randi(4);
    type_code(1,:) = bitget(type,5:-1:1); 
while(clock<(simu_time/simu_step))  
    plane{i} = ChangePosition(plane{i},ratio);
    plane{i} = BroadCast(plane{i},clock); 
    clock = clock + 1;
    
    plane_lon(i,clock) = plane{i}.longitude;
    plane_lat(i,clock) = plane{i}.latitude;
    plane_high(i,clock) = plane{i}.hight;
    

    %�������
    if plane{i}.broad_times(1,clock) ~= 0
    

    flag = flag+1;%������������
    
    %�������
    [mecode,mess] = messcode(clock,plane{i}.broad_times,plane{i}.longitude,plane{i}.latitude,plane{i}.hight,plane{i}.cpr_f,...
    plane{i}.velocity,plane{i}.path_angle,type_code,plane_ID_double(i,:),i,plane_para(7,i));%���һ���Ƿɻ��Ĵ�ֱ�ٶ�
    mess112 = crcencode(code_heading(i,:),mecode);
    
    %������������
    
    peakU = 10^6*sqrt(2* 10^(plane_para(6,i)/10)/10^3);
    %��Ϣ����ͬһ������
    plane{i}.mess_all = [plane{i}.mess_all;plane_para(6,i),mess(1,2:8)];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time = [plane{i}.rec_time,[clock*simu_step;i;flag]];
    %ppm����
    fd = 0;
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid);%z��Ƶ�ź�
    ppm_value = ppm*peakU;
    plane{i}.ppmseq = [plane{i}.ppmseq;ppm];
    plane{i}.seq_mid = [plane{i}.seq_mid;ppm_value]; 
    end
end
time_rec_all = [time_rec_all , plane{i}.rec_time];
end
time_asix = zeros(3,length(time_rec_all));%û�н���ʱ��
[time_asix(1,:),index] = sort(time_rec_all(1,:));%���ݷ���ʱ������ 

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
