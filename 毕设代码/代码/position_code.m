function [hig,lat,lon] = position_code(hightmess,cpr_f,latitude,longitude)
    %先进行经纬度编码
    cpr_f = mod(cpr_f+1,2);%prc formt 决定是奇编码还是偶编码      
         NZ = 15;
         Dlat = 360/(4*NZ-cpr_f);
         lat =  latitude;
         yz = floor(2^17*mod(lat,Dlat)/Dlat+0.5);
         NL = floor(2*pi/(acos(1-(1-cos(pi/(2*NZ)))/(cos(abs(latitude)*pi/180)^2))));
           if NL-cpr_f+1 >0
              Dlon = 360/(4*NZ-cpr_f+1);
           else
              Dlon = 360; 
           end
         xz = floor(2^17*mod(longitude,Dlon)/Dlon+0.5);
         yz = mod(yz,2^17);
         xz = mod(xz,2^17);
         lat = bitget(yz,17:-1:1);
         lon  = bitget(xz,17:-1:1);
         
      %再进行高度编码
       b= round(hightmess/0.0003048);
          if b>50175
             int1 = fix((b+1200)/500);
             bin_1 = bitget(int1,8:-1:1);
             gry1 = bitxor(bin_1,[0,bin_1(1,1:7)]);
             int2 = fix(rem(b+1200,500)/100);
             bin_2 = bitget(int2,3:-1:1);
             gry2 = bitxor(bin_2,[0,bin_2(1,1:2)]);
             hig = [gry2(1,1),gry1(1,3),gry2(1,2),gry1(1,4),gry2(1,3),gry1(1,5),gry1(1,6),0,...
                    gry1(1,7),gry1(1,1),gry1(1,8),gry1(1,2)];
          else
             n = ceil((hightmess/0.0003048+12.5+1000)/25);
             bin = bitget(n,11:-1:1);
             hig = [bin(1,1:7),1,bin(1,8:11)];  
          end
end
         