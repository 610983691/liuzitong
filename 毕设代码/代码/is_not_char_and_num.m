function[s] = is_not_char_and_num(str)%�ж��Ƿ�Ϊ��ĸ������
o=regexp(str,'^[0-9a-zA-Z]*$','match');
    if size(o)==1
        s=0;
    else
        s=1;
    end
end
