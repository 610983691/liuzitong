function write_excel_file2(time_asix_mess,planes_id, mess_112_hex)%有卫星情况excel文件写入
filename = 'satellite_data.xls';
if size(time_asix_mess,1)==13
A = {'接收时间(s)','发送时间(ms)','飞机编号(ICAO)','报文功率(dbm)','经度','纬度','高度(Km)','南北速度(knots)','东西速度(knots)','垂直速度(feet/min)',...
    '报文类型','ID','数据链信息1-28bit','数据链信息29-56bit','数据链信息57-84bit','数据链信息85-112bit'};
end
if  size(time_asix_mess,1)==14
A = {'接收时间(s)','发送时间(ms)','飞机编号(ICAO)','天线1报文功率(dbm)','天线2报文功率(dbm)','经度','纬度','高度(Km)','南北速度(knots)','东西速度(knots)','垂直速度(feet/min)',...
    '报文类型','ID','数据链信息1-28bit','数据链信息29-56bit','数据链信息57-84bit','数据链信息85-112bit'};
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
    data{row,1}=time_asix_mess(1,row);
    data{row,2} = time_asix_mess(2,row);
    data{row,3} = planes_id_asix{1,row};%ICAO
    for col=4:size(A,2)-6%功率经纬高南北速度东西速度垂直速度 
        data{row,col}=time_asix_mess(col+1,row);%飞机数据的行和列是反着的
    end
    switch(time_asix_mess(size(time_asix_mess,1)-1,row))
        case 1 
            if time_asix_mess(size(time_asix_mess,1),row) == 0
               data{row,size(A,2)-5}='位置消息-奇';
            else
               data{row,size(A,2)-5}='位置消息-偶';
            end
        case 2
            data{row,size(A,2)-5}='速度消息';
        case 3
            data{row,size(A,2)-5}='ID消息';
    end
    data{row,size(A,2)-4}=planes_id_asix{2,row};%ID消息
    data{row,size(A,2)-3} = mess_112_hex{1,row};
    data{row,size(A,2)-2} = mess_112_hex{2,row};
    data{row,size(A,2)-1} = mess_112_hex{3,row};
    data{row,size(A,2)} = mess_112_hex{4,row};  
end


%接下来开始写入数据
xlswrite(filename,data,sheet,'A2');%写入
end
