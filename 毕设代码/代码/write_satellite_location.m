function write_satellite_location(lon,lat,high)%���ǵľ��ȡ�γ�ȡ��߶�

fid=fopen('wxlocation.txt','w');

fprintf(fid,'%3.12f',lon);
fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
fprintf(fid,'%3.12f',lat);
fprintf(fid,'%s',',');%ÿ�������Զ��ŷָ�,���һ�����ݲ��ָ�
r = high;%����뾶��Ҫ���ݾ�γ�߼��������������㷽����ͯ����ɣ���λ��KM
fprintf(fid,'%3.12f',r);


fclose(fid);
end