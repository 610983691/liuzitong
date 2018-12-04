clear;
clc;
x1 = [];
y1 = [];
z1 = [];
for t = 0:0.005:1
x1 = [x1,20+800*cos(pi/6)*t/(6671)];
y1 = [y1 ,10+800*sin(pi/6)*t/(6671*cos(x1(1,round(t/0.005+1))))];
z1 = [z1,300];
end
plot3(x1,y1,z1),xlabel('纬度'),ylabel('经度'),zlabel('高度');
grid on;