function write_lat_data_2_file(latdata)

fid=fopen('latData.txt','w');
rows = size(latdata,1);
columns = size(latdata,2);
%遍历row次
for row = 1:rows
    one_row_data= latdata(row,:);%获取第i行的数据
    for col = 1:columns
        data=one_row_data(1,col);%获取一个纬度数据
        fprintf(fid,'%3.12f',data);
        if col~=columns
            fprintf(fid,'%s',',');%每个数据以逗号分隔,最后一个数据不分割
        end
    end
    fprintf(fid,'%s',';');%每行数据数据以;分号分隔
    fprintf(fid,'\r\n');
end
fclose(fid);
end