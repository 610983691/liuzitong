function write_lat_data_2_file(latdata)

fid=fopen('latData.txt','w');
rows = size(latdata,1);
columns = size(latdata,2);
%����row��
for row = 1:rows
    one_row_data= latdata(row,:);%��ȡ��i�е�����
    for col = 1:columns
        data=one_row_data(1,col);%��ȡһ��γ������
        fprintf(fid,'%3.12f',data);
        if col~=columns
            fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
        end
    end
    fprintf(fid,'%s',';');%ÿ������������;�ֺŷָ�
    fprintf(fid,'\r\n');
end
fclose(fid);
end