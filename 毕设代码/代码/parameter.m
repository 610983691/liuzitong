function [loss,gain,fd] = parameter(r,v,r_s,v_s,fc,c,Y)
%多普勒频移fd=f/c×v×cosθ
r_r = r-r_s;
r_v = v_s-v;
costheta = r_v'*r_r/(norm(r_v)*norm(r_r));
fd = fc*norm(r_v)*costheta/c;
%路径损耗
loss = 32.44 + 20*log10(fc+fd) + 20*log10(norm(r_r));
%天线增益
theta1 = acos(abs(r_s'*r_r/(norm(r_r)*norm(r_s))));
theta2 = acos(abs(r'*r_r/(norm(r_r)*norm(r_s))));
gain = Y(round(roundn(theta1/pi,-4)*10000+1))+Y(round(roundn(theta2/pi,-4)*10000+1));
end
