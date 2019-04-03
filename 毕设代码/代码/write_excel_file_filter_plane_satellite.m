function write_excel_file_filter_plane_satellite(time_asix_mess,planes_id, mess_112_hex,ICAO)%���������excel�ļ�д��
filename = 'satellite_data.xls';
if size(time_asix_mess,1)==13
A = {'����ʱ��(s)','����ʱ��(ms)','�ɻ����(ICAO)','���Ĺ���(dbm)','����','γ��','�߶�(Km)','�ϱ��ٶ�(knots)','�����ٶ�(knots)','��ֱ�ٶ�(feet/min)',...
    '��������','ID','��������Ϣ1-28bit','��������Ϣ29-56bit','��������Ϣ57-84bit','��������Ϣ85-112bit'};
end
if  size(time_asix_mess,1)==14
A = {'����ʱ��(s)','����ʱ��(ms)','�ɻ����(ICAO)','����1���Ĺ���(dbm)','����2���Ĺ���(dbm)','����','γ��','�߶�(Km)','�ϱ��ٶ�(knots)','�����ٶ�(knots)','��ֱ�ٶ�(feet/min)',...
    '��������','ID','��������Ϣ1-28bit','��������Ϣ29-56bit','��������Ϣ57-84bit','��������Ϣ85-112bit'};
end
sheet = ICAO;%sheet���ƶ���
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%д���ͷ

%��װ���ݾ���
rows =size(time_asix_mess,2);%ÿ������������excel�����һ��
cols =size(A,2);
target_plane_index=zeros(1,rows);%���ڼ�¼ICAO=Ŀ��ICAO�ķɻ���������
idx =0;
for i = 1:rows%�������еķɻ�
    if planes_id{1,time_asix_mess(3,i)} == ICAO
        idx =idx+1;
        target_plane_index(1,idx) =i;
        ID = planes_id{2,time_asix_mess(3,i)};
    end
end
if(idx<1)
    return;
end
data = cell(idx,cols);%rows*A�е�Ԫ�����飬rows�Ǳ��ĸ���
for row=1:idx %����ÿһ��
    plane_col =target_plane_index(1,row);
    data{row,1}=time_asix_mess(1,plane_col);
    data{row,2} = time_asix_mess(2,plane_col);
    data{row,3} = ICAO;%ICAO
    for col=4:size(A,2)-6%���ʾ�γ���ϱ��ٶȶ����ٶȴ�ֱ�ٶ� 
        data{row,col}=time_asix_mess(col+1,plane_col);%�ɻ����ݵ��к����Ƿ��ŵ�
    end
    switch(time_asix_mess(size(time_asix_mess,1)-1,plane_col))
        case 1 
            if time_asix_mess(size(time_asix_mess,1),plane_col) == 0
               data{row,size(A,2)-5}='λ����Ϣ-��';
            else
               data{row,size(A,2)-5}='λ����Ϣ-ż';
            end
        case 2
            data{row,size(A,2)-5}='�ٶ���Ϣ';
        case 3
            data{row,size(A,2)-5}='ID��Ϣ';
    end
    data{row,size(A,2)-4}=ID;%ID��Ϣ
    data{row,size(A,2)-3} = mess_112_hex{1,plane_col};
    data{row,size(A,2)-2} = mess_112_hex{2,plane_col};
    data{row,size(A,2)-1} = mess_112_hex{3,plane_col};
    data{row,size(A,2)} = mess_112_hex{4,plane_col};  
end
%��������ʼд������
xlswrite(filename,data,sheet,'A2');%д��
end
