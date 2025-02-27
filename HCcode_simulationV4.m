clc; clear; close all; format compact; format longG;

%% Load constants
C = HCinputsTemplatev2;

% Initial guesses for planform area sizing:
Spln1Guess = 600;
Spln2Guess = 300;

%% Define ranges for the iterative variables here (helps later when tracking code progress)
tau1_range = 0.19:0.01:0.32;
tau2_range = 0.18:0.01:0.38;
Wpay_range = 10000:1000:30000; 

% Define ranges for structural index
Istr1_range = 20:5:60;   % Stage 1 Istr [kg/m^2] (nominal ~35, range: 19.55 to 61.89)
Istr2_range = 30:5:60;   % Stage 2 Istr [kg/m^2] (nominal ~29.65, range: 29.65 to 58.23)

%% Calculate the total number of iterations for progress tracking:
nofns = length(Istr1_range) * length(Istr2_range) * length(tau1_range) * length(tau2_range) * length(Wpay_range);

%% Initialize an empty struct array to store all results:
results(nofns) = struct('Istr1', [], 'Istr2', [], 'tau1', [], 'tau2', [], 'Wpay', [], ...
    'Spln1', [], 'WTOGW1', [], 'Wempty1', [], 'Vtot1', [], ...
    'Spln2', [], 'WTOGW2', [], 'Wempty2', [], 'Vtot2', [], ...
    'Splntotal', []);

n = 0;   % For progress tracking
cnt = 1; % Counter for results

%% Nested loops over Istr, tau1, tau2, and Wpay
for Istr1 = Istr1_range
    C.s1.Istr = Istr1;  % Update stage 1 structural index
    for Istr2 = Istr2_range
        C.s2.Istr = Istr2;  % Update stage 2 structural index
        for tau1 = tau1_range
            Kw1 = 3.404 - 1.427*tau1 + 4.930*tau1^2; 
            for tau2 = tau2_range
                Kw2 = -93.831*tau2^3 + 58.920*tau2^2 - 5.648*tau2 + 2.821;
                for Wpay = Wpay_range
                    [Spln1, WTOGW1, Wempty1, Vtot1, ...
                     Spln2, WTOGW2, Wempty2, Vtot2] = ...
                        TachyonHC(C, tau1, tau2, Spln1Guess, Spln2Guess, Kw1, Kw2, Wpay);
                    
                    % Store outputs along with the current input values
                    results(cnt).Istr1      = Istr1;
                    results(cnt).Istr2      = Istr2;
                    results(cnt).tau1       = tau1;
                    results(cnt).tau2       = tau2;
                    results(cnt).Wpay       = Wpay;
                    results(cnt).Spln1      = Spln1;
                    results(cnt).WTOGW1     = WTOGW1;
                    results(cnt).Wempty1    = Wempty1;
                    results(cnt).Vtot1      = Vtot1;
                    results(cnt).Spln2      = Spln2;
                    results(cnt).WTOGW2     = WTOGW2;
                    results(cnt).Wempty2    = Wempty2;
                    results(cnt).Vtot2      = Vtot2;
                    results(cnt).Splntotal  = Spln1 + Spln2;
                    
                    cnt = cnt + 1;
                    n = n + 1;
                    PercentComplete = (n / nofns)*100
                    % Display progress
                    if mod(n, round(nofns/20)) == 0
    fprintf('Progress: %.2f%%\n', (n / nofns) * 100);
                    end

                end
            end
        end
    end
end

%% Data extraction for plotting

% --- For original plots, filter for payload = 29,000 kg (can be changed) ---
isPayload = [results.Wpay] == 29000;
results_pay = results(isPayload);

% Extract fields for the payload-variable plots:
Spln1_vals    = [results_pay.Spln1];
WTOGW1_vals   = [results_pay.WTOGW1];
Wempty1_vals  = [results_pay.Wempty1];
Spln2_vals    = [results_pay.Spln2];
WTOGW2_vals   = [results_pay.WTOGW2];
Wempty2_vals  = [results_pay.Wempty2];
Splntotal_vals = [results_pay.Splntotal];

% Also extract Istr values (for sensitivity plots) from the payload=29000 subset:
Istr1_vals = [results_pay.Istr1];
Istr2_vals = [results_pay.Istr2];

% --- For plots that consider all payload values ---
Wpay_all    = [results.Wpay];
WTOGW1_all  = [results.WTOGW1];
WTOGW2_all  = [results.WTOGW2];
Spln2_all   = [results.Spln2];
Wempty2_all = [results.Wempty2];

%% Define common style parameters
fontName      = 'Arial';
titleFontSize = 16;
labelFontSize = 14;
axisFontSize  = 12;
markerSize    = 60;
bgColor       = 'w';  % White background for figures

%% Original Scatter Plots for Payload = 29,000 kg

% Plot 1: Spln1 vs. WTOGW1 (Payload = 29,000 kg)
figure;
scatter(Spln1_vals, WTOGW1_vals, markerSize, 'MarkerEdgeColor','k','MarkerFaceColor','b');
xlabel('Spln1', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('WTOGW1', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Spln1 vs. WTOGW1 (Payload = 29,000 kg)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);

% Plot 2: Spln1 vs. Wempty1 (Payload = 29,000 kg)
figure;
scatter(Spln1_vals, Wempty1_vals, markerSize, 'MarkerEdgeColor','k','MarkerFaceColor','m');
xlabel('Spln1', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('Wempty1', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Spln1 vs. Wempty1 (Payload = 29,000 kg)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);

% Plot 3: Splntotal vs. WTOGW1 (Payload = 29,000 kg)
figure;
scatter(Splntotal_vals, WTOGW1_vals, markerSize, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.85, 0.33, 0.10]);
hold on;
plot(511, 1558550, 'bp', 'MarkerSize', markerSize/2, 'LineWidth', 2);
xlabel('Splntotal', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('WTOGW1', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Splntotal vs. WTOGW1 (Payload = 29,000 kg)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);
hold off;

% Plot 4: WTOGW1 vs. Wpay (All payload values) with a 20% x-axis buffer, markers only
minW = min(Wpay_all);
maxW = max(Wpay_all);
rangeW = maxW - minW;
xLimits = [minW - 0.2*rangeW, maxW + 0.2*rangeW];

figure;
plot(Wpay_all, WTOGW1_all, 'o', 'LineWidth', 2, 'MarkerSize', 8, ...
     'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0, 0.4470, 0.7410]);
xlabel('Payload, Wpay (kg)', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('WTOGW1', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('WTOGW1 vs. Wpay', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
xlim(xLimits);
set(gcf, 'Color', bgColor);

% Plot 5: WTOGW2 vs. Wpay (All payload values) with a 20% x-axis buffer, markers only
figure;
plot(Wpay_all, WTOGW2_all, 'o', 'LineWidth', 2, 'MarkerSize', 8, ...
     'MarkerEdgeColor', 'k', 'MarkerFaceColor', [0.8500, 0.3250, 0.0980]);
xlabel('Payload, Wpay (kg)', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('WTOGW2', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('WTOGW2 vs. Wpay', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
xlim(xLimits);
set(gcf, 'Color', bgColor);

% Plot 6: Spln2 vs. Wempty2 (All payloads) with payload as color
figure;
scatter([results.Spln2], [results.Wempty2], markerSize, [results.Wpay], 'filled'); 
xlabel('Spln2', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('Wempty2', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Spln2 vs. Wempty2 (All Payloads)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
colormap(jet);
colorbar;
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);

% Plot 7: Spln2 vs. WTOGW2 (All payloads) with payload as color
figure;
scatter([results.Spln2], [results.WTOGW2], markerSize, [results.Wpay], 'filled'); 
xlabel('Spln2', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('WTOGW2', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Spln2 vs. WTOGW2 (All Payloads)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
colormap(parula);
colorbar;
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);

%% New Plots: Effect of Istr on TOGW and Spln for Both Stages (Payload = 29,000 kg)
% For Stage 1:
figure;
scatter(Istr1_vals, [results_pay.WTOGW1], markerSize, 'MarkerEdgeColor','k','MarkerFaceColor','c');
xlabel('I_{str1} (kg/m^2)', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('WTOGW1', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Effect of I_{str1} on WTOGW1 (Payload = 29,000 kg)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);

figure;
scatter(Istr1_vals, Spln1_vals, markerSize, 'MarkerEdgeColor','k','MarkerFaceColor','g');
xlabel('I_{str1} (kg/m^2)', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('Spln1', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Effect of I_{str1} on Spln1 (Payload = 29,000 kg)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);

% For Stage 2:
figure;
scatter(Istr2_vals, [results_pay.WTOGW2], markerSize, 'MarkerEdgeColor','k','MarkerFaceColor','y');
xlabel('I_{str2} (kg/m^2)', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('WTOGW2', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Effect of I_{str2} on WTOGW2 (Payload = 29,000 kg)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);

figure;
scatter(Istr2_vals, Spln2_vals, markerSize, 'MarkerEdgeColor','k','MarkerFaceColor','r');
xlabel('I_{str2} (kg/m^2)', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
ylabel('Spln2', 'FontWeight', 'bold', 'FontSize', labelFontSize, 'FontName', fontName);
title('Effect of I_{str2} on Spln2 (Payload = 29,000 kg)', 'FontWeight', 'bold', 'FontSize', titleFontSize, 'FontName', fontName);
grid on; grid minor;
set(gca, 'FontSize', axisFontSize, 'FontName', fontName);
set(gcf, 'Color', bgColor);
