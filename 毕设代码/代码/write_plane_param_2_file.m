function write_plane_param_2_file(time_asix_mess,planes_id, planes_lon,planes_lat)%����������ķɻ���ʼλ����Ϣд��
%��װ���ݾ���
time_asix_mess_cols =size(time_asix_mess,2);%ÿ������������excel�����һ��
data=cell(size(planes_lon,1),9);%ֻ��Ҫ9�����ݣ���Ҫ�ɻ�������
idx =0;
has_process=zeros(1,size(planes_lon,1));
time_asix_mess_rows= size(time_asix_mess,1);%�ɻ����ݵ�����
for i = 1:time_asix_mess_cols%�������еķɻ�
    if time_asix_mess_rows==12 %�����ǵ������ֻ��12������
        for j=1:size(planes_lon,1)
            if  (abs(time_asix_mess(5,i)-planes_lon(j,1))<1e-4)&&(abs(time_asix_mess(6,i)-planes_lat(j,1))<1e-4) %������Ⱥ�ά�ȶ����,˵���ҵ���,--������������ɻ��켣�н��棬�ҽ����պö��Ǳ��Ĳ�����ͻ���BUG������ID/ICAO�ͷɻ�ƥ�䲻�ϡ����ǲ�������ˣ���
                if ~ismember(j,has_process)%�ж�J�Ƿ��Ѵ��ڣ��Ѵ���˵���Ѿ���ȡ���ˡ�ֻ�в����ڲŴ���
                    idx=idx+1;
                    has_process(1,idx)=j;
                    data{idx,1}=planes_lon(j,1);%����
                    data{idx,2}=planes_lat(j,1);%ά��
                    data{idx,3}=planes_id{1,time_asix_mess(2,i)};%ICAO
                    data{idx,4}=planes_id{2,time_asix_mess(2,i)};%ID
                    if (time_asix_mess(8,i)>1022)||(time_asix_mess(9,i)>1022)%������
                    data{idx,5}=round(time_asix_mess(8,i)/4)*4;%�ϱ��ٶ�
                    data{idx,6}=round(time_asix_mess(9,i)/4)*4;%�����ٶ�
                    else
                    data{idx,5}=round(time_asix_mess(8,i));%�ϱ��ٶ�
                    data{idx,6}=round(time_asix_mess(9,i));%�����ٶ�   
                    end
                    data{idx,7}=round(time_asix_mess(10,i)/64)*64;%��ֱ�ٶ�
                    data{idx,8}=roundn(planes_lon(j,1)+rand()*2-1,-4);%����
                    data{idx,9}=roundn(planes_lat(j,1)+rand()*2-1,-4);%ά��
                    break;
                end
            end
        end
    elseif time_asix_mess_rows==13  %else���������ǵ��������13������
        for j=1:size(planes_lon,1)
            if  (abs(time_asix_mess(5,i)-planes_lon(j,1))<1e-4)&&(abs(time_asix_mess(6,i)-planes_lat(j,1))<1e-4) %������Ⱥ�ά�ȶ����,˵���ҵ���,--������������ɻ��켣�н��棬�ҽ����պö��Ǳ��Ĳ�����ͻ���BUG������ID/ICAO�ͷɻ�ƥ�䲻�ϡ����ǲ�������ˣ���
                if ~ismember(j,has_process)%�ж�J�Ƿ��Ѵ��ڣ��Ѵ���˵���Ѿ���ȡ���ˡ�ֻ�в����ڲŴ���
                    idx=idx+1;
                    has_process(1,idx)=j;
                    data{idx,1}=planes_lon(j,1);%����
                    data{idx,2}=planes_lat(j,1);%ά��
                    data{idx,3}=planes_id{1,time_asix_mess(3,i)};%ICAO
                    data{idx,4}=planes_id{2,time_asix_mess(3,i)};%ID
                    if (time_asix_mess(9,i)>1022)||(time_asix_mess(10,i)>1022)%������
                    data{idx,5}=round(time_asix_mess(9,i)/4)*4;%�ϱ��ٶ�
                    data{idx,6}=round(time_asix_mess(10,i)/4)*4;%�����ٶ�
                    else
                    data{idx,5}=round(time_asix_mess(9,i));%�ϱ��ٶ�
                    data{idx,6}=round(time_asix_mess(10,i));%�����ٶ�   
                    end
                    data{idx,7}=round(time_asix_mess(11,i)/64)*64;%��ֱ�ٶ�
                    data{idx,8}=roundn(planes_lon(j,1)+rand()*2-1,-4);%����,ֻ������ʾ
                    data{idx,9}=roundn(planes_lat(j,1)+rand()*2-1,-4);%ά��,ֻ������ʾ
                    break;
                end
            end
        end
    else %else���������ǵ��������14������
        for j=1:size(planes_lon,1)
            if  (abs(time_asix_mess(7,i)-planes_lon(j,1))<1e-4)&&(abs(time_asix_mess(8,i)-planes_lat(j,1))<1e-4) %������Ⱥ�ά�ȶ����,˵���ҵ���,--������������ɻ��켣�н��棬�ҽ����պö��Ǳ��Ĳ�����ͻ���BUG������ID/ICAO�ͷɻ�ƥ�䲻�ϡ����ǲ�������ˣ���
                if ~ismember(j,has_process)%�ж�J�Ƿ��Ѵ��ڣ��Ѵ���˵���Ѿ���ȡ���ˡ�ֻ�в����ڲŴ���
                    idx=idx+1;
                    has_process(1,idx)=j;
                    data{idx,1}=planes_lon(j,1);%����
                    data{idx,2}=planes_lat(j,1);%ά��
                    data{idx,3}=planes_id{1,time_asix_mess(3,i)};%ICAO
                    data{idx,4}=planes_id{2,time_asix_mess(3,i)};%ID
                     if (time_asix_mess(10,i)>1022)||(time_asix_mess(11,i)>1022)%������
                    data{idx,5}=round(time_asix_mess(10,i)/4)*4;%�ϱ��ٶ�
                    data{idx,6}=round(time_asix_mess(11,i)/4)*4;%�����ٶ�
                    else
                    data{idx,5}=round(time_asix_mess(10,i));%�ϱ��ٶ�
                    data{idx,6}=round(time_asix_mess(11,i));%�����ٶ�   
                    end
                    data{idx,7}=round(time_asix_mess(12,i)/64)*64;%��ֱ�ٶ�
                    data{idx,8}=roundn(planes_lon(j,1)+rand()*2-1,-4);%����,ֻ������ʾ
                    data{idx,9}=roundn(planes_lat(j,1)+rand()*2-1,-4);%ά��,ֻ������ʾ
                    break;
                end
            end
        end
    end
    
    if idx==size(planes_lon,1)
        break;
    end
end
if(idx<1)
    return;
end
filename = 'pointInfo.txt';
fid=fopen(filename,'w');
rows = size(data,1);
%����row��
for row = 1:rows
    fprintf(fid,'%3.12f',data{row,1});
    fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
    fprintf(fid,'%3.12f',data{row,2});
    fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
    fprintf(fid,'%s',data{row,3});
    fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
    fprintf(fid,'%s',data{row,4});
    fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
    fprintf(fid,'%3.12f',data{row,5});%�ϱ��ٶ�
    fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
    fprintf(fid,'%3.12f',data{row,6});%�����ٶ�
    fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
    fprintf(fid,'%3.12f',data{row,7});%��ֱ�ٶ�
    fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
    fprintf(fid,'%3.12f',data{row,8});%��ʾ�ľ���
    fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
    fprintf(fid,'%3.12f',data{row,9});%��ʾ��γ��
    fprintf(fid,'%s',';');%ÿ������������;�ֺŷָ�
    fprintf(fid,'\r\n');
end
fclose(fid);
end
