function write_excel_file1(time_asix_mess,planes_id)%���������excel�ļ�д��
filename = 'testdata.xls';
A = {'����ʱ��','�ɻ����','���ı��','���Ĺ���','����','γ��','�߶�','�ٶ�','��ֱ�ٶ�','��������','��ż����','ICAO','ID'};
sheet = 1;
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%д���ͷ
%��װ���ݾ���
rows =size(time_asix_mess,2);%ÿ���ɻ�������excel�����һ��
data = cell(rows,13);%rows*13�е�Ԫ�����飬rows�Ƿɻ�����

planes_id_asix = cell(2,rows);%Id�Ĵ�С2�У��ɻ�����(�ɻ���Ŀ)��Ϊ����
for i = 1:rows%�������еķɻ�
    for j = 1:2
        planes_id_asix{j,i} = planes_id{j,time_asix_mess(2,i)};%���ݷɻ��ı�ţ�ȥ��ȡplane_id�ŵ�planes_id_asix��ߣ�һ���ɻ�����һ��
    end
end

for row=1:rows %����ÿһ��
    for col=1:11
        data{row,col}=time_asix_mess(col,row);%�ɻ����ݵ��к����Ƿ��ŵ�
    end
    data{row,12}=planes_id_asix(col,1);%�ɻ���IDҲ��һ��һ�зŵ�
    data{row,13}=planes_id_asix(col,2);
end


%��������ʼд������
xlswrite(filename,data,sheet,'A2');%д��
end
