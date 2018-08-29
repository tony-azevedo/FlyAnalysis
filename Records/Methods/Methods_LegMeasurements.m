%% Using fiji to measure fill from 180806_F2_C1_35C09_leg_fill

% Measure Length from fulcrum to "apophysis".

x_1 = [747.486	180.780	91];
x_2 = [763.206	202.788	84];
norm(x_1-x_2) % 27 um

% Measure Length of apparent 35C09 muscle

x_1 = [719.976	183.924	72]; % 4	0.000	270	270	270	719.976	183.924	3	72	0	1
x_2 = [635.088	226.368	43]; % 5	0.000	381	381	381	635.088	226.368	3	43	0	1
norm(x_1-x_2) % 99.2394 um

% Measure dorsal tip near CHO to femur tip
x_1 = [185.496	192.570 67]; %1	0.000	548	548	548	185.496	192.570	3	67	0	1
x_2 = [772.638	199.644	83]; % 2	0.000	693	693	693	772.638	199.644	3	83	0	1
norm(x_1-x_2) % 587.4026


%% Questions:

% What is the membrane around joints called? How does it attach? Just look
