function planes_in_the_world_map(planes_lon,planes_lat)%����������Ĺ켣ͼ
figure(3)
ax = worldmap('World');
framem on;
land = shaperead('landareas', 'UseGeoCoords', true)%½��  ���߲���x,yΪ��γ��
geoshow(land, 'FaceColor', [0.5 0.7 0.5])

rivers = shaperead('worldrivers', 'UseGeoCoords', true);
geoshow(rivers, 'Color', 'blue')

rows = size(planes_lon,1);%�ɻ����ȵ���������ɻ��ļ�����Ҳ������������
for row=1:rows
    lats=[planes_lat(row,1),planes_lat(row,size(planes_lat,2))];%ֻȡ�����յ�
    lons=[planes_lon(row,1),planes_lon(row,size(planes_lon,2))];
    linem(lats,lons,'r-');%����Ĳ�������γ�ȣ��󾭶�
    geoshow(lats(1,1), lons(1,1), 'Marker','+','MarkerEdgeColor','red');%�������,�ɻ���o��ʾ
end


end