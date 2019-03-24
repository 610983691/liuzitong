function[s] = is_err_gl(gl)
if isnan(gl) %如果是非数字，就是错误的，返回1
    s=1;
else
    s=0
end
 end