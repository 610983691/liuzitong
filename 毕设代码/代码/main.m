% clear all;
% clc;

simu_time =5;% ��λs
simu_step =1e-3;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 500*10^6;
fc_mid = 40*10^6; %��Ƶ�ز�Ƶ��40MHz
fc = 1090;%����Ƶ��1090MHz  


%���ǵĲ�������
lon_s = 20;
lat_s = 30;
high_s = 700;
velocity_s = 7.4;
path_s = pi*20/180;
satellite_lon = zeros(1,simu_time/simu_step);
satellite_lat = zeros(1,simu_time/simu_step);
satellite_high = zeros(1,simu_time/simu_step);


%���÷ɻ��Ĳ���
N = 30;%�ɻ�����

%�������й����зɻ���������γ�ȡ��߶ȡ����ʡ��ٶȡ����ٶ�
plane_lon = zeros(N,simu_time/simu_step);
plane_lat = zeros(N,simu_time/simu_step);
plane_high = zeros(N,simu_time/simu_step);
velocity = zeros(N,simu_time/simu_step);

tran_power = [250,500,1000];  %�ɻ��ķ��书�ʿ�����250,500,1000W 

%��ʼ���ݸ�ֵ,��γ�ߡ��ٶȡ�����ǡ����ǡ����ٶȡ���ID������
high = zeros(1,N);       % �߶�
lon = zeros(1,N);        % ����
lat = zeros(1,N);        % γ��
plane_power = zeros(1,N);%����
plane_v = zeros(1,N);    %�ɻ���ʼ�ٶ�
acc_v = zeros(1,N);      %�ɻ����ٶ�
elevation = zeros(1,N);  %�ɻ�����
pathangle = zeros(1,N);  %�ɻ������


for i = 1:N
    high(i) = 8.4;
    lon(i) =  randi([10,30]);
    lat(i) = randi([20,40]);
    sele_power = randi(3);
    plane_power(i) = tran_power(sele_power) ;
    plane_v(i) = randi([1,10])*80;
    acc_v(i) = 0;% randi([-5,5]);
    if acc_v(i) == 0
        elevation(i) = 0;
    else
       elevation(i) = -pi/10;%randi([1,90])*pi/180;
    end
    pathangle(i) = randi([0,360])*pi/180; %130*pi/180;%  
end



time_rec_all = [];

%��һ����������ʾ�ɻ���ͬ��Ϣ�Ľ���ʱ���Լ�Я������Ϣ����
%mess_all = [];
%mecode_all = [];
%time_rec = [];
%����·����ġ�������Ƶ�ơ����������
%LOSS = [];
%shift_f = [];
%ant_gain = [];
%ppmseq = [];


%��Ϣ�Ĳ�ͬ��Ҫ������ME�ֶεĲ�ͬ����ME�ֶ�ǰ��ı�������ڳ���ǰ��ֱ��д��
code_heading = [1 0 0 0 1,zeros(1,27)]; %DF CA AA
mecode = zeros(1,56);



%��������
theta = [0:pi/180:pi/2];
value = xlsread('��������ʵ��ֵ.xls','M:M')';
X =0:pi/10000:pi/2;
measured_value = spline(theta,value,X);



%�ɻ���
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,lon(i),lat(i),high(i),plane_v(i),acc_v(i),pathangle(i),elevation(i),ceil(rand(1)*10),{'A','B','1','4','7','2','3','9'} );
%����ʱ�������沽�������ȣ�γ�ȣ��߶ȣ��ٶȣ����ٶȣ�����ǣ�����
end
%������
satellite = PLANET(simu_time,simu_step,lon_s,lat_s,high_s,velocity_s,path_s);%���ǵľ�γ�ߡ��ٶȡ�����ǡ�


for i = 1:N
    clock = 0;
    flag = 0;%��¼���ĸ���
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

    %�������
    if plane{i}.broad_times(1,clock) ~= 0
    
    if norm(plane{i}.r-satellite.r)<=3074 
    flag = flag+1;%������������
    
    %�������
    [mecode,mess] = messcode(clock,plane{i}.broad_times,plane{i}.longitude,plane{i}.latitude,plane{i}.hight,plane{i}.cpr_f,...
    plane{i}.velocity,plane{i}.ele_angle,plane{i}.path_angle,type_code,v_rate,plane{i}.ID);
    
    %������������
    [loss,gain,fd] = parameter(plane{i}.r,plane{i}.v,satellite.r,satellite.v,fc,c,measured_value);%c �������㺯��
    plane{i}.LOSS = [plane{i}.LOSS,loss];
    plane{i}.shift_f = [plane{i}.shift_f,fd];
    plane{i}.ant_gain = [plane{i}.ant_gain,gain];
    rec_power = 10*log10(plane_power(1,1)*1000)+gain-loss;%���չ���
    plane{i}.power = [plane{i}.power,10^(rec_power/10)/10^3];%w
    peakU = 10^6*sqrt(2* 10^(rec_power/10)/10^3);
    
    dely_time = norm(plane{i}.r-satellite.r)*1000/c;
    rec_time = clock*simu_step+dely_time;
    
    %��Ϣ����ͬһ������
    plane{i}.mess_all = [plane{i}.mess_all;rec_time,mess];
    plane{i}.mecode_all = [plane{i}.mecode_all;mecode]; 
    plane{i}.rec_time = [plane{i}.rec_time,[rec_time;i;flag]];
    
     mess112 = [[code_heading,mecode],zeros(1,24)];
    %ppm����
    ppm = ppmencode(mess112,rs,fs,fd,fc_mid,HDDD);
%     mid_single = shiftup(ppm,fs,rs,fd,fc_mid);
    ppm_value = ppm*peakU;

    plane{i}.ppmseq = [plane{i}.ppmseq;ppm];
    plane{i}.seq_mid = [plane{i}.seq_mid;ppm_value];

    end
    end
    
    
   
       %��ʼ����λ����Ϣ���룬����Ҫ���Ǿ�γ�ȱ���͸߶ȱ���
       
        
end
time_rec_all = [time_rec_all , plane{i}.rec_time];
end

time_asix = zeros(3,length(time_rec_all));
[time_asix(1,:),index] = sort(time_rec_all(1,:)); 
num_all = zeros(1,10);
num(1,1) = 1;
for i = 1:length(time_rec_all)
    time_asix(2,i) = time_rec_all(2,index(i));
    time_asix(3,i) = time_rec_all(3,index(i));
 
end
    

for i = 2:10
%     if( time_asix(1,i)-time_asix(1,i-1))>=120/10^6    %bbu��֯
%        num_all(i) =num_all(i-1)+100000;%ÿ���źſ�ʼ�Ĳ����� 
%     else%��֯
        diff_num = ceil((time_asix(1,i)-time_asix(1,i-1))*10^6*fs/rs);
        num_all(i) = num_all(i-1)+diff_num;
    end


rec_mess = zeros(1,num_all(10)+60000);%���еĲ�����
for i = 1:10
   rec_mess(1,(num_all(i)+1):(num_all(i)+1)+59999) = ...
       rec_mess(1,(num_all(i)+1):(num_all(i)+1)+59999)+plane{time_asix(2,i)}.seq_mid(time_asix(3,i),:);
end

t = 0:1/fs*rs:(num_all(10)+59999)/500;
plot(t,rec_mess)



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

% %���2�ؽ�֯
% [time_asix,index] = sort(time_rec_all(1,:)); 
% interwave = zeros(1,length(time_asix));  %��֯����
% flag1 = 0;
% % ��֯2�ؼ�����
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
% % inter_index = max(interwave);%������֯��
% % image_inter = zeros(1,inter_index);
% % for i = 1:length(interwave)     %1-���֯��
% %     if interwave(i)~=0
% %     image_inter(interwave(i)) =image_inter(interwave(i))+1;
% %     end
% % end
%    
% %������֯ͼ��
% % for i = 1:length(interwave)
% %     if interwave(i)==2
% %         flag1 = i;
% %         break
% %     end
% % end
% % if (i ==0)||(interwave(flag1-1)==0)
% if flag1~=0
% num_plane1 = time_rec_all(2,index(flag1));%�ڣ����ɻ�
% num_meg1 = time_rec_all(3,index(flag1));%�ڣ�������
% num_plane2 = time_rec_all(2,index(flag1+1));%�ڣ����ɻ�
% num_meg2 = time_rec_all(3,index(flag1+1));%�ڣ�������
% % num_plane3 = time_rec_all(2,index(flag1+2));%�ڣ����ɻ�
% % num_meg3 = time_rec_all(3,index(flag1+2));%�ڣ�������
% time_diff1 = time_asix(1,flag1+1)-time_asix(1,flag1);
% % time_diff2 = time_asix(1,flag1+2)-time_asix(1,flag1);
% 
% % else
% % num_plane1 = time_rec_all(2,index(flag1));%�ڣ����ɻ�
% % num_meg1 = time_rec_all(3,index(flag1));%�ڣ�������
% % num_plane2 = time_rec_all(2,index(flag1+1));%�ڣ����ɻ�
% % num_meg2 = time_rec_all(3,index(flag1+1));%�ڣ�������    
% % num_plane3 = time_rec_all(2,index(flag1-1));%�ڣ����ɻ�
% % num_meg3 = time_rec_all(3,index(flag1-1));%�ڣ�������
% % time_diff1 = time_asix(1,i)-time_asix(1,flag1-1);
% % time_diff2 = time_asix(1,i+1)-time_asix(1,flag1-1);
% % end
% 
% time_sim1 = ceil(time_diff1*10^6/(1*rs/fs));%���Ĳ��������
% % time_sim2 = ceil(time_diff2*10^6/(1*rs/fs));%���Ĳ��������
% 
% inter_msg1 = [plane{num_plane1}.seq_mid(num_meg1,:),zeros(1,time_sim1)];
% inter_msg2 = [zeros(1,time_sim1),plane{num_plane2}.seq_mid(num_meg2,:)];%,zeros(1,time_sim2-time_sim1)];
% % inter_msg3 = [zeros(1,time_sim2),plane{num_plane2}.seq_mid(num_meg2,:)];
% 
% inter_wave = inter_msg1+inter_msg2;%+inter_msg3;
% 
% 
% 
% 
% t = 0:1/fs*rs:120+(time_sim1-1)/fs*rs;
% plot(t,inter_msg1,'r');
% hold on
% plot(t,inter_msg2,'g');
% % hold on
% % plot(t,inter_msg3,'y');
% hold on
% plot(t,inter_wave);
% end

      



  
