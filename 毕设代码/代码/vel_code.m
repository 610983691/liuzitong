function [code]  = vel_code(ns_v,ew_v,rate_v)
       ns_v = round(ns_v*3600/1.852);%����λKM/s���konts,����/Сʱ
       ew_v = round(ew_v*3600/1.852);
       if ( ns_v >= 1022)||(ew_v >= 1022)%������ ����2
          subtype = bitget(2,3:-1:1);
          if ew_v>0
              speed_sign_ew = 0;%����Ϊ0������Ϊ1
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
              speed_sign_ew = 0;%����Ϊ0������Ϊ1
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
       %�Դ�ֱ�ٶȽ��б���
       if rate_v<0
           rate = 1;
       else
           rate = 0;
       end
       %��ֱ�ٶ�ֱ�������������Ӣ��ÿ����
       rate_v_bin = bitget(round(abs(rate_v/64))+1,9:-1:1);
       code = [bitget(19,5:-1:1),subtype,0,0,0,0,0,speed_sign_ew,ew_v_bin,speed_sign_ns,ns_v_bin,0,rate,rate_v_bin,zeros(1,9),1];
end
                 