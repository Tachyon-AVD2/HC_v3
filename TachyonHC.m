function [Spln1, WTOGW1, Wempty1, Vtot1, Spln2, WTOGW2, Wempty2, Vtot2] = TachyonHC(C,tau1,tau2,Spln1Guess,Spln2Guess,Kw1,Kw2,Wpay)
% Tachyon PS HC Code: In Progress
    Istr1 = C . s1 . Istr;
    %Kw1 = C . s1 . Kw;
    Cun1 = C . s1 . Cun;
    TW1 = C . s1 . TW;
    WR1 = C . s1 . WR; % function input
    ETW1 = C . s1 . ETW;
    mua1 = C . s1 . mua;
    fsys1 = C . s1 . fsys;
    kvv1 = C . s1 . kvv;
    kvs1 = C . s1 . kvs;
    Vun1 = C . s1 . Vun;
    rppl1 = C . s1 . rppl;
    kve1 = C . s1 . kve;
    ksup1 = C . s1 . ksup; % not used
    kpa1 = C . s1 . kpa;

    Istr2 = C . s2 . Istr;
    %Kw2 = C . s2 . Kw;
    Cun2 = C . s2 . Cun;
    fmnd2 = C . s2 . fmnd;
    TW2 = C . s2 . TW;
    WR2 = C . s2 . WR; % function input
    ETW2 = C . s2 . ETW;
    %Wpay = C . s2 . Wpay;
    rpay = C . s2 . rpay;
    fcrw = C . s2 . fcrw;
    fprv = C . s2 . fprv;
    kprv = C . s2 . kprv;
    kcrw = C . s2 . kcrw;
    mua2 = C . s2 . mua;
    fsys2 = C . s2 . fsys;
    kvv2 = C . s2 . kvv;
    kvs2 = C . s2 . kvs;
    Vun2 = C . s2 . Vun;
    rppl2 = C . s2 . rppl;
    kve2 = C . s2 . kve;
    Ncrw = C . s2 . Ncrw;

    Csys2 = Cun2 + fmnd2*Ncrw;
    Wcrw = fcrw*Ncrw;
    Wcprv = fprv*Ncrw;

%% ---------------------------------------------------------------------------------------------------------
           % SECOND STAGE CALCULATIONS
%-----------------------------------------------------------------------------------------------------------
    % symbolic equations to plug Spln2 into Wempty2 and Winert2 equations (once Spln2 is already calculated)
    syms SplnSym2 
    Wempty2sym = (Istr2*Kw2*SplnSym2 + Csys2 + (TW2*WR2/ETW2)*(Wpay + Wcrw) + Wcprv)/...
                    ((1/(1+mua2)) - fsys2 - (TW2*WR2/ETW2));
    Winert2sym = (tau2*SplnSym2^1.5*(1-kvv2-kvs2) - (kprv+kcrw)*Ncrw - Wpay/rpay - Vun2)/...
                        ((WR2-1)/rppl2 + kve2*TW2*WR2);
%-----------------------------------------------------------------------------------------------------------    
    % f2 = @(spln2)((Wempty2) + (Wpay) + (Wcrw) - (Winert2) == 0), converges on spln2
    f2 = @(spln2)(((Istr2*Kw2*spln2 + Csys2 + (TW2*WR2/ETW2)*(Wpay + Wcrw) + Wcprv)/...
                    ((1/(1+mua2)) - fsys2 - (TW2*WR2/ETW2))) + (Wpay) + (Wcrw) ...
                    - ((tau2*spln2^1.5*(1-kvv2-kvs2) - (kprv+kcrw)*Ncrw - Wpay/rpay - Vun2)/...
                        ((WR2-1)/rppl2 + kve2*TW2*WR2)));
%-----------------------------------------------------------------------------------------------------------
    % Second Stage Results
    Spln2 = fzero(f2, Spln2Guess); 
    Wempty2 = double(subs(Wempty2sym, SplnSym2, Spln2));
    Winert2 = double(subs(Winert2sym, SplnSym2, Spln2));
    WTOGW2 = WR2*Winert2;
    Vtot2 = tau2*Spln2^1.5;

%% ---------------------------------------------------------------------------------------------------------
           % FIRST STAGE CALCULATIONS
%-----------------------------------------------------------------------------------------------------------
    if tau1 ~= 0  % if tau1 = 0, then ignore first stage sizing
    
    % symbolic equations to plug Spln1 into Wempty1 and Winert1 equations (once Spln1 is already calculated)
    syms SplnSym1 
    Wempty1sym = (Istr1*Kw1*SplnSym1 + Cun1 + ksup1*WTOGW2 + (TW1*WR1/ETW1)*(WTOGW2))/...
                    ((1/(1+mua1)) - fsys1 - (TW1*WR1/ETW1));
    Winert1sym = (tau1*SplnSym1^1.5*(1-kvv1-kvs1-kpa1) - Vun1)/...
                        ((WR1-1)/rppl1 + kve1*TW1*WR1);
%-----------------------------------------------------------------------------------------------------------    
    % f2 = @(spln1)((Wempty1) + (WTOGW2) - (Winert1) == 0), converges on spln1
    f1 = @(spln1)(((Istr1*Kw1*spln1 + Cun1 + ksup1*WTOGW2 + (TW1*WR1/ETW1)*(WTOGW2))/...
                    ((1/(1+mua1)) - fsys1 - (TW1*WR1/ETW1))) + (WTOGW2) ...
                  - ((tau1*spln1^1.5*(1-kvv1-kvs1-kpa1) - Vun1)/...
                        ((WR1-1)/rppl1 + kve1*TW1*WR1)));
%-----------------------------------------------------------------------------------------------------------
    % First Stage Results
    Spln1 = fzero(f1, Spln1Guess);
    Wempty1 = double(subs(Wempty1sym, SplnSym1, Spln1));
    Winert1 = double(subs(Winert1sym, SplnSym1, Spln1));
    WTOGW1 = WR1*Winert1;
    Vtot1 = tau1*Spln1^1.5;
    else
        Spln1=0; WTOGW1=0; Wempty1=0; Vtot1=0; 
    end
end