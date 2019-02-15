classdef AIRCRAFT
    properties
        simu_time;
        time_step;
        longitude;
        latitude;
        hight;
        velocity;
        acce_v;%���ٶ�
        path_angle;%�����
        ele_angle;%����
        broad_times;
        last_broadtime;
        last_AP=1;
        last_AV=2;
        last_ID=3;
    end
    
    methods
        function obj = AIRCRAFT(simu_t,step_t,lo,la,high,vel,a_v,p_a,e_a,first_time)
            obj.simu_time = simu_t;
            obj.time_step = step_t;
            obj.longitude = lo;
            obj.latitude = la;
            obj.hight = high;
            obj.velocity = vel;
            obj.acce_v = a_v;
            obj.path_angle = p_a;
            obj.ele_angle = e_a;
            obj.broad_times = zeros(1, simu_t/step_t);
            obj.last_broadtime = first_time;
            obj.broad_times(first_time) = 1;
        end
        
        %λ�ñ仯  ����ľ�γ����ʵ���ǽǶȣ���������Ҫ��ʾ�����ٰ��ն�Ӧ������ʾ
        function obj = ChangePosition(obj,ratio)
            obj.velocity = obj.velocity + obj.acce_v*obj.time_step;
            obj.hight = obj.hight + (obj.velocity*obj.time_step+1/2*obj.acce_v*obj.time_step^2)*sin(obj.ele_angle);
            obj.latitude = obj.latitude + obj.velocity*cos(obj.ele_angle)*cos(obj.path_angle)*obj.time_step/(ratio+obj.hight);
            obj.longitude = obj.longitude + obj.velocity*cos(obj.ele_angle)*sin(obj.path_angle)*obj.time_step/(ratio+obj.hight)/cos(obj.latitude*pi/180);
        end
        
        
        %��������
       function obj=BroadCast(obj,count)
           
            %AP
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6)&...
                    ((count-obj.last_AP)*obj.time_step>=0.5))
                broadt=ceil(count+rand(1)*10);
                obj.last_broadtime=broadt;
                obj.last_AP=broadt;
                obj.broad_times(broadt)=1;
            end
            %AV
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6) &...
                    ((count-obj.last_AV)*obj.time_step>=0.5))
                broadt=ceil(count+rand(1)*10);
                obj.last_broadtime=broadt;
                obj.last_AV=broadt;
                obj.broad_times(broadt)=2;                    
            end
            %ID
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6)&...
                    ((count-obj.last_ID)*obj.time_step>=5))
                broadt=ceil(count+rand(1)*10);
                obj.last_broadtime=broadt;
                obj.last_ID=broadt;
                obj.broad_times(broadt)=3;                
            end
         
       end
    end
end
        