function write_satellite_location(lon,lat,high)%卫星的经度、纬度、高度

fid=fopen('wxlocation.txt','w');

fprintf(fid,'%3.12f',lon);
fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
fprintf(fid,'%3.12f',lat);
fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
r = high;%球面半径需要根据经纬高计算出来，这个计算方法紫童来完成，单位是KM
fprintf(fid,'%3.12f',r);


fclose(fid);
end