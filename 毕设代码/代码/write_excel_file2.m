function write_excel_file2(time_asix_mess,planes_id)%有卫星情况excel文件写入
filename = 'satellite_data.xls';
if size(time_asix_mess,1)==12
A = {'接收时间','发送时间','飞机编号','报文编号','报文功率','经度','纬度','高度','速度','垂直速度','报文类型','奇偶编码','ICAO','ID'};
end
if  size(time_asix_mess,1)==13
A = {'接收时间','发送时间','飞机编号','报文编号','天线1报文功率','天线2报文功率','经度','纬度','高度','速度','垂直速度','报文类型','奇偶编码','ICAO','ID'};
end
sheet = 1;
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%写入表头

%封装数据矩阵
rows =size(time_asix_mess,2);%每个报文数据在excel里边是一行
cols =size(A,2);
data = cell(rows,cols);%rows*A列的元胞数组，rows是报文个数

planes_id_asix = cell(2,rows);%Id的大小2行，飞机列数(飞机数目)作为列数
for i = 1:rows%遍历所有的飞机
    for j = 1:2
        planes_id_asix{j,i} = planes_id{j,time_asix_mess(3,i)};%根据飞机的编号，去获取plane_id放到planes_id_asix里边，一个飞机就是一列
    end
end

for row=1:rows %遍历每一行
    for col=1:cols-2 %前面cols-2列是飞机数据，后面两列是ID数据
        data{row,col}=time_asix_mess(col,row);%飞机数据的行和列是反着的
    end
    data{row,12}=planes_id_asix{1,row};%飞机的ID也是一列一列放的
    data{row,13}=planes_id_asix{2,row};
end


%接下来开始写入数据
xlswrite(filename,data,sheet,'A2');%写入
end
