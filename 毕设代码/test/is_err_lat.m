
function[s] = is_err_lat(lat)
if isnan(lat) %如果是非数字，就是错误的，返回1
    s=1;
    return;
end
if (lat>90 || lat<-90)   
        s= 1;
    else
        s= 0;
    end
end
 