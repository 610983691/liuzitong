function write_plane_param_2_file(time_asix_mess,planes_id, planes_lon,planes_lat)%有卫星情况的飞机起始位置信息写入
%封装数据矩阵
time_asix_mess_cols =size(time_asix_mess,2);%每个报文数据在excel里边是一行
data=cell(size(planes_lon,1),7);%只需要7列数据，需要飞机的行数
idx =0;
has_process=zeros(1,size(planes_lon,1));
time_asix_mess_rows= size(time_asix_mess,1);%飞机数据的行数
for i = 1:time_asix_mess_cols%遍历所有的飞机
    if time_asix_mess_rows==12 %无卫星的情况，只有12行数据
        for j=1:size(planes_lon,1)
            if  (abs(time_asix_mess(5,i)-planes_lon(j,1))<1e-4)&&(abs(time_asix_mess(6,i)-planes_lat(j,1))<1e-4) %如果经度和维度都相等,说明找到了,--这里如果两个飞机轨迹有交叉，且交叉点刚好都是报文采样点就会有BUG，导致ID/ICAO和飞机匹配不上。但是不管这个了，，
                if ~ismember(j,has_process)%判断J是否已存在，已存在说明已经获取到了。只有不存在才处理
                    idx=idx+1;
                    has_process(1,idx)=j;
                    data{idx,1}=planes_lon(j,1);%经度
                    data{idx,2}=planes_lat(j,1);%维度
                    data{idx,3}=planes_id{1,time_asix_mess(2,i)};%ICAO
                    data{idx,4}=planes_id{2,time_asix_mess(2,i)};%ID
                    data{idx,5}=time_asix_mess(8,i);%南北速度
                    data{idx,6}=time_asix_mess(9,i);%东西速度
                    data{idx,7}=time_asix_mess(10,i);%垂直速度
                    break;
                end
            end
        end
    elseif time_asix_mess_rows==13  %else就是有卫星的情况，有13行数据
        for j=1:size(planes_lon,1)
            if  (abs(time_asix_mess(5,i)-planes_lon(j,1))<1e-4)&&(abs(time_asix_mess(6,i)-planes_lat(j,1))<1e-4) %如果经度和维度都相等,说明找到了,--这里如果两个飞机轨迹有交叉，且交叉点刚好都是报文采样点就会有BUG，导致ID/ICAO和飞机匹配不上。但是不管这个了，，
                if ~ismember(j,has_process)%判断J是否已存在，已存在说明已经获取到了。只有不存在才处理
                    idx=idx+1;
                    has_process(1,idx)=j;
                    data{idx,1}=planes_lon(j,1);%经度
                    data{idx,2}=planes_lat(j,1);%维度
                    data{idx,3}=planes_id{1,time_asix_mess(3,i)};%ICAO
                    data{idx,4}=planes_id{2,time_asix_mess(3,i)};%ID
                    data{idx,5}=time_asix_mess(9,i);%南北速度
                    data{idx,6}=time_asix_mess(10,i);%东西速度
                    data{idx,7}=time_asix_mess(11,i);%垂直速度
                    break;
                end
            end
        end
    else %else就是有卫星的情况，有14行数据
        for j=1:size(planes_lon,1)
            if  (abs(time_asix_mess(7,i)-planes_lon(j,1))<1e-4)&&(abs(time_asix_mess(8,i)-planes_lat(j,1))<1e-4) %如果经度和维度都相等,说明找到了,--这里如果两个飞机轨迹有交叉，且交叉点刚好都是报文采样点就会有BUG，导致ID/ICAO和飞机匹配不上。但是不管这个了，，
                if ~ismember(j,has_process)%判断J是否已存在，已存在说明已经获取到了。只有不存在才处理
                    idx=idx+1;
                    has_process(1,idx)=j;
                    data{idx,1}=planes_lon(j,1);%经度
                    data{idx,2}=planes_lat(j,1);%维度
                    data{idx,3}=planes_id{1,time_asix_mess(3,i)};%ICAO
                    data{idx,4}=planes_id{2,time_asix_mess(3,i)};%ID
                    data{idx,5}=time_asix_mess(10,i);%南北速度
                    data{idx,6}=time_asix_mess(11,i);%东西速度
                    data{idx,7}=time_asix_mess(12,i);%垂直速度
                    break;
                end
            end
        end
    end
    
    if idx==size(planes_lon,1)
        break;
    end
end
if(idx<1)
    return;
end
filename = 'pointInfo.txt';
fid=fopen(filename,'w');
rows = size(data,1);
%遍历row次
for row = 1:rows
    fprintf(fid,'%3.12f',data{row,1});
    fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
    fprintf(fid,'%3.12f',data{row,2});
    fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
    fprintf(fid,'%s',data{row,3});
    fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
    fprintf(fid,'%s',data{row,4});
    fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
    fprintf(fid,'%3.12f',data{row,5});%南北速度
    fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
    fprintf(fid,'%3.12f',data{row,6});%东西速度
    fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
    fprintf(fid,'%3.12f',data{row,7});%垂直速度
    fprintf(fid,'%s',';');%每行数据数据以;分号分隔
    fprintf(fid,'\r\n');
end
fclose(fid);
end
