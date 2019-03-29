n = 2000;
R = 5;
t = 0:0.02:2*pi;
plot(R*cos(t),R*sin(t),'r');
axis square
hold on
r = R*sqrt(rand(1,n));
seta = 2*pi*rand(1,n);
x = r.*cos(seta);
y = r.*sin(seta);
plot(x,y,'*');