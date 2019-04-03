theta = [0:pi/180:pi/2];
value = xlsread('天线增益实测值.xls','M:M')';
X =0:pi/100000:pi/2;
measured_value = spline(theta,value,X);
A = max(measured_value);
power = zeros(1,50001);
power1 = zeros(1,50001);
for i = 1:50001
    power(i) = 10^((measured_value(i)-A)/10);
end
for i = 1:50001
    power1(i) = power(50002-i);
end
% value2 = [measured_value,measured_value,measured_value,measured_value];
polar(X,power);
% hold on;

% Y =pi/2:pi/100000:pi;
% polar(Y,power1);
% hold on;
% T =pi:pi/100000:3*pi/2;
% polar(T,power);
% hold on;
% 
% H =3*pi/2:pi/100000:2*pi;
% polar(H,power1);
% hold on;