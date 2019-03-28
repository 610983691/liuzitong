% function goss(lons,lats,highs,lon)%����lon���û�����ľ���
%%�����û�������lons,lats,highs�����ž��ȵķ�Χlon_up,lon_down;Ȼ��ͨ���û������ھ��ȷ�Χ�ڵľ��ȣ��Ӷ�ȷ��γ�ȵķ�Χlat_down,lat_up
clear all;
lats =90;
lons = 0;
highs = 700;
     d1 = sqrt((highs+6371)^2-6371^2);
     rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
     theta = acos(6371/(6371+highs))*180/pi;
     %��������ڸ��Ƿ�Χ�ڣ��򾭶ȷ�Χ��0-360 ��������(0,0,6371),(0,0,-6371)
     r_polar1 = [0,0,6371];
     r_polar2 = [0,0,-6371];
     if (norm(r_polar1-rs)<=d1)||((norm(r_polar2-rs)<=d1))
         lon_up = 180;
         lon_down = -180; %������180�ȵ�����180��
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
     lat_up = 90-lat_up;%��γ�ȱ�ɱ�γ��γ��ʽ
     else  %���㲻���������棬������Ҫȷ�����ȷ�Χ       
%������ȵķ�Χ
       d_AO = 2*6371*sin(theta*pi/180/2);
       theta_change = 2*asin(d_AO/(2*6371*cos((90-lats)*pi/180)))*180/pi;
       lon_down = lons-theta_change;
       lon_up = lons+theta_change;
       if lon_down>180
          lon_down = lon_down-360;%��������
       end
      if lon_up>180
         lon_up = lon_up-360;%��������
      end
    %�����������վ��ȵķ�Χ�����ǴӸ�����һ��������Ҳ������������������Ҳ���ܷ�����ͬ
     %���ȷ�Χ��Ӧ����������ʾ����       
     lon = 0;%�û����õ���lon_down��lon_up��Χ�ڵľ���ֵ�������������ֵ�������������£�γ�ȵķ�Χ��
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
     
           
     
         
     