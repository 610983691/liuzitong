function[s] = is_not_char_and_num(str)%判断是否为字母和数字
o=regexp(str,'^[0-9a-zA-Z]*$','match');
    if size(o)==1
        s=0;
    else
        s=1;
    end
end
