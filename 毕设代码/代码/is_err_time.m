function[s] = is_err_time(time)
if isnan(time) %����Ƿ����֣����Ǵ���ģ�����1
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
