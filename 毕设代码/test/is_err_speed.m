function[s] = is_err_speed(speed)
if isnan(speed) %如果是非数字，就是错误的，返回1
    s=1;
    return;
end
if (speed>1000 || speed<800)   
        s= 1;
    else
        s= 0;
    end
 end