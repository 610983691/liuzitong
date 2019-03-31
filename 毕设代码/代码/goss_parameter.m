function [x_Q,y_Q] = goss_parameter(goss_lat,goss_range)
    lat_range = goss_range/111.19;
    lon_range = goss_range/(111.19*cos((90-goss_lat)*pi/180));
    x_Q = lat_range/3;
    y_Q= lon_range/3;
end
