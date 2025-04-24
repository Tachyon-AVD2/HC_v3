clc; clear; close all; format compact; format longg;

C = HCinputsTemplatev2;

Spln1Guess = 600;
Spln2Guess = 300;

tau1_values = [];
tau2_values = [];
Spln1_values = [];
WTOGW1_values = [];
Spln2_values = [];
WTOGW2_values = [];
Splntotal_values = [];
Wempty1_values = [];
Wempty2_values = [];
Vtot2_values = []; 
Kw2_values = []; 
Vtot1_values  = [];
Kw1_values    = [];

for tau1 = 0.26
    Kw1 = 3.404 - 1.427*tau1 + 4.930*tau1^2; 
    for tau2 = 0.20

       
        %0.18:0.01:0.38
        Kw2 = -93.831*tau2^3 + 58.920*tau2^2 - 5.648*tau2 + 2.821;
        % Another possible version could be: Kw2 = 5.75*tau2 + 2.15;
        
        for Wpay = 29000
            [Spln1, WTOGW1, Wempty1, Vtot1, Spln2, WTOGW2, Wempty2, Vtot2] = ...
                TachyonHC(C, tau1, tau2, Spln1Guess, Spln2Guess, Kw1, Kw2, Wpay);

            % Store the outputs in the arrays
            tau1_values      = [tau1_values,   tau1];
            tau2_values      = [tau2_values,   tau2];
            Spln1_values     = [Spln1_values,  Spln1];
            WTOGW1_values    = [WTOGW1_values, WTOGW1];
            Wempty1_values   = [Wempty1_values, Wempty1];
            Wempty2_values   = [Wempty2_values, Wempty2];
            Spln2_values     = [Spln2_values,  Spln2];
            WTOGW2_values    = [WTOGW2_values, WTOGW2];
            Splntotal_values = [Splntotal_values, Spln1 + Spln2];
            Vtot2_values     = [Vtot2_values,  Vtot2];
            Vtot1_values     = [Vtot1_values,  Vtot1];
            Kw2_values       = [Kw2_values,    Kw2];
            Kw1_values       = [Kw1_values,    Kw1];
        end
    end
end




% Print out the best stage 1 values:
fprintf(' VERSION 3\n')
fprintf('tau1    = %.2f               tau2       = %.2f\n', tau1_values,tau2_values);
fprintf('WTOGW1  = %.2f kg      WTOGW2     = %.2f kg\n', WTOGW1_values,WTOGW2_values);
fprintf('Spln1   =    %.2f m^2      Spln2      =   %.2f m^2\n', Spln1_values,Spln2_values);  % "Soln1" corresponds to Spln1 for stage 1
fprintf('Vtot1   =   %.2f m^3      Vtot2      =  %.2f m^3\n', Vtot1_values,Vtot2_values);
fprintf('Wempty1 =   %.2f kg      Wempty2    = %.2f  kg\n', Wempty1_values,Wempty2_values);
fprintf('Kw1     =   %.4f           Kw2        = %.4f\n', Kw1_values,Kw2_values);

%% Weight

W_str1 = C.s1.Istr * Kw1_values * Spln1_values;
W_eng1 = ((C.s1.TW * C.s1.WR)/C.s1.ETW )*(Wempty1_values+391293.9729);
W_sys1 = C.s1.fsys*Wempty1_values + C.s1.Cun ;
W_crew = C.s2.fcrw*C.s2.Ncrw;

%sanity check
W_empty1_verification = (1+C.s1.mua)*(W_str1+W_eng1+W_sys1);

%% Volume
W_inert1 = Wempty1_values + WTOGW2_values;

V_ppl1 = W_inert1 * (C.s1.WR - 1)/C.s1.rppl;
V_sys1 = C.s1.Vun + (C.s1.kvs * Vtot1_values);
V_eng1 = C.s1.kve * C.s1.TW * C.s1.WR * W_inert1;
V_void1 = C.s1.kvv * Vtot1_values;
V_pa1 = C.s1.kpa * Vtot1_values;

V_total1_verification = V_ppl1 + V_sys1 + V_eng1 + V_void1 + V_pa1;

%% Weight

W_str2 = C.s2.Istr * Kw2_values * Spln2_values;
W_eng2 = ((C.s2.TW * C.s2.WR)/C.s2.ETW )*(Wempty2_values+Wpay+(C.s2.Ncrw*C.s2.fcrw));
W_sys2 = C.s2.fsys*Wempty2_values + C.s2.Cun + C.s2.fmnd*C.s2.Ncrw;
W_cprv2 = C.s2.fprv * C.s2.Ncrw;

%sanity check
W_empty2 = (1+C.s2.mua)*(W_str2+W_eng2+W_cprv2+W_sys2);

%% Volume
W_inert2 = Wempty2_values + Wpay + (C.s2.Ncrw*C.s2.fcrw);

V_ppl2 = W_inert2 * (C.s2.WR - 1)/C.s2.rppl;
V_sys2 = C.s2.Vun + (C.s2.kvs*Vtot2_values);
V_eng2 = C.s2.kve*C.s2.TW*C.s2.WR*W_inert2;
V_void2 = C.s2.kvv*Vtot2_values;
V_crew2 = (C.s2.kprv + C.s2.kcrw)*C.s2.Ncrw;
V_pay = Wpay/C.s2.rpay;

Vcrew_quarters = (10*C.s2.Ncrw); 
V_total2_verification = V_ppl2 + V_sys2 + V_eng2 + V_void2 + V_pay + V_crew2 + Vcrew_quarters;

fprintf('W_str1  =  %.2f kg       W_str2     =   %.2f kg\n', W_str1,W_str2);
fprintf('W_eng1  =  %.2f kg       W_eng2     =  %.2f kg\n', W_eng1,W_eng2);
fprintf('W_sys1  =  %.2f kg       W_sys2     = %.2f kg\n', W_sys1,W_sys2);
fprintf('                             W_crew     =  %.2f kg\n', W_crew);
fprintf('                             W_cprv2    =  %.2f kg\n', W_cprv2);
fprintf('V_ppl1  =  %.2f m^3       V_ppl2     = %.2f m^3\n', V_ppl1,V_ppl2);
fprintf('V_sys1  =    %.2f m^3       V_sys2     =  %.2f m^3\n', V_sys1,V_sys2);
fprintf('V_eng1  =    %.2f m^3       V_eng2     =   %.2f m^3\n', V_eng1,V_eng2);
fprintf('V_void1 =   %.2f m^3       V_void2    = %.2f m^3\n', V_void1,V_void2);
fprintf('V_pa1   =  %.2f m^3\n', V_pa1);
fprintf('                             V_crew2    =  %.2f m^3\n', V_crew2);
fprintf('                             V_pay      = %.2f m^3\n', V_pay);
fprintf('                             Vquarters  =  %.2f m^3\n', Vcrew_quarters);
