function write_excel_file(lon,lat,high)
filename = 'testdata.xls';
A = {'����','γ��','�߶�' };
sheet = 1;
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%д���ͷ
data =[1,2,3;4,5,6];
xlswrite(filename,data,sheet,'A2:C3');%д��
end
