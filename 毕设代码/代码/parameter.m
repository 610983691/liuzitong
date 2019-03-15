function [loss,gain,fd] = parameter(r,v,r_s,v_s,fc,c,Y)
%������Ƶ��fd=f/c��v��cos��
r_r = r-r_s;
r_v = v_s-v;
costheta = r_v'*r_r/(norm(r_v)*norm(r_r));
fd = fc*norm(r_v)*costheta/c;
%·�����
loss = 32.44 + 20*log10(fc+fd) + 20*log10(norm(r_r));
%��������
theta1 = acos(abs(r_s'*r_r/(norm(r_r)*norm(r_s'))));
theta2 = acos(abs(r'*r_r/(norm(r_r)*norm(r_s'))));
a = round(theta1*10000/pi+1);
b = round(theta2*10000/pi+1);
gain = Y(1,a)+Y(1,b);

end
