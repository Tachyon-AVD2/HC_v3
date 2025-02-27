function C = HCinputsTemplatev2

    C.s1.Istr = 35; % [kg/m^2] range of 19.55 to 61.89
    C.s1.Cun = 1750; % [kg] 1900 to 2100
    C.s1.mua = 0.1; % range 0.0058 to 0.1151
    C.s1.fsys = 0.20; %0.16 to 0.24
    C.s1.kvv = 0.12; % range 0.12 to 0.15
    C.s1.kvs = 0.02; % curent 0.05 future 0.04
    C.s1.Vun = 7; % [m^3] current 7 future 5
    C.s1.ksup = 0; % 0
    C.s1.kpa = -0.1; % range -0.1 to 0.0  

    C.s2.Istr = 29.65; % [kg/m^2] 29.65 ro 58.23
    C.s2.Cun = 2000; % range 2170 to 4680 
    C.s2.fmnd = 628; % range of 628 to 1412
    %C.s2.Wpay = 29500; 
    C.s2.rpay = 89.19; %range of 50 to 130 
    C.s2.fcrw = 120; %book calls for 140 to 150 but got an average of 120 from data
    C.s2.fprv = 20*16; % this is 20 kg per person time days in space 
    C.s2.kprv = 5; %
    C.s2.kcrw = 1.6; %
    C.s2.mua = 0.07; % range 0.0013 to 0.0759
    C.s2.fsys = 0.20; % range 0.0842 to 0.3198 
    C.s2.kvv = 0.2; % range 0.1 to 0.2 
    C.s2.kvs = 0.05; % curent 0.05 future 0.044
    C.s2.Vun = 7; % [m^3] curent 7 future 5
    C.s2.Ncrw = 7; % [persons]

    EngC1 = [ 1.52, 4.6537, 138.89, 821.19, 0.000011530];
    EngC2 = [  0.9, 4.8401, 138.89, 821.19, 0.000011530];
    

    C.s1.TW = EngC1(1);
    C.s1.WR = EngC1(2);
    C.s1.ETW = EngC1(3);
    C.s1.rppl = EngC1(4);
    C.s1.kve = EngC1(5);

    C.s2.TW = EngC2(1);
    C.s2.WR = EngC2(2);
    C.s2.ETW = EngC2(3);
    C.s2.rppl = EngC2(4);
    C.s2.kve = EngC2(5);

end


