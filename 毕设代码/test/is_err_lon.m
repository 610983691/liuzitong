

function[s] = is_err_lon(lon)
if isnan(lon) %如果是非数字，就是错误的，返回1
    s=1;
    return;
end
if (lon>180 || lon<-180)   
        s= 1;
    else
        s= 0;
    end
 end