function planes_in_the_world_map_with_satellite(planes_lon,planes_lat,wx_lon,wx_lat,wx_high)%有卫星情况的轨迹图
figure(4)
m_proj('Stereographic','longitudes',wx_lon,'latitudes',wx_lat,'radius',90,'rec','circle','rot',0)
m_coast('patch', [0.5 0.7 0.5]);%画出海岸线及陆地颜色
m_grid;
m_line(wx_lon,wx_lat,'marker','o','color','r');%卫星使用+号表示
range =6371*acos(6371/(6371+wx_high));
m_range_ring(wx_lon,wx_lat,[range],'color','b','linewi',2);%画一个wx_range范围的圈
xlabel('有卫星场景飞机分布图');
rows = size(planes_lon,1);%飞机经度的行数代表飞机的架数，也代表航迹的条数
for row=1:rows
    lats=[planes_lat(row,1),planes_lat(row,size(planes_lat,2))];%只取起点和终点
    lons=[planes_lon(row,1),planes_lon(row,size(planes_lon,2))];
    m_line(lons,lats,'marker','.','color','r');%划线
    m_line(lons(1,1),lats(1,1),'marker','+','color','r');%设置起点,飞机用o表示


end

end