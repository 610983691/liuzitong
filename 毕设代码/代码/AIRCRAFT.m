classdef AIRCRAFT
    properties
        simu_time;
        time_step;
        longitude;
        latitude;
        hight;
        velocity;
        acce_v;%加速度
        path_angle;%航向角
        ele_angle;%仰角
        ID;
        broad_times;
        last_broadtime;
        last_AP=1;
        last_AV=2;
        last_ID=3;
        cpr_f;
        r;
        v;
       mess_all ;
       mecode_all;
       time_rec;
       LOSS;
       shift_f ;
       ant_gain ;
       ppmseq ;
       rec_time;
       seq_mid;
       power;
       seq_mid1;
       seq_mid2;
    end
    
    methods
        function obj = AIRCRAFT(simu_t,step_t,lo,la,high,vel,a_v,p_a,e_a,first_time,id)
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
            obj.cpr_f = randi(2);%1表示奇编码 2 表示偶编码
            obj.ID = id;
            obj.mess_all = [];
            obj.mecode_all = [];
            obj.time_rec = [];
            obj.LOSS = [];
            obj.shift_f = [];
            obj.ant_gain = [];
            obj.ppmseq = [];
            obj.rec_time = [];
            obj.seq_mid = [];
            obj.power = [];
            obj.seq_mid1 = [];
            obj.seq_mid2 = [];
        end
        
        %位置变化  这里的经纬度其实就是角度，最后如果需要显示出来再按照对应规则显示
        function obj = ChangePosition(obj,ratio)
            obj.velocity = obj.velocity + obj.acce_v*obj.time_step;
            obj.hight = obj.hight + (obj.velocity*obj.time_step+1/2*obj.acce_v*obj.time_step^2)*sin(obj.ele_angle);
            obj.latitude = obj.latitude + obj.velocity*cos(obj.ele_angle)*cos(obj.path_angle)*obj.time_step/(ratio+obj.hight);
            obj.longitude = obj.longitude + obj.velocity*cos(obj.ele_angle)*sin(obj.path_angle)*obj.time_step/(ratio+obj.hight)/cos(obj.latitude*pi/180);
             %飞机在直角坐标系中位置表示
            %得出直角坐标系中的向量表达方式可以方便用于下面的计算中
            obj.r = [(ratio+obj.hight)*sin(obj.latitude*pi/180)*cos(obj.longitude*pi/180);...
                (ratio+obj.hight)*sin(obj.latitude*pi/180)*sin(obj.longitude*pi/180);...
                (ratio+obj.hight)*cos(obj.latitude*pi/180)]; 
            
             %飞机在直角坐标系中速度表示
            %obj.v =[v,90-仰角，航向角];
            ns_v = obj.velocity*cos(obj.ele_angle)*cos(obj.path_angle);
            ew_v = obj.velocity*cos(obj.ele_angle)*sin(obj.path_angle);%西东速度
            vertical_v = obj.velocity*sin(obj.ele_angle);
            obj.v =[vertical_v*sin(obj.latitude*pi/180)*cos(obj.longitude*pi/180)+...
                    ns_v*cos(obj.latitude*pi/180)*cos(obj.longitude*pi/180)-ew_v*sin(obj.longitude*pi/180);...
                    vertical_v*sin(obj.latitude*pi/180)*sin(obj.longitude*pi/180)+...
                    ns_v*cos(obj.latitude*pi/180)*sin(obj.longitude*pi/180)+ew_v*cos(obj.longitude*pi/180);...
                    vertical_v*cos(obj.latitude*pi/180)- ns_v*sin(obj.longitude*pi/180)]; 
        end
        
        
        %播报规则
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
        