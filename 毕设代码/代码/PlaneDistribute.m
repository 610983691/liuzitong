 function [plane] = PlaneDistribute(lons,lats,highs,N1,goss_plane_num_arr,goss_center_info)% 卫星的经度维度高度,均匀分布个数,每个高斯分布区域飞机个数，高斯分布中心点信息 
%N1 = 10;%均匀分布飞机个数
goss_num = size(goss_center_info,2);%高斯分布区域个数
goss_plane_num = goss_plane_num_arr;%每个高斯分布的飞机个数，这是个数组
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
theta = asin(6371/(6371+highs));
N = N1;
for i = 1:goss_num
    N = N+goss_plane_num(i);
end
plane = zeros(6,N);
for i = 1:N1
   phy = rand()*360*pi/180;
   theta1= rand()*theta;
%通过theta1和phy求出飞机和卫星之间的距离。
    syms x;
    result = solve(x^2-2*x*(6371+highs)*cos(theta1)+(6371+highs)^2-6371^2 == 0, x );
    result = double(result);
   for j = 1:length(result)
      if (result(j)<=sqrt((6371+highs)^2-6371^2))&& (result(j)>=highs)
         R = result(j);
      end
   end

%转换成卫星站心坐标系
r1 = [ R*sin(pi-theta1)*cos(phy); -R*sin(pi-theta1)*sin(phy);R*cos(pi-theta1)];%ephy,etheta,er
 %转换成直角坐标系
 r2 = [-sin(lons*pi/180),cos(lons*pi/180),0;cos(lats*pi/180)*cos(lons*pi/180),cos(lats*pi/180)*sin(lons*pi/180),-sin(lats*pi/180);...
       sin(lats*pi/180)*cos(lons*pi/180),sin(lats*pi/180)*sin(lons*pi/180),cos(lats*pi/180)]^-1*r1+rs';
   if (r2(3)/r2(1)>=0)&&(r1(1)>=0)
      plane(1,i) = atan(r2(2)/r2(1))*180/pi;
   else
       if(r2(3)/r2(1)>=0)&&(r1(1)<=0)
           plane(1,i) = atan(r2(2)/r2(1))*180/pi+180;  
       else
           if(r2(3)/r2(1)<=0)&&(r1(1)<=0)
           plane(1,i) = atan(r2(2)/r2(1))*180/pi+180;  
           else
               if(r2(3)/r2(1)<=0)&&(r1(1)>=0)
                  plane(1,i) = atan(r2(2)/r2(1))*180/pi+360;
               end
           end
       end
   end
  plane(2,i) = mod(acos(r2(3)/6371)*180/pi,180);%纬度
  plane(3,i) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
  
end


%高斯分布 在均匀分布的随机点中选一个点作为高斯分布中心
if goss_num~=0
    position_center = zeros(goss_num,2);
    for i = 1:goss_num
        position_center(i,:) =[plane(1,randi(N1)),plane(2,randi(N1))];
        for j = 1:goss_plane_num(i)
            plane(1,N1+j) = mod(position_center(i,1)+randn(),2*pi);
            plane(2,N1+j) = mod(position_center(i,2)+randn(),pi);
            plane(3,N1+j) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;

        end
        N1 = N1+goss_plane_num(i);
    end
end

%随机分配速度、航向角、功率
for i = 1:N
    plane(4,i) = (rand()*2+800)/3600;
    plane(5,i) = rand()*360*pi/180;
    plane(6,i) = rand()*4+50;%dnm
end
 end



