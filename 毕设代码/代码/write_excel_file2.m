function write_excel_file2(time_asix_mess,planes_id)
filename = 'testdata.xls';
A = {'����ʱ��','����ʱ��','�ɻ����','���ı��','���Ĺ���','����','γ��','�߶�','�ٶ�','��ֱ�ٶ�','��������','��ż����','ICAO','ID'};
sheet = 1;
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%д���ͷ
planes_id_asix = cell(2,size(time_asix_mess,2));
for i = 1:size(time_asix_mess,2)
    for j = 1:2
        planes_id_asix{j,i} = planes_id{j,time_asix_mess(2,i)};
    end
end
data =[1,2,3;4,5,6];
xlswrite(filename,data,sheet,'A2:C3');%д��
end
