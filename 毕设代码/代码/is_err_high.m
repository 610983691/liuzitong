function[s] = is_err_high(high)
if isnan(high) %����Ƿ����֣����Ǵ���ģ�����1
    s=1;
    return;
end
if high~=fix(high) %������ֱ�ӷ���
    s=1
    return
end

if (high>12 || high<1)   
        s= 1;
    else
        s= 0;
    end
 end