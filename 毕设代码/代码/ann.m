% % clear all
% % lam = 1000;
% % k = 2*pi./lam;
% % L= lam/4;
% % theta = 0:pi/100:2*pi;
% % f1 = 1./(1-cos(k*L));
% % f2 = (cos(k*L*cos(theta))-cos(k*L))./sin(theta);
% % rho = f1*f2;
% % polar(theta,abs(rho),'b');
% clear all;
% sita = -pi:0.01:pi;
% lamba = 0.03;%波长
% d = lamba/4;%天线间隔
% n0 = 2;%天线单元阵数量
% beta =2*pi*d*sin(sita)/lamba;
% z10 = (n0/2)*beta;
% z20 =(1/2)*beta;
% f1 = sin(z10)./(n0*sin(z20));
% F1= abs(f1);
% figure(1);
% polar(sita,F1,'y');
% % hold on;
% % n5 = 4;%天线单元阵数量
% % beta =2*pi*d*sin(sita)/lamba;
% % z15 = (n5/2)*beta;
% % z25 =(1/2)*beta;
% % f1 = sin(z15)./(n5*sin(z25));
% % F1= abs(f1);
% % plot(sita,F1,'g');
% % hold on;
% % n2 = 8;%天线单元阵数量
% % beta =2*pi*d*sin(sita)/lamba;
% % z12 = (n2/2)*beta;
% % z22 =(1/2)*beta;
% % f1 = sin(z12)./(n2*sin(z22));
% % F1= abs(f1);
% % plot(sita,F1,'r');
% % hold on;
% % 
% % n2 = 10;%天线单元阵数量
% % beta =2*pi*d*sin(sita)/lamba;
% % z12 = (n2/2)*beta;
% % z22 =(1/2)*beta;
% % f1 = sin(z12)./(n2*sin(z22));
% % F1= abs(f1);
% % plot(sita,F1,'r');
% % hold on;
% % n3 = 20;%天线单元阵数量
% % beta =2*pi*d*sin(sita)/lamba;
% % z13 = (n3/2)*beta;
% % z23 =(1/2)*beta;
% % f1 = sin(z13)./(n3*sin(z23));
% % F1= abs(f1);
% % plot(sita,F1,'k');
% % hold off;
% % grid on;
% % xlabel('theta/radian');
% % ylabel('amplitude');
% % legend('n = 2','n=4','n = 8','n = 10','n=20');
clear all;
clc;
f = 3e10;
lamda = (3e8)/f;
beta = 2*pi/lamda;
n = 20;
t = 0:pi/10000:2*pi-pi/10000;
d = lamda/4;
W = beta.*d.*cos(t);
z1 = ((n/2).*W)-n/2*beta*d;
z2 = ((1/2).*W)-1/2*beta*d;
F1 = sin(z1)./(n.*sin(z2));
K1 = abs(F1);
t1= 15*pi/180:pi/10000:2*pi-pi/10000+15*pi/180;
polar(t1,K1,'r');
hold on
t2= -15*pi/180:pi/10000:2*pi-pi/10000-15*pi/180;
polar(t2,K1,'r');
% hold on;
% n =30;
% t = -pi:0.01:pi;
% d = lamda/4;
% W = beta.*d.*cos(t);
% z1 = ((n/2).*W)-n/2*beta*d;
% z2 = ((1/2).*W)-1/2*beta*d;
% F1 = sin(z1)./(n.*sin(z2));
% K1 = abs(F1);
% polar(t,K1,'r');
% hold on;
% n = 35;
% t = -pi:0.01:pi;
% d = lamda/4;
% W = beta.*d.*cos(t);
% z1 = ((n/2).*W)-n/2*beta*d;
% z2 = ((1/2).*W)-1/2*beta*d;
% F1 = sin(z1)./(n.*sin(z2));
% K1 = abs(F1);
% polar(t,K1,'g');
% hold on;
% n = 40;
% t = -pi:0.01:pi;
% d = lamda/4;
% W = beta.*d.*cos(t);
% z1 = ((n/2).*W)-n/2*beta*d;
% z2 = ((1/2).*W)-1/2*beta*d;
% F1 = sin(z1)./(n.*sin(z2));
% K1 = abs(F1);
% polar(t,K1,'b');
% hold on;
% xlabel('theta/radian');
% ylabel('amplitude');

