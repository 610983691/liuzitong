function [ppm] = ppmencode(x,Rs,Fs,doppler_f,Fc_mid)
cp = [];
%   ����
for ii = 1:length(x);               
    if x(ii) == 1
        cp = [cp, ones(1, Fs/Rs/2), zeros(1, Fs/Rs/2)];
    else
        cp = [cp, zeros(1, Fs/Rs/2), ones(1, Fs/Rs/2)];
    end
end

%   ��ӱ�ͷ
cp = [ones(1, Fs/Rs/2), zeros(1, Fs/Rs/2), ones(1, Fs/Rs/2), zeros(1,2* Fs/Rs), ones(1, Fs/Rs/2), zeros(1, Fs/Rs/2), ones(1, Fs/Rs/2), zeros(1, 3*Fs/Rs), cp];

%�˲�
t = (0 : 120*Fs/Rs-1)/Fs;
phase = rand(1)*360*pi/180;
%Ƶ�ʶ����Ͷ�����Ƶ��
% car = cos(2*pi*(Fc_mid+doppler_f+((rand(1))*2-1)*10^5)*t+phase );
% ppm = cp.* car;
ppm = cp;

end
