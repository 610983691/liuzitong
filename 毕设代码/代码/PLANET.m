classdef PLANET
  properties
      simu_time;
      time_step;
      longitude;
      latitude;
      hight;
      velocity;
      path_angle;
      r;
      v;
  end
  
  methods
      function obj = PLANET(simu,step,lon,lat,high,v,angle)
          obj.simu_time = simu;
          obj.time_step = step;
          obj.longitude = lon;
          obj.latitude = lat;
          obj.hight = high;
          obj.velocity = v;
          obj.path_angle = angle;
      end
      
      function obj = ChangePositionS(obj,ratio)
          obj.latitude = obj.latitude + obj.velocity*cos(obj.path_angle)*obj.time_step/(ratio+obj.hight);
          obj.longitude = obj.longitude + obj.velocity*sin(obj.path_angle)*obj.time_step/(ratio+obj.hight)/cos(obj.latitude*pi/180);
          obj.r = [(ratio+obj.hight)*sin(obj.latitude*pi/180)*cos(obj.longitude*pi/180);...
                (ratio+obj.hight)*sin(obj.latitude*pi/180)*sin(obj.longitude*pi/180);...
                (ratio+obj.hight)*cos(obj.latitude*pi/180)]; 
            
             %������ֱ������ϵ���ٶȱ�ʾ�����Ǻͷɻ���ͬ������û�д�ֱ�ٶȡ�����Ϊ0
            %obj.v =[v,90-���ǣ������];
           ns_v = obj.velocity*cos(obj.path_angle*pi/180);
           ew_v = obj.velocity*sin(obj.path_angle*pi/180);%�����ٶ�
           obj.v =[ns_v*cos(obj.latitude*pi/180)*cos(obj.longitude*pi/180)-ew_v*sin(obj.longitude*pi/180);...
                    ns_v*cos(obj.latitude*pi/180)*sin(obj.longitude*pi/180)+ew_v*cos(obj.longitude*pi/180);...
                    - ns_v*sin(obj.longitude*pi/180)]; 
      end
  end
end
