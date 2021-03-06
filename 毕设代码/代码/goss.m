function [lon_down,lon_up] = goss_lon_range(lons,lats,highs,lon)%其中lon是用户输入的经度
%%对于用户来讲，lons,lats,highs决定着经度的范围lon_up,lon_down;然后通过用户输入在经度范围内的经度，从而确定纬度的范围lat_down,lat_up
clear all;
lats =90;
lons = 0;
highs = 700;
     d1 = sqrt((highs+6371)^2-6371^2);
     rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
     theta = acos(6371/(6371+highs))*180/pi;
     %如果极点在覆盖范围内，则经度范围是0-360 极点坐标(0,0,6371),(0,0,-6371)
     r_polar1 = [0,0,6371];
     r_polar2 = [0,0,-6371];
     if (norm(r_polar1-rs)<=d1)||((norm(r_polar2-rs)<=d1))
         lon_up = 180;
         lon_down = -180; %从西经180度到东经180度
     lon = 0;
     syms y;
     r = [6371*sin(y*pi/180)*cos(lon*pi/180),6371*sin(y*pi/180)*sin(lon*pi/180),6371*cos(y*pi/180)];
     d = norm(r-rs);
     f = d-d1;
     func = matlabFunction(f,'Vars',y);
     lat_down = fsolve(func,0);  
     if lat_down<0
        if ((lons>=0)&&(lons<90)&&(lon>lons+90)&&(lon<lons+270))||((lons>=90)&&(lons<270)&&((lon>lons+90)||(0<=lons<=lon-90)))...
            ||((lons>=270)&&(lon>mod((lons+90),360))&&(lon<=lons-90))
            lat_up = -lat_down;
            lat_down = 0;
        else
            lat_up = 2*lats-lat_down;
            lat_down = 0;
        end
     else
         lat_up = 2*lats-lat_down;
         if lat_up>180
             lat_up = 180;
         end
     end
     lat_down = 90-lat_down;
     lat_up = 90-lat_up;%将纬度变成北纬南纬形式
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
    %所以我们最终经度的范围可能是从负数到一个正数，也可能是正数到负数，也可能符号相同
     %经度范围对应到东西经表示方法       
     lon = 0;%用户设置的在lon_down到lon_up范围内的经度值，根据这个经度值求出在这个经度下，纬度的范围。
     syms x;
     r = [6371*sin(x*pi/180)*cos(lon*pi/180),6371*sin(x*pi/180)*sin(lon*pi/180),6371*cos(x*pi/180)];
     d = norm(r-rs);
     f = d-d1;
     func = matlabFunction(f,'Vars',x);
     lat_down = fsolve(func,0);
     lat_up = 2*lats-lat_down;
     lat_down = 90-lat_down;
     lat_up = 90-lat_up;
     end
     
           
     
         
     