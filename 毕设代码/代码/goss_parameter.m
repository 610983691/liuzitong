function range = goss_parameter(goss_lat,goss_range)
range  = zeros(1,2);
    lat_range = goss_range/111.19;
    lon_range = goss_range/(111.19*cos((90-goss_lat)*pi/180));
   range(1,2) = lat_range/3;
    range(1,1)= lon_range/3;
end
