

function[s] = is_err_lon(lon)
if isnan(lon) %����Ƿ����֣����Ǵ���ģ�����1
    s=1;
    return;
end
if (lon>180 || lon<-180)   
        s= 1;
    else
        s= 0;
    end
 end