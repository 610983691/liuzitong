function planes_id = ID_creat(N)
N =2;
    planes_id = cell(2,N);%第一行是ICAO，第二行是ID
    character_select = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N',...
                    'O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1',...
                    '2','3','4','5','6','7','8','9',' '};
    plane_ICAO = cell(N,4);
    select2 = unidrnd(26,N,4);
for i = 1:N
    for j = 1:4
       plane_ICAO{i,j} = character_select(select2(i,j));
    end
    planes_id{1,i}= strcat(plane_ICAO{i,1},plane_ICAO{i,2},plane_ICAO{i,3},plane_ICAO{i,4});
end


    plane_ID =cell(N,8);
    select1 = unidrnd(37,N,8);
    for i = 1:N
       for j = 1:8
           plane_ID{i,j} = character_select(select1(i,j));
       end
       planes_id{2,i}= strcat(plane_ID{i,1},plane_ID{i,2},plane_ID{i,3},plane_ID{i,4},plane_ID{i,5},plane_ID{i,6},plane_ID{i,7},plane_ID{i,8});
    end
end

