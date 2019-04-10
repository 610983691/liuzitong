function [lon,lat] = cprdecode(lat1,lon1,cpr1,lat2,lon2)
NZ= 15;
   if cpr1==0
       YZ1 = bintodec(lat1);
       XZ1 = bintodec(lon1);
       YZ0 = bintodec(lat2);
       XZ0 = bintodec(lon2);
   else
       YZ1 = lat2;
       XZ1 = lon2;
       YZ0 = lat1;
       XZ0 = lon1; 
   end
   Dlat0 = 360/60;%Å¼±àÂë
   Dlat1 = 360/59;%Ææ±àÂë
%    ZO = Dlat1-Dlat0;
%    ZO0 = Dlat0/ZO;
%    ZO1 =Dlat1/ZO;
%   ZOYZ0 = 59*(YZ0/2^17);
%   ZOYZ1 = 60*(YZ1/2^17);
%   x = ZOYZ0-ZOYZ1;
  j = floor((59*YZ0-60*YZ1)/2^17+1/2);
   Rlat0 = Dlat0*(mod(j,(60-j)+YZ0/2^17));
   Rlat0 = mod(Rlat0+180,360)-180;
   Rlat1 = Dlat1*(mod(j,(60-j)+YZ1/2^17));
   Rlat1 = mod(Rlat1+180,360)-180;
    NL0 = floor(2*pi/(acos(1-(1-cos(pi/(2*NZ)))/(cos(abs(Rlat0)*pi/180)^2))));
   Dlon0 = 360/max(1,NL0-1);
    NL1 = floor(2*pi/(acos(1-(1-cos(pi/(2*NZ)))/(cos(abs(Rlat1)*pi/180)^2))));
   Dlon1 = 360/max(1,NL1-1);
   m0 = floor((XZ0*(NL0-1)-XZ1*NL0)/2^17+1/2);
   m1 = floor((XZ0*(NL0-1)-XZ1*NL0)/2^17+1/2);
   Rlon0 = Dlon0*(mod(m0,max(1,NL0-1))+XZ0/2^17);
   Rlon1 = Dlon1*(mod(m1,max(1,NL1-1))+XZ1/2^17);
   if cpr1==0
   lon = Rlon1;
   lat = Rlat1;
   else
   lon = Rlon0;
   lat = Rlat0;
   end
end
