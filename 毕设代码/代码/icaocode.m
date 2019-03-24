function [icaobin] = icaocode(ICAO)
     icaobin= zeros(1,24);
     for j = 1:4 
            icaobin(1,(j*6-5):(j*6)) = bitand(bitget(double(ICAO{j}),6:-1:1),[1,1,1,1,1,1]);  
     end
end