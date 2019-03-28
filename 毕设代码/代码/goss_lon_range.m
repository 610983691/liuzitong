function [lon_down,lon_up] = goss_lon_range(lons,lats,highs)%����lon���û�����ľ���
%%�����û�������lons,lats,highs�����ž��ȵķ�Χlon_up,lon_down;Ȼ��ͨ���û������ھ��ȷ�Χ�ڵľ��ȣ��Ӷ�ȷ��γ�ȵķ�Χlat_down,lat_up
     d1 = sqrt((highs+6371)^2-6371^2);
     rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
     theta = acos(6371/(6371+highs))*180/pi;
     %��������ڸ��Ƿ�Χ�ڣ��򾭶ȷ�Χ��0-360 ��������(0,0,6371),(0,0,-6371)
     r_polar1 = [0,0,6371];
     r_polar2 = [0,0,-6371];
     if (norm(r_polar1-rs)<=d1)||((norm(r_polar2-rs)<=d1))
         lon_up = 180;
         lon_down = -180; %������180�ȵ�����180��
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
     end
     
           
     
         
     