function planes_in_the_world_map_with_satellite(planes_lon,planes_lat,wx_lon,wx_lat,wx_high)%����������Ĺ켣ͼ
figure(4)
m_proj('Stereographic','longitudes',wx_lon,'latitudes',wx_lat,'radius',90,'rec','circle','rot',0)
m_coast('patch', [0.5 0.7 0.5]);%���������߼�½����ɫ
m_grid;
m_line(wx_lon,wx_lat,'marker','o','color','r');%����ʹ��+�ű�ʾ
range =6371*acos(6371/(6371+wx_high));
m_range_ring(wx_lon,wx_lat,[range],'color','b','linewi',2);%��һ��wx_range��Χ��Ȧ
xlabel('�����ǳ����ɻ��ֲ�ͼ');
rows = size(planes_lon,1);%�ɻ����ȵ���������ɻ��ļ�����Ҳ������������
for row=1:rows
    lats=[planes_lat(row,1),planes_lat(row,size(planes_lat,2))];%ֻȡ�����յ�
    lons=[planes_lon(row,1),planes_lon(row,size(planes_lon,2))];
    m_line(lons,lats,'marker','.','color','r');%����
    m_line(lons(1,1),lats(1,1),'marker','+','color','r');%�������,�ɻ���o��ʾ


end

end