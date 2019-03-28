function write_excel_file(lon,lat,high)
filename = 'testdata.xls';
A = {'经度','纬度','高度' };
sheet = 1;
xlRange = 'A1';
xlswrite(filename,A,sheet,xlRange);%写入表头
data =[1,2,3;4,5,6];
xlswrite(filename,data,sheet,'A2:C3');%写入
end
