%% 
% 

clear
clc
% defining general variables
V_ac = 210; %in ml, acetic acid
V_but = 340; %in ml, butanol
rho_ac = 1.05; %in g/ml
rho_but = 0.81; %in g/ml
M_ac = 60; % Molar mass
M_but = 74;
n_ac = (V_ac*rho_ac)/M_ac; % no. of moles
n_but = (V_but*rho_but)/M_but;
t = (0:10:80);

%For reactor 1:
T_r1 = [100, 100.2, 104, 113.5, 120.1, 123.4, 123.9, 124.2, 124.7];
V_naoh_r1 = [9.1, 8,7.4, 6.3, 5.0, 4.3, 2.2, 1.2, 0.5]; %in ml
n_acid_r1 = 1*V_naoh_r1/1000; %mol of acid in sample neutralised by 1N NaOH
V_sample = 2; %volume of sample in ml
conc_acid_r1 = n_acid_r1*1000/V_sample;
cum_sample = (2:2:18);
water_lost = [0,16.5,15,16,11.5,9.5,5,2.0,1.3] ;%
cum_water_rem_r1 = zeros(1,length(water_lost));
for i=2:9
    cum_water_rem_r1(i) = water_lost(i)+cum_water_rem_r1(i-1);
end
vol_in_r1 = 550-cum_sample-cum_water_rem_r1;
n_acid_reacted_r1 = (vol_in_r1.*conc_acid_r1)/1000;
X1 = (n_ac-n_acid_reacted_r1)/(n_ac)

V_W_naoh = [0,9,7.1,6.1,5.1,4.1,4.4,2.4,1.5];
V_W = 5 % ml
acid_lost = (((1.*V_W_naoh)/V_W).*water_lost) % in millimoles
total_acid_lost=sum(acid_lost)

%For reactor 2:
T_r2 = [98.7, 97.4, 97, 96.9, 96.4, 96.5, 96.5, 96.6, 96.5];
V_naoh_r2 = [9.5, 8.5, 7.2, 6.2, 5.5, 5, 4.6, 4.4, 4.6];
n_acid_r2 = 1*V_naoh_r2/1000;
conc_acid_r2 = n_acid_r2*1000/V_sample;
V_in_r2 = 550-cum_sample;
n_acid_reacted_r2 = (V_in_r2.*conc_acid_r2)/1000;
X2 = (n_ac-n_acid_reacted_r2)/n_ac;

%Enhancement factor:
E = (X1-X2)./X2;

% error analysis


%Plots
plot(t, T_r1,'-o', 'LineWidth', 2)
title('Temperatre of Reactor 1 with time')
ylabel('Reactor Temperature [degC]')
xlabel('Time [min]')

plot(t, T_r2, '-o','LineWidth', 2)
title('Temperatre of Reactor 2 with time')
ylabel('Reactor Temperature [degC]')
xlabel('Time [min]')

plot(t, T_r1, 'LineWidth', 2)
hold on
plot(t, T_r2, 'LineWidth', 2)
title('Reactor Temperatures [degC] v/s Time (min)')
ylabel('Reactor Temperature [degC]')
xlabel('Time [min]')
legend('Reactor 1', 'Reactor 2', 'Location','best')
hold off

plot(t, cum_water_rem_r1, '-x','LineWidth',2)
xlabel('Time [min]')
ylabel('Cumulative Water Removed [mL]')
title('Cumulative water Removed in Reactor v/s Time')


plot(t,X1,'-x','LineWidth',2)
hold on
plot(t,X2,'-x','LineWidth',2)
xlabel('Time [min]')
ylabel('Conversion')
title('Conversion v/s Time')
legend('Reactor 1', 'Reactor 2', 'Location','best')
%ylim([0 1])
hold off

plot(t, E,'-o','LineWidth',2)
hold on
xlabel('Time [min]')
ylabel('Enhancement Factor')
title('Enchancement Factor v/s Time')
hold off



% for Reactor 1

%% 
% Writing to Excel

filename='MT_302.xlsx';
T=table(t',T_r1',water_lost',V_naoh_r1',vol_in_r1',X1');
T.Properties.VariableNames = {'Time','Temperature','Water Lost','NaOH required','Volume remaining','Conversion (X1)'}

writetable(T,filename,'Sheet','reactor 1')

T1=table(t',T_r2',V_naoh_r2',X2');
T1.Properties.VariableNames = {'Time','Temperature','NaOH required','Conversion (X2)'}

writetable(T1,filename,'Sheet','reactor 2')

results = table(t',X1',X2',E');
results.Properties.VariableNames={'Time','Conversion (X1)', 'Conversion (X2)', 'Enhancement Factor'}
writetable(results,filename,'sheet','Results')

%% 
%