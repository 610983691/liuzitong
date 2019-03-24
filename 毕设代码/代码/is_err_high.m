function[s] = is_err_high(high)
if isnan(high) %如果是非数字，就是错误的，返回1
    s=1;
    return;
end
if high~=fix(high) %非整数直接返回
    s=1
    return
end

if (high>12 || high<1)   
        s= 1;
    else
        s= 0;
    end
 end