classdef AIRCRAFT
    properties
        simu_time;
        time_step;
        longitude;
        latitde;
        hight;
        velocity;
        acce_v;%加速度
        path_angle;%航向角
        ele_angle;&%仰角
    end
    
    methods
        function obj = AIRCRAFT(simu_t,step_t,lo,la,high,vel,a_v,p_a,e_a)
            obj.simu_time = simu_t;
            obj.time_step = step_t;
            obj.longitude = lo;
            obj.latitude = la;
            obj,hight = high;
            obj.velocity = vel;
            obj.acce_v = a_v;
            obj.path_angle = p_a;
            obj.ele_angle = e_a;
        end
        
        %位置变化  这里的经纬度其实就是角度，最后如果需要显示出来再按照对应规则显示
        function obj = ChangePosition(obj,ratio)
            obj.velocity = obj.velocity + obj.acce_v*obj.time_step;
            
            obj.latitude = obj.latitude + 
            obj.longitude = obj.longitude+
           
        