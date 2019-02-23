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
            
             %卫星在直角坐标系中速度表示，卫星和飞机不同，卫星没有垂直速度。仰角为0
            %obj.v =[v,90-仰角，航向角];
           ns_v = obj.velocity*cos(obj.path_angle*pi/180);
           ew_v = obj.velocity*sin(obj.path_angle*pi/180);%西东速度
           obj.v =[ns_v*cos(obj.latitude*pi/180)*cos(obj.longitude*pi/180)-ew_v*sin(obj.longitude*pi/180);...
                    ns_v*cos(obj.latitude*pi/180)*sin(obj.longitude*pi/180)+ew_v*cos(obj.longitude*pi/180);...
                    - ns_v*sin(obj.longitude*pi/180)]; 
      end
  end
end
