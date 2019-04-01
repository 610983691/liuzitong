function [code]  = vel_code(ns_v,ew_v,rate_v)
       ns_v = round(ns_v*3600/1.852);%将单位KM/s变成konts,海里/小时
       ew_v = round(ew_v*3600/1.852);
       if ( ns_v >= 1022)||(ew_v >= 1022)%超音速 类型2
          subtype = bitget(2,3:-1:1);
          if ew_v>0
              speed_sign_ew = 0;%东向为0；西向为1
          else
              speed_sign_ew = 1;
          end
          if abs(ew_v)<=4084
              ew_v_bin = bitget(round(abs(ew_v/4))+1,10:-1:1);
          else
              ew_v_bin = ones(1,10);
          end
          if  ns_v>0
              speed_sign_ns = 1;
          else
              speed_sign_ns = 0;
          end
          if abs(ns_v)<=4084
              ns_v_bin = bitget(round(abs(ns_v/4))+1,10:-1:1);
          else
              ns_v_bin = ones(1,10);
          end
       else
          subtype = bitget(1,3:-1:1);
          if ew_v>0
              speed_sign_ew = 0;%东向为0；西向为1
          else
              speed_sign_ew = 1;
          end
          if abs(ew_v)<=1021
              ew_v_bin = bitget(abs(ew_v)+1,10:-1:1);
          else
              ew_v_bin = ones(1,10);
          end
          if  ns_v>0
              speed_sign_ns = 1;
          else
              speed_sign_ns = 0;
          end
          if abs(ns_v)<=1021
              ns_v_bin = bitget(abs(ns_v)+1,10:-1:1);
          else
              ns_v_bin = ones(1,10);
          end
          
       end
       %对垂直速度进行编码
       if rate_v<0
           rate = 1;
       else
           rate = 0;
       end
       %垂直速度直接输入参数就是英尺每分钟
       rate_v_bin = bitget(round(abs(rate_v/64))+1,9:-1:1);
       code = [bitget(19,5:-1:1),subtype,0,0,0,0,0,speed_sign_ew,ew_v_bin,speed_sign_ns,ns_v_bin,0,rate,rate_v_bin,zeros(1,9),1];
end
                 