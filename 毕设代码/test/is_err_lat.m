
function[s] = is_err_lat(lat)
if isnan(lat) %����Ƿ����֣����Ǵ���ģ�����1
    s=1;
    return;
end
if (lat>90 || lat<-90)   
        s= 1;
    else
        s= 0;
    end
end
 