% Shortest probe (units of .1 mg)
Probe1  = [
    0   0
    100 45
    200 96
    300 150
    400 200
    500 250
    25  12
    50  24
    75  40
    100 52
    125 65
    150 79
    175 91
    200 105
    225 120
    250 134
    25  13
    50  26
    75  38
    100 53
    125 65
    150 80
    175 91
    200 106
    225 118
    250 133];

% Next shortest probe (green material, nearly as long as pink probe)
Probe2 = [
    0   -8   -13 0   -1
    100 0   -4  7   6
    200 7   5   16  16
    300 16  11  25  24  
    400 25  21  33  33
    500 33  30  40  NaN
    600 38  38  nan NaN
    700 45  45  nan NaN
    800 54  50  nan NaN
    900 64  65  nan NaN
    1000    70  73  nan NaN];

Probe2(:,2) = Probe2(:,2)-Probe2(1,2);
Probe2(:,3) = Probe2(:,3)-Probe2(1,3);
Probe2(:,5) = Probe2(:,5)-Probe2(1,5);
Probe2 = [
    Probe2(:,1) Probe2(:,2);
    Probe2(:,1) Probe2(:,3);
    Probe2(:,1) Probe2(:,4);
    Probe2(:,1) Probe2(:,5);
    ];
Probe2 = Probe2(~isnan(Probe2(:,2)),:);
    
% Probe3: Original pink probe
Probe3 = [
    0  0    0   0
    100 7   7   6
    200 15  15  14
    300 23  23  21
    400 30  30  28
    500 38  39  35
    600 46  46  38  
    700 55  52  NaN
    800 62  60  NaN
    900 69  68  68
    1000 77 79  79
    ];

Probe3 = [
    Probe3(:,1) Probe3(:,2);
    Probe3(:,1) Probe3(:,3);
    Probe3(:,1) Probe3(:,4);
    ];
Probe3 = Probe3(~isnan(Probe3(:,2)),:);

Probe4 = [
    0   0   NaN NaN -4  0   NaN
    50  10  NaN NaN 8   12  11
    100 21  NaN 25  20  24  21
    150 28  20  NaN NaN 36  35   
    200 40  42  49  44  48  45
    250 54  53  NaN NaN 60  59
    300 65  65  74  67  72  66
    350 75  76  nan NaN 77  76
    400 84  84  94  92  93  87
    450 94  90  nan NaN 102 104
    500 107 106 124 111 116 112
    600 NaN NaN 140 137 130 131
    700 NaN NaN 161 161 152 162
    800 NaN NaN 188 NaN 178 NaN];

Probe4(:,2) = Probe4(:,2)-Probe4(1,2);
Probe4(:,3) = Probe4(:,3)-Probe4(1,3);
Probe4(:,5) = Probe4(:,5)-Probe4(1,5);
Probe4(:,6) = Probe4(:,6)-Probe4(1,6);
Probe4(:,7) = Probe4(:,7)-Probe4(1,7);
Probe4 = [
    Probe4(:,1) Probe4(:,2);
    Probe4(:,1) Probe4(:,3);
    Probe4(:,1) Probe4(:,4);
    Probe4(:,1) Probe4(:,5);
    Probe4(:,1) Probe4(:,6);
    ];
Probe4 = Probe4(~isnan(Probe4(:,2)),:);
Probe4(:,1) = Probe4(:,1)*1E-6;
Probe4(:,2) = Probe4(:,2)*1E-7; % kg

k = polyfit(Probe4(:,1),(Probe4(:,2)*9.8),1)

%%
figure
% plot(Probe1(:,1),Probe1(:,2),'.','displayName','Probe1');
hold on
% plot(Probe2(:,1),Probe2(:,2),'.','displayName','Probe2');
% plot(Probe3(:,1),Probe3(:,2),'.','displayName','Probe3');
plot(Probe4(:,1),Probe4(:,2)*9.8,'.','displayName','Probe4');
plot(Probe4(:,1),k(1)*Probe4(:,1)+k(2))

legend toggle
xlabel('m')
ylabel('N')