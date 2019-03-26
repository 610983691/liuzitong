clear all;
N1 = 1000;
% % goss_num = 2;%高斯分布区域个数
% % goss_plane_num =[500,500];%每个高斯分布的飞机个数，这是个数组
lats = 60;
lons = 20;
highs = 700;
rs = [(highs+6371)*sin(lats*pi/180)*cos(lons*pi/180),(highs+6371)*sin(lats*pi/180)*sin(lons*pi/180),(highs+6371)*cos(lats*pi/180)];
theta = asin(6371/(6371+highs));
N = N1;
% for i = 1:goss_num
%     N = N+goss_plane_num(i);
% end
plane = zeros(6,N);
theta1 = zeros(1,N);
for i = 1:N1
   phy = rand()*360*pi/180;
   theta1(i)= rand()*theta;
%通过theta1和phy求出飞机和卫星之间的距离。
    syms x;
    result = solve(x^2-2*x*(6371+highs)*cos(theta1(i))+(6371+highs)^2-6371^2 == 0, x );
    result = double(result);
   for j = 1:length(result)
      if (result(j)<=sqrt((6371+highs)^2-6371^2))&& (result(j)>=highs)
         R = result(j);
      end
   end

%转换成卫星站心坐标系
r1 = [ R*sin(pi-theta1(i))*cos(phy); -R*sin(pi-theta1(i))*sin(phy);R*cos(pi-theta1(i))];%ephy,etheta,er
 %转换成直角坐标系
 r2 = [-sin(lons*pi/180),cos(lons*pi/180),0;cos(lats*pi/180)*cos(lons*pi/180),cos(lats*pi/180)*sin(lons*pi/180),-sin(lats*pi/180);...
       sin(lats*pi/180)*cos(lons*pi/180),sin(lats*pi/180)*sin(lons*pi/180),cos(lats*pi/180)]^-1*r1+rs';
   if (r2(2)/r2(1)>=0)&&(r2(1)/r2(3)>=0)
      plane(1,i) = atan(r2(2)/r2(1))*180/pi;
   else
       if(r2(2)/r2(1)>=0)&&(r2(1)/r2(3)<=0)
           plane(1,i) = atan(r2(2)/r2(1))*180/pi+180;  
       else
           if(r2(2)/r2(1)<=0)&&(r2(1)/r2(3)<=0)
           plane(1,i) = atan(r2(2)/r2(1))*180/pi+180;  
           else
               if(r2(2)/r2(1)<=0)&&(r2(1)/r2(3)>=0)
                  plane(1,i) = atan(r2(2)/r2(1))*180/pi+360;
               end
           end
       end
   end
  plane(2,i) = mod(acos(r2(3)/6371)*180/pi,180);%纬度
  plane(3,i) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
  
end


%高斯分布 在均匀分布的随机点中选一个点作为高斯分布中心
% if goss_num~=0
%     a = randi(N1);
%     b = randi(N1);
%     goss_center_info = [plane(1,a),plane(2,a);plane(1,b),plane(2,b)];
%     for i = 1:goss_num
%         for j = 1:goss_plane_num(i)
%             plane(1,N1+j) = mod(goss_center_info(i,1)+randn(),2*pi);
%             plane(2,N1+j) = mod(goss_center_info(i,2)+randn(),pi);
%             plane(3,N1+j) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
% 
%         end
%         N1 = N1+goss_plane_num(i);
%     end
% end

%随机分配速度、航向角、功率
for i = 1:N
    plane(4,i) = (rand()*2+800)/3600;
    plane(5,i) = rand()*360*pi/180;
    plane(6,i) = rand()*4+50;%dnm
end
plane_lat_path = 90-plane(2,:);
for i = 1:size(plane,2)
    if plane(1,i)>180
       plane_lon_path(1,i) = plane(1,i)-360;
    else
       plane_lon_path(1,i) = plane(1,i); 
    end
end
write_init_lon_data_2_file(plane_lon_path);
write_init_lat_data_2_file(plane_lat_path);


