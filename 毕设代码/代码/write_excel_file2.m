function write_excel_file2(time_asix_mess,planes_id)%���������excel�ļ�д��
filename = 'satellite_data.xls';
if size(time_asix_mess,1)==12
A = {'����ʱ��','����ʱ��','�ɻ����','���ı��','���Ĺ���','����','γ��','�߶�','�ٶ�','��ֱ�ٶ�','��������','��ż����','ICAO','ID'};
end
if  size(time_asix_mess,1)==13
A = {'����ʱ��','����ʱ��','�ɻ����','���ı��','����1���Ĺ���','����2���Ĺ���','����','γ��','�߶�','�ٶ�','��ֱ�ٶ�','��������','��ż����','ICAO','ID'};
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
    for col=1:cols-2 %ǰ��cols-2���Ƿɻ����ݣ�����������ID����
        data{row,col}=time_asix_mess(col,row);%�ɻ����ݵ��к����Ƿ��ŵ�
    end
    data{row,12}=planes_id_asix{1,row};%�ɻ���IDҲ��һ��һ�зŵ�
    data{row,13}=planes_id_asix{2,row};
end


%��������ʼд������
xlswrite(filename,data,sheet,'A2');%д��
end
