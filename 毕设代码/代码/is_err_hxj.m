function[s] = is_err_hxj(hxj)
if isnan(hxj) %如果是非数字，就是错误的，返回1
    s=1;
    return;
end
if (hxj>360 || hxj<0)   
        s= 1;
    else
        s= 0;
    end
 end