function write_excel_file2(time_asix_mess,planes_id, mess_112_hex)%���������excel�ļ�д��
filename = 'satellite_data.xls';
if size(time_asix_mess,1)==13
A = {'����ʱ��(s)','����ʱ��(ms)','�ɻ����(ICAO)','���Ĺ���(dbm)','����','γ��','�߶�(Km)','�ϱ��ٶ�(knots)','�����ٶ�(knots)','��ֱ�ٶ�(feet/min)',...
    '��������','ID','��������Ϣ1-28bit','��������Ϣ29-56bit','��������Ϣ57-84bit','��������Ϣ85-112bit'};
end
if  size(time_asix_mess,1)==14
A = {'����ʱ��(s)','����ʱ��(ms)','�ɻ����(ICAO)','����1���Ĺ���(dbm)','����2���Ĺ���(dbm)','����','γ��','�߶�(Km)','�ϱ��ٶ�(knots)','�����ٶ�(knots)','��ֱ�ٶ�(feet/min)',...
    '��������','ID','��������Ϣ1-28bit','��������Ϣ29-56bit','��������Ϣ57-84bit','��������Ϣ85-112bit'};
end
sheet = 1;
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%д���ͷ

%��װ���ݾ���
rows =size(time_asix_mess,2);%ÿ������������excel�����һ��
cols =size(A,2);
data = cell(rows,cols);%rows*A�е�Ԫ�����飬rows�Ǳ��ĸ���

planes_id_asix = cell(2,rows);%Id�Ĵ�С2�У��ɻ�����(�ɻ���Ŀ)��Ϊ����
for i = 1:rows%�������еķɻ�
    for j = 1:2
        planes_id_asix{j,i} = planes_id{j,time_asix_mess(3,i)};%���ݷɻ��ı�ţ�ȥ��ȡplane_id�ŵ�planes_id_asix��ߣ�һ���ɻ�����һ��
    end
end

for row=1:rows %����ÿһ��
    data{row,1}=time_asix_mess(1,row);
    data{row,2} = time_asix_mess(2,row);
    data{row,3} = planes_id_asix{1,row};%ICAO
    for col=4:size(A,2)-6%���ʾ�γ���ϱ��ٶȶ����ٶȴ�ֱ�ٶ� 
        data{row,col}=time_asix_mess(col+1,row);%�ɻ����ݵ��к����Ƿ��ŵ�
    end
    switch(time_asix_mess(size(time_asix_mess,1)-1,row))
        case 1 
            if time_asix_mess(size(time_asix_mess,1),row) == 0
               data{row,size(A,2)-5}='λ����Ϣ-��';
            else
               data{row,size(A,2)-5}='λ����Ϣ-ż';
            end
        case 2
            data{row,size(A,2)-5}='�ٶ���Ϣ';
        case 3
            data{row,size(A,2)-5}='ID��Ϣ';
    end
    data{row,size(A,2)-4}=planes_id_asix{2,row};%ID��Ϣ
    data{row,size(A,2)-3} = mess_112_hex{1,row};
    data{row,size(A,2)-2} = mess_112_hex{2,row};
    data{row,size(A,2)-1} = mess_112_hex{3,row};
    data{row,size(A,2)} = mess_112_hex{4,row};  
end


%��������ʼд������
xlswrite(filename,data,sheet,'A2');%д��
end
