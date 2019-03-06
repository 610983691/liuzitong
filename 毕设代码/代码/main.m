clear;
clc;

simu_time =100;% ��λs
simu_step =1e-3;%s
ratio = 6371;%KM
c = 3e+5;%km/s
rs = 1*10^6;
fs = 500*10^6;
fc_mid = 40*10^6; %��Ƶ�ز�Ƶ��40MHz
fc = 1090;%����Ƶ��1090MHz  

%���÷ɻ��Ĳ���
N = 10;%�ɻ�����

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
    high(i) = 8400;
    lon(i) = randi([0,40]);
    lat(i) = randi([0,40]);
    sele_power = randi(3);
    plane_power(i) = tran_power(sele_power) ;
    plane_v(i) = 800 + randi([-10,10])*20;
    acc_v(i) = randi([-5,5]);
    if acc_v(i) == 0
        elevation(i) = 0;
    else
       elevation(i) = randi([1,90])*pi/180;
    end
    pathangle(i) = randi([0,360])*pi/180; 
end



%���ǵĲ�������
satellite_lon = zeros(1,simu_time/simu_step);
satellite_lat = zeros(1,simu_time/simu_step);
satellite_high = zeros(1,simu_time/simu_step);


%��һ����������ʾ�ɻ���ͬ��Ϣ�Ľ���ʱ���Լ�Я������Ϣ����
mess_all = [];
mecode_all = [];
time_rec = [];
type = randi(4);                         %�ڷɻ�ID�����е��豸���� D C B Aѡ�����ѡ��
type_code(1,:) = bitget(type,5:-1:1);
v_rate = randi(2)-1;

%��Ϣ�Ĳ�ͬ��Ҫ������ME�ֶεĲ�ͬ����ME�ֶ�ǰ��ı�������ڳ���ǰ��ֱ��д��
code_heading = [1 0 0 0 1,zeros(1,27)]; %DF CA AA
mecode = zeros(1,56);

%����·����ġ�������Ƶ�ơ����������
LOSS = [];
shift_f = [];
ant_gain = [];

%��������
theta = [0:pi/180:pi/2];
value = xlsread('��������ʵ��ֵ.xls','M:M')';
X =0:pi/10000:pi/2;
measured_value = spline(theta,value,X);

ppmseq = [];

%�ɻ���
for i = 1:N
plane{i} = AIRCRAFT(simu_time,simu_step,lon(i),lat(i),high(i),plane_v(i),acc_v(i),pathangle(i),elevation(i),ceil(rand(1)*10),{'A','B','1','4','7','2','3','9'} );
%����ʱ�������沽�������ȣ�γ�ȣ��߶ȣ��ٶȣ����ٶȣ�����ǣ�����
%������
satellite = PLANET(simu_time,simu_step,20,25,700,0,40);%���ǵľ�γ�ߡ��ٶȡ�����ǡ�
clock = 0;
while(clock<(simu_time/simu_step))  
    plane = ChangePosition(plane,ratio);
    plane = BroadCast(plane,clock); 
    satellite = ChangePositionS(satellite,ratio);
    clock = clock + 1;
    
    plane_lon(1,clock) = plane.longitude;
    plane_lat(1,clock) = plane.latitude;
    plane_high(1,clock) = plane.hight;
    
    satellite_lon(1,clock) = satellite.longitude;
    satellite_lat(1,clock) = satellite.latitude;
    satellite_high(1,clock) = satellite.hight;
    
    %�������
    if plane.broad_times(1,clock) ~= 0
    %�������
    [mecode,mess] = messcode(clock,plane.broad_times,plane.longitude,plane.latitude,plane.hight,plane.cpr_f,...
    plane.velocity,plane.ele_angle,plane.path_angle,type_code,v_rate,plane.ID);
    
    %������������
    [loss,gain,fd] = parameter(plane.r,plane.v,satellite.r,satellite.v,fc,c,measured_value);%c �������㺯��
    LOSS = [LOSS,loss];
    shift_f = [shift_f,fd];
    ant_gain = [ant_gain,gain];
    rec_power = 10*log10(plane_power(1,1)*1000)+gain-loss; 
    

    %��Ϣ����ͬһ������
    mess_all = [mess_all;mess];
    mecode_all = [mecode_all;mecode];  
    
    mess112 = [[code_heading,mecode],zeros(1,24)];
    %ppm����
    ppm = ppmencode(mess112,rs,fs,fc_mid,fd);
    Amp = round(10^((rec_power+115)/20)*128);
    ppmseq = [ppmseq;Amp*ppm];
    
    
    end
    
   
       %��ʼ����λ����Ϣ���룬����Ҫ���Ǿ�γ�ȱ���͸߶ȱ���
       
        
end


t = 0:59999
y = Amp*ppm;
plot(t,y)
%plot3(plane_lat,plane_lon,plane_high),xlabel('γ��'),ylabel('����'),zlabel('�߶�');
%grid on;   
