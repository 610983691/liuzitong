function[s] = is_err_hxj(hxj)
if isnan(hxj) %����Ƿ����֣����Ǵ���ģ�����1
    s=1;
    return;
end
if (hxj>360 || hxj<0)   
        s= 1;
    else
        s= 0;
    end
 end