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

for tau1 = 0.19:0.01:0.32
    Kw1 = 3.404 - 1.427*tau1 + 4.930*tau1^2; 
    for tau2 = 0.18:0.01:0.38
        Kw2 = -93.831*tau2^3 + 58.920*tau2^2 - 5.648*tau2 + 2.821;
        %5.75*tau2 +2.15;
        %-93.831*tau2^3 + 58.920*tau2^2 - 5.648*tau2 + 2.821;
        for Wpay = 29000

        [Spln1, WTOGW1, Wempty1, Vtot1, Spln2, WTOGW2, Wempty2, Vtot2] = ...
            TachyonHC(C, tau1, tau2, Spln1Guess, Spln2Guess,Kw1,Kw2,Wpay);

        tau1_values = [tau1_values, tau1];
        tau2_values = [tau2_values, tau2];
        Spln1_values = [Spln1_values, Spln1];
        WTOGW1_values = [WTOGW1_values, WTOGW1];
        Wempty1_values = [Wempty1_values, Wempty1];
        Wempty2_values = [Wempty2_values, Wempty2];
        Spln2_values = [Spln2_values, Spln2];
        WTOGW2_values = [WTOGW2_values, WTOGW2];
        Splntotal_values = [Splntotal_values, Spln1+Spln2];
        end
    end
end

% Plot Spln1 vs. WTOGW1
figure;
plot(Spln1_values, WTOGW1_values, 'bo', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Spln1'); ylabel('WTOGW1');
title('Spln1 vs WTOGW1');
grid on;

figure;
plot(Spln1_values, Wempty1_values, 'bo', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Spln1'); ylabel('Wempty1');
title('Spln1 vs Wempty1');
grid on;

% Plot Spln2 vs. WTOGW2
figure;
plot(Spln2_values, Wempty2_values, 'ro', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Spln2'); ylabel('Wempty2');
title('Spln2 vs Wempty2');
grid on;

% Plot Spln2 vs. WTOGW2
figure;
plot(Spln2_values, WTOGW2_values , 'ro', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Spln2'); ylabel('WTOGW2');
title('Spln2 vs WTOGW2');
grid on;


% Plot Splntotal vs. WTOGW
figure;
plot(Splntotal_values, WTOGW1_values, 'ro', 'LineWidth', 1.5, 'MarkerSize', 6);
hold on
plot(511, 1558550, 'b*', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Splntotal'); ylabel('WTOGW');
title('Splntotal vs WTOGW');
grid on;