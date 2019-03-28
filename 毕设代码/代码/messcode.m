function [code,mess] = messcode(clock,broad_times,longitude,latitude,hight,cpr_f,...
    velocity,path_angle,type_code,ID,i,rate_v)
    code=zeros(1,56);
    mess = zeros(1,8);
   if broad_times(1,clock) == 1
      mess = [clock,longitude,latitude, hight,0,0,0,0];
      [hig,lat,lon] = position_code(hight,cpr_f,latitude,longitude);
      code = [1,0,1,0,0,0,0,1,hig,1,cpr_f,lat,lon]; 
   else
       if broad_times(1,clock) == 2
          ns_v = velocity*cos(path_angle*pi/180);
          ew_v = velocity*sin(path_angle*pi/180);
          mess = [clock,0,0,0,ns_v,ew_v,velocity,0];
          [code] = vel_code(ns_v,ew_v,velocity,rate_v);
          code = [bitget(19,5:-1:1),subtype,0,0,0,0,1,1,bin_a,1,bin_v,0,0,bin_vertical,zeros(1,10)];
       else
           if broad_times(1,clock) == 3
              mess = [clock,0,0, 0,0,0,0,i];
              ID_bin = idcode(ID);
              code = [type_code,0,0,0,ID_bin];
           end
           
       end
   end
end
           
          