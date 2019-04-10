function planes_in_the_world_map(planes_lon,planes_lat)%无卫星情况的轨迹图
figure(3)
ax = worldmap('World');
framem on;
land = shaperead('landareas', 'UseGeoCoords', true)%陆地  后者参数x,y为经纬度
geoshow(land, 'FaceColor', [0.5 0.7 0.5])

rivers = shaperead('worldrivers', 'UseGeoCoords', true);
geoshow(rivers, 'Color', 'blue')

rows = size(planes_lon,1);%飞机经度的行数代表飞机的架数，也代表航迹的条数
for row=1:rows
    lats=[planes_lat(row,1),planes_lat(row,size(planes_lat,2))];%只取起点和终点
    lons=[planes_lon(row,1),planes_lon(row,size(planes_lon,2))];
    linem(lats,lons,'r-');%这里的参数是先纬度，后经度
    geoshow(lats(1,1), lons(1,1), 'Marker','+','MarkerEdgeColor','red');%设置起点,飞机用o表示
end


end