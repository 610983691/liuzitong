classdef AIRCRAFT
    properties
        simu_time;
        time_step;
        longitude;
        latitde;
        hight;
        velocity;
        acce_v;%���ٶ�
        path_angle;%�����
        ele_angle;&%����
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
        
        %λ�ñ仯  ����ľ�γ����ʵ���ǽǶȣ���������Ҫ��ʾ�����ٰ��ն�Ӧ������ʾ
        function obj = ChangePosition(obj,ratio)
            obj.velocity = obj.velocity + obj.acce_v*obj.time_step;
            
            obj.latitude = obj.latitude + 
            obj.longitude = obj.longitude+
           
        