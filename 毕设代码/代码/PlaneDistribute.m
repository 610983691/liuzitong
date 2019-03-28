 function [plane] = PlaneDistribute(lons,lats,highs,N1,goss_plane_num_arr,goss_center_info)% ���ǵľ���ά�ȸ߶�,���ȷֲ�����,ÿ����˹�ֲ�����ɻ���������˹�ֲ����ĵ���Ϣ 
%N1 = 10;%���ȷֲ��ɻ�����
goss_num = size(goss_center_info,2);%��˹�ֲ��������
goss_plane_num = goss_plane_num_arr;%ÿ����˹�ֲ��ķɻ����������Ǹ�����
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
%ͨ��theta1��phy����ɻ�������֮��ľ��롣
    syms x;
    result = solve(x^2-2*x*(6371+highs)*cos(theta1)+(6371+highs)^2-6371^2 == 0, x );
    result = double(result);
   for j = 1:length(result)
      if (result(j)<=sqrt((6371+highs)^2-6371^2))&& (result(j)>=highs)
         R = result(j);
      end
   end

%ת��������վ������ϵ
r1 = [ R*sin(pi-theta1)*cos(phy); -R*sin(pi-theta1)*sin(phy);R*cos(pi-theta1)];%ephy,etheta,er
 %ת����ֱ������ϵ
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
  plane(2,i) = mod(acos(r2(3)/6371)*180/pi,180);%γ��
  plane(3,i) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
  
end


%��˹�ֲ� �ھ��ȷֲ����������ѡһ������Ϊ��˹�ֲ�����
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

%��������ٶȡ�����ǡ�����
for i = 1:N
    plane(4,i) = (rand()*2+800)/3600;
    plane(5,i) = rand()*360*pi/180;
    plane(6,i) = rand()*4+50;%dnm
end
 end



