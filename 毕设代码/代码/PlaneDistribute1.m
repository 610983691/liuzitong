function plane = PlaneDistribute1(N)
  plane = zeros(1,N);
  for i = 1:N
    plane(1,i) = rand()*360;
    plane(2,i) = rand()*180;
    plane(3,i) = (randi(13)-1)*0.3+8.4+(rand()*2-1)*0.02;
    plane(4,i) = (rand()*2+800)/3600;
    plane(5,i) = rand()*360*pi/180;
    plane(6,i) = rand()*30-115;%dnm
  end
end