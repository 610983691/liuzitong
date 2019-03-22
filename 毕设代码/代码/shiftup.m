function single = shiftup(ppm,Fs,Rs,doppler_f,Fc_mid)
    t = (0 : 120*Fs/Rs-1)/Fs;
phase = rand(1)*360*pi/180;

%频率抖动和多普勒频移
car = cos(2*pi*(Fc_mid+doppler_f+((rand(1))*2-1)*10^5)*t+phase );
single = ppm.* car;
end