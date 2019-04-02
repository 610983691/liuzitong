function write_excel_file1(time_asix_mess,planes_id,mess_112_hex)%���������excel�ļ�д��
delete('no_satellite_data.xls');
filename = 'no_satellite_data.xls';
A = {'����ʱ��(ms)','�ɻ����(ICAO)','���Ĺ���(dbm)','����','γ��','�߶�(Km)','�ϱ��ٶ�(knots)','�����ٶ�(knots)','��ֱ�ٶ�(feet/min)',...
    '��������','ID','��������Ϣ1-28bit','��������Ϣ29-56bit','��������Ϣ57-84bit','��������Ϣ85-112bit'};
sheet = 1;
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%д���ͷ
%��װ���ݾ���
rows =size(time_asix_mess,2);%ÿ������������excel�����һ��
data = cell(rows,15);%rows*13�е�Ԫ�����飬rows�Ǳ��ĸ���

planes_id_asix = cell(2,rows);%Id�Ĵ�С2�У��ɻ�����(�ɻ���Ŀ)��Ϊ����
for i = 1:rows%�������еķɻ�
    for j = 1:2
        planes_id_asix{j,i} = planes_id{j,time_asix_mess(2,i)};%���ݷɻ��ı�ţ�ȥ��ȡplane_id�ŵ�planes_id_asix��ߣ�һ���ɻ�����һ��
    end
end

for row=1:rows %����ÿһ��
    data{row,1}=time_asix_mess(1,row);
    data{row,2} = planes_id_asix{1,row};%ICAO
    for col=3:9
        data{row,col}=time_asix_mess(col+1,row);%�ɻ����ݵ��к����Ƿ��ŵ�
    end
    switch(time_asix_mess(11,row))
        case 1 
            if time_asix_mess(12,row) == 0
               data{row,10}='λ����Ϣ-��';
            else
               data{row,10}='λ����Ϣ-ż';
            end
        case 2
            data{row,10}='�ٶ���Ϣ';
        case 3
            data{row,10}='ID��Ϣ';
    end
    data{row,11}=planes_id_asix{2,row};%ID��Ϣ
    data{row,12} = mess_112_hex{1,row};
    data{row,13} = mess_112_hex{2,row};
    data{row,14} = mess_112_hex{3,row};
    data{row,15} = mess_112_hex{4,row};  
end
%��������ʼд������
xlswrite(filename,data,sheet,'A2');%д��
end
