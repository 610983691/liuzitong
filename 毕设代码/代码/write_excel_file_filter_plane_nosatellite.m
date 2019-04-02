function write_excel_file_filter_plane_nosatellite(time_asix_mess,planes_id,mess_112_hex,ICAO)%���������excel�ļ�д��,���ӵ��ɻ�������
filename = 'no_satellite_data.xls';
A = {'����ʱ��(ms)','�ɻ����(ICAO)','���Ĺ���(dbm)','����','γ��','�߶�(Km)','�ϱ��ٶ�(knots)','�����ٶ�(knots)','��ֱ�ٶ�(feet/min)',...
    '��������','ID','��������Ϣ1-28bit','��������Ϣ29-56bit','��������Ϣ57-84bit','��������Ϣ85-112bit'};
sheet = ICAO;%sheet���ƶ���
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%д���ͷ
%��װ���ݾ���
rows =size(time_asix_mess,2);%ÿ������������excel�����һ��

target_plane_index=zeros(1,rows);%���ڼ�¼ICAO=Ŀ��ICAO�ķɻ���������
idx =0;
for i = 1:rows%�������еķɻ�
    if planes_id{1,time_asix_mess(2,i)} == ICAO
        idx =idx+1;
        target_plane_index(1,idx) =i;
        ID = planes_id{2,time_asix_mess(2,i)};
    end
end
if(idx<1)
    return;
end

data = cell(idx,15);%rows*13�е�Ԫ�����飬rows�Ǳ��ĸ���
for row=1:idx %����ÿһ��
    plane_col =target_plane_index(1,row);
    data{row,1}=time_asix_mess(1,plane_col);
    data{row,2} = ICAO;%ICAO
    for col=3:9
        data{row,col}=time_asix_mess(col+1,plane_col);%�ɻ����ݵ��к����Ƿ��ŵ�
    end
    switch(time_asix_mess(11,plane_col))
        case 1 
            if time_asix_mess(12,plane_col) == 0
               data{row,10}='λ����Ϣ-��';
            else
               data{row,10}='λ����Ϣ-ż';
            end
        case 2
            data{row,10}='�ٶ���Ϣ';
        case 3
            data{row,10}='ID��Ϣ';
    end
    data{row,11}=ID;%ID��Ϣ
    data{row,12} = mess_112_hex{1,plane_col};
    data{row,13} = mess_112_hex{2,plane_col};
    data{row,14} = mess_112_hex{3,plane_col};
    data{row,15} = mess_112_hex{4,plane_col};  
end
%��������ʼд������
xlswrite(filename,data,sheet,'A2');%д��


end
