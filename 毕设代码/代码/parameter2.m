function [loss,gain1,gain2,fd,dely_time] = parameter2(r,v,r_s,v_s,fc,c,Y,unit_num,ann1,ann2,ann_power)
%单天线情形
%多普勒频移fd=f/c×v×cosθ
r_r = r_s-r;
r_v = v-v_s;
costheta = r_v'*r_r/(norm(r_v)*norm(r_r));
fd = fc*norm(r_v)*costheta/c;
%路径损耗
loss = 32.44 + 20*log10(fc+fd) + 20*log10(norm(r_r));
%机载天线增益
theta1 = acos(r'*r_r/(norm(r_r)*norm(r')));
a = round(theta1*10000/pi+1);
plane_gain = Y(1,a);
%星载天线增益
%首先选择卫星天线
f = 3e10;
lamda = (3e8)/f;
beta = 2*pi/lamda;
n = unit_num;
t = -pi:pi/10000:pi;
d = lamda/4;
W = beta.*d.*cos(t);
z1 = ((n/2).*W)-n/2*beta*d;
z2 = ((1/2).*W)-1/2*beta*d;
F1 = sin(z1)./(n.*sin(z2));
K1 = abs(F1);
theta2 = acos(-r_r'*ann1'/(norm(ann1')*norm(r_r')));
theta3 = acos(-r_r'*ann2'/(norm(ann2')*norm(r_r')));
if theta2>pi
    theta2 = 2*pi-theta2;
end
if theta3>pi
    theta3 = 2*pi-theta3;
end
b = round(theta2*10000/pi+10001);
c = round(theta3*10000/pi+10001);
satellite_gain1 = 10*log10(K1(1,b))+ann_power;
satellite_gain2 = 10*log10(K1(1,c))+ann_power;
gain1 = plane_gain+satellite_gain1;
gain2 = plane_gain+satellite_gain2;
dely_time = norm(r_r)/c;
end