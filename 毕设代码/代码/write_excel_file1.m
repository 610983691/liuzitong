function write_excel_file1(time_asix_mess,planes_id)%无卫星情况excel文件写入
filename = 'no_satellite_data.xls';
A = {'发送时间(ms)','飞机编号(ICAO)','报文功率','经度','纬度','高度(Km)','南北速度(knots)','东西速度(knots)','垂直速度(feet/min)','报文类型','ID','数据链信息'};
sheet = 1;
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%写入表头
%封装数据矩阵
rows =size(time_asix_mess,2);%每个飞机数据在excel里边是一行
data = cell(rows,13);%rows*13列的元胞数组，rows是飞机个数

planes_id_asix = cell(2,rows);%Id的大小2行，飞机列数(飞机数目)作为列数
for i = 1:rows%遍历所有的飞机
    for j = 1:2
        planes_id_asix{j,i} = planes_id{j,time_asix_mess(2,i)};%根据飞机的编号，去获取plane_id放到planes_id_asix里边，一个飞机就是一列
    end
end

for row=1:rows %遍历每一行
    for col=1:11
        data{row,col}=time_asix_mess(col,row);%飞机数据的行和列是反着的
    end
    data{row,12}=planes_id_asix{1,row};%飞机的ID也是一列一列放的
    data{row,13}=planes_id_asix{2,row};
end


%接下来开始写入数据
xlswrite(filename,data,sheet,'A2');%写入
end
