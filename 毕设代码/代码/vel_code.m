function [code]  = vel_code(ns_v,ew_v,v,rate_v)
       if ( ns_v >= 1022*1.609/3600)||(ew_v >= 1022*1.609/3600)%超音速 类型2
          subtype = bitget(2,3:-1:1);
          if  ns_v>0
          v =round( v/1.852);%变成单位节
          N_v = v+1;
          vel_bin = bitget(N_v,10:-1:1);
       else
          subtype = bitget(1,3:-1:1);
          v = v/1.852;
          N_v = round(v/4+1);
          vel_bin = bitget(N_v,10:-1:1);
        end  %超音速为4，非超音速为3
          
       %航向角
        N_a = round(theta/0.3515625);
        bin_a = bitget(N_a,10:-1:1);
        
        %垂直速度编码,垂直率可以在main函数设置
        %垂直速度本代码中设置的单位是KM/S，但是编码规则中单位是feet/分钟


            bin_vertical = zeros(1,9);
  
end
                 