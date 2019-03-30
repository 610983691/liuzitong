classdef AIRCRAFT
    properties
        simu_time;
        time_step;
        longitude;
        latitude;
        hight;
        velocity;
        path_angle;%航向角
        ID;
        broad_times;
        last_broadtime;
        last_AP=1;
        last_AV=2;
        last_ID=3;
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
       r_h;
       rate_v;
       cpr;
    end
    
    methods
        function obj = AIRCRAFT(simu_t,step_t,lo,la,high,vel,p_a,first_time,rate_v)
            obj.simu_time = simu_t;
            obj.time_step = step_t;
            obj.longitude = lo;
            obj.latitude = la;
            obj.hight = high;
            obj.velocity = vel;
            obj.path_angle = p_a;
            obj.broad_times = zeros(1, simu_t/step_t);
            obj.last_broadtime = first_time;
            obj.broad_times(first_time) = 1;
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
            obj.rate_v = rate_v;
            obj.cpr = [];
        end
        
        %位置变化  这里的经纬度其实就是角度，最后如果需要显示出来再按照对应规则显示
        function obj = ChangePosition(obj,ratio)
            obj.velocity = obj.velocity ;
            obj.hight = obj.hight+obj.rate_v*5.08*10^(-6)*obj.time_step ;%将垂直速度英尺每分钟变成KM/S英尺每分钟等于5。08毫米每秒
            obj.latitude = obj.latitude + obj.velocity*cos(obj.path_angle)*obj.time_step/(ratio+obj.hight);
            obj.longitude = obj.longitude + obj.velocity*sin(obj.path_angle)*obj.time_step/(ratio+obj.hight)/cos(obj.latitude*pi/180);
             %飞机在直角坐标系中位置表示
            %得出直角坐标系中的向量表达方式可以方便用于下面的计算中
            obj.r = [(ratio+obj.hight)*sin(obj.latitude*pi/180)*cos(obj.longitude*pi/180);...
                (ratio+obj.hight)*sin(obj.latitude*pi/180)*sin(obj.longitude*pi/180);...
                (ratio+obj.hight)*cos(obj.latitude*pi/180)]; 
            obj.r_h = [ratio*sin(obj.latitude*pi/180)*cos(obj.longitude*pi/180);...
                ratio*sin(obj.latitude*pi/180)*sin(obj.longitude*pi/180);...
                ratio*cos(obj.latitude*pi/180)]; 
            
             %飞机在直角坐标系中速度表示
            %obj.v =[v,90-仰角，航向角];
            ns_v = obj.velocity*sin(obj.path_angle);
            ew_v = obj.velocity*cos(obj.path_angle);%西东速度
            r1 = [ ew_v; ns_v;obj.rate_v*5.08*10^(-6)];%er,etheta,rphy
            obj.v = [-sin(obj.longitude*pi/180),cos(obj.longitude*pi/180),0;cos(obj.latitude*pi/180)*cos(obj.longitude*pi/180),cos(obj.latitude*pi/180)*sin(obj.longitude*pi/180),-sin(obj.latitude*pi/180);...
                  sin(obj.latitude*pi/180)*cos(obj.longitude*pi/180),sin(obj.latitude*pi/180)*sin(obj.longitude*pi/180),cos(obj.latitude*pi/180)]^-1*r1+obj.r;
        end
        
        
        %播报规则
       function obj=BroadCast(obj,count)
           
            %AP
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6)&...
                    ((count-obj.last_AP)*obj.time_step>=0.5))
                broadt=ceil(count+(rand(1)*2-1)*0.1/obj.time_step);%存在0.1s
                obj.last_broadtime=broadt;
                obj.last_AP=broadt;
                obj.broad_times(broadt)=1;
            end
            %AV
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6) &...
                    ((count-obj.last_AV)*obj.time_step>=0.5))
                broadt=ceil(count+(rand(1)*2-1)*0.1/obj.time_step);
                obj.last_broadtime=broadt;
                obj.last_AV=broadt;
                obj.broad_times(broadt)=2;                    
            end
            %ID
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6)&...
                    ((count-obj.last_ID)*obj.time_step>=5))
                broadt=ceil(count+(rand(1)*2-1)*0.2/obj.time_step);
                obj.last_broadtime=broadt;
                obj.last_ID=broadt;
                obj.broad_times(broadt)=3;                
            end
         
       end
        function obj=BroadCast1(obj,count)
           
            %AP
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6)&...
                    ((count-obj.last_AP)*obj.time_step>=1))
                broadt=ceil(count+(rand(1)*2-1)*0.1/obj.time_step);%存在0.1s
                obj.last_broadtime=broadt;
                obj.last_AP=broadt;
                obj.broad_times(broadt)=1;
            end
            %AV
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6) &...
                    ((count-obj.last_AV)*obj.time_step>=1))
                broadt=ceil(count+(rand(1)*2-1)*0.1/obj.time_step);
                obj.last_broadtime=broadt;
                obj.last_AV=broadt;
                obj.broad_times(broadt)=2;                    
            end
            %ID
            if(((count-obj.last_broadtime)*obj.time_step>=120e-6)&...
                    ((count-obj.last_ID)*obj.time_step>=5))
                broadt=ceil(count+(rand(1)*2-1)*0.2/obj.time_step);
                obj.last_broadtime=broadt;
                obj.last_ID=broadt;
                obj.broad_times(broadt)=3;                
            end
        end
    end
end
        