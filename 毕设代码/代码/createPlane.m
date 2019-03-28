        function plane = createPlane(lon,lat,high,speed,hxj,power)
                plane = zeros(7,1);
 
                plane(1,1) = lon;
                plane(2,1) = lat;
                plane(3,1) = (high-1)*0.3+8.4+(rand()*2-1)*0.02;
                plane(4,1) = speed;
                plane(5,1) = hxj;
                plane(6,1) = power;%dnm
                plane(7,1)=1;
        end