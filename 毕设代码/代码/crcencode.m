 function mess = crcencode(heading,code)
mss = [heading,code];
gen_poly = [1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,1,0,0,1];
mss = [mss,zeros(1,24)];
R = mss;
for k = 1:88
    add_zeros = zeros(1,88-k);
    P = [gen_poly,add_zeros];
    if R(1) == 0
        P = zeros(1,length(P));
    end
    R = bitxor(P,R);
    P = gen_poly;
    R(1) = [];
end
mess = [heading,code,R];
 end


             
            
         
         