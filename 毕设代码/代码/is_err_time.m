function[s] = is_err_time(time)
if isnan(time) %如果是非数字，就是错误的，返回1
    s=1;
else
    s=0
end

if (time>60 || time<=0)   
        s= 1;
    else
        s= 0;
    end

end
