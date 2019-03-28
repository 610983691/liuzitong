function [lat_down,lat_up] = goss_lat_range(lons,lats,highs,lon_down,lon_up,lon)
     d1 = sqrt((highs+6371)^2-6371^2);
     rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
    if (lon_up == 180)||(lon_down==-180)%极点包含在里面
      syms y;
      if lon<0
          lon = lon+360;
      end  %将用户给的东西经变成球坐标系的角度进行下面的计算   
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
     lat_up = 90-lat_up;  %将纬度变成北纬南纬形式
    else
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
end