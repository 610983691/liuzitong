function planes_id = ID_creat(N)
%     N = 5;
    planes_id = cell(2,N);%第一行是ICAO，第二行是ID
    character_select = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N',...
                    'O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1',...
                    '2','3','4','5','6','7','8','9',' '};
    icao = randperm(2^24,N)-1;
    for i = 1:N
       a= dec2hex(icao(i),6);
       planes_id{1,i} = a;
    end
    plane_ID =cell(N,8);
    select1 = unidrnd(36,N,8);
    for i = 1:N
       for j = 1:8
           plane_ID{i,j} = character_select(select1(i,j));
       end
       planes_id{2,i}= strcat(plane_ID{i,1},plane_ID{i,2},plane_ID{i,3},plane_ID{i,4},plane_ID{i,5},plane_ID{i,6},plane_ID{i,7},plane_ID{i,8});
       planes_id{2,i} = cell2mat(planes_id{2,i});
    end
end
