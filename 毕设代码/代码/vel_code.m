function [code]  = vel_code(ns_v,ew_v,v,rate_v)
       if ( ns_v >= 1022*1.609/3600)||(ew_v >= 1022*1.609/3600)%������ ����2
          subtype = bitget(2,3:-1:1);
          if  ns_v>0
          v =round( v/1.852);%��ɵ�λ��
          N_v = v+1;
          vel_bin = bitget(N_v,10:-1:1);
       else
          subtype = bitget(1,3:-1:1);
          v = v/1.852;
          N_v = round(v/4+1);
          vel_bin = bitget(N_v,10:-1:1);
        end  %������Ϊ4���ǳ�����Ϊ3
          
       %�����
        N_a = round(theta/0.3515625);
        bin_a = bitget(N_a,10:-1:1);
        
        %��ֱ�ٶȱ���,��ֱ�ʿ�����main��������
        %��ֱ�ٶȱ����������õĵ�λ��KM/S�����Ǳ�������е�λ��feet/����


            bin_vertical = zeros(1,9);
  
end
                 