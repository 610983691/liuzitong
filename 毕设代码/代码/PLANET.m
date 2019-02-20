classdef PLANET
  properties
      simu_time;
      time_step;
      longitude;
      latitude;
      hight;
      velocity;
      path_angle;
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
      end
  end
end
