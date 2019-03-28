function [lon_down,lon_up] = goss_lon_range(lons,lats,highs)%其中lon是用户输入的经度
%%对于用户来讲，lons,lats,highs决定着经度的范围lon_up,lon_down;然后通过用户输入在经度范围内的经度，从而确定纬度的范围lat_down,lat_up
     d1 = sqrt((highs+6371)^2-6371^2);
     rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
     theta = acos(6371/(6371+highs))*180/pi;
     %如果极点在覆盖范围内，则经度范围是0-360 极点坐标(0,0,6371),(0,0,-6371)
     r_polar1 = [0,0,6371];
     r_polar2 = [0,0,-6371];
     if (norm(r_polar1-rs)<=d1)||((norm(r_polar2-rs)<=d1))
         lon_up = 180;
         lon_down = -180; %从西经180度到东经180度
     else  %极点不包含在里面，首先需要确定经度范围       
%求出经度的范围
       d_AO = 2*6371*sin(theta*pi/180/2);
       theta_change = 2*asin(d_AO/(2*6371*cos((90-lats)*pi/180)))*180/pi;
       lon_down = lons-theta_change;
       lon_up = lons+theta_change;
       if lon_down>180
          lon_down = lon_down-360;%代表西经
       end
      if lon_up>180
         lon_up = lon_up-360;%代表西经
      end  
     end
     
           
     
         
     