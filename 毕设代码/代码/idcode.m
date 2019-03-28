function [idbin] = idcode(ICAO)
     idbin= zeros(1,48);
     for j = 1:8
            idbin(1,(j*6-5):(j*6)) = bitand(bitget(ICAO(j),6:-1:1),[1,1,1,1,1,1]);  
     end
 
end