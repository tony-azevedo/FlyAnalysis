%% Using fiji to measure fill from 180806_F2_C1_35C09_leg_fill

% Measure Length from fulcrum to "apophysis".
x_1 = [747.486	180.780	91];
x_2 = [763.206	202.788	84];
norm(x_1-x_2) % 27 um

% Measure Length of apparent 35C09 muscle
% 4	0.000	270	270	270	719.976	183.924	3	72	0	1
% 5	0.000	381	381	381	635.088	226.368	3	43	0	1
x_1 = [719.976	183.924	72]; 
x_2 = [635.088	226.368	43]; 
norm(x_1-x_2) % 99.2394 um LONG! Where did I get this?

% Measure dorsal tip near CHO to femur tip
%1	0.000	548	548	548	185.496	192.570	3	67	0	1
% 2	0.000	693	693	693	772.638	199.644	3	83	0	1
x_1 = [185.496	192.570 67]; 
x_2 = [772.638	199.644	83]; 
norm(x_1-x_2) % 587.4026

%% Using fiji to measure fill from 180807_F1_C1_22A08_leg_fill

% Measure Length from fulcrum to "apophysis".
% 3	0.000	372	372	372	785.214	138.336	1	76	0	4
% 4	0.000	725	725	725	742.770	117.900	1	78	0	4
x_1 = [785.214	138.336	76];
x_2 = [742.770	117.900	78];
norm(x_1-x_2) % 47 um

% Measure Length of distacl reductor fiber
% 5	0.000	1747	1747	1747	738.054	142.266	3	76	0	6
% 6	0.000	804	804	804	716.046	183.138	3	58	0	6
x_1 = [738.054	142.266	76]; 
x_2 = [716.046	183.138	58]; 
norm(x_1-x_2) % 49.7883

% Measure Length of suspected 35C09 fiber
% 13	0.000	1800	1800	1800	727.050	144.624	3	68	0	8
% 14	0.000	856	856	856	696.396	186.282	3	53	0	8
x_1 = [727.050	144.624	68]; 
x_2 = [696.396	186.282	53]; 
norm(x_1-x_2) % 53.8522

% Measure dorsal tip near CHO to femur tip
% 1	0.000	818     818     818     227.154	204.360	2	50	0	2
% 2	0.000	1012	1012	1012	778.926	140.694	2	77	0	2
x_1 = 	[227.154	204.360	50]; 
x_2 =	[778.926	140.694	77]; 
norm(x_1-x_2) % 556.0888

%% Using fiji to measure tibia length from 180702_F1_F1_35C09_iav_leg
% This one had a weird calibration. I changed x dist from 0.248 per pixel
% to 0.786 per pixel

% Tibia length
% Measure fulcrum to approximate position of the probe
% 2	0.000	816	816	816	138.336	65.238	1	53	0	3
% 3	0.000	637	637	637	416.580	379.638	1	64	0	3
x_1 = 	[138.336	65.238	53]; 
x_2 =	[416.580	379.638	64];
norm(x_1-x_2) % 419.9858

% Tibia length
% Measure fulcrum to 
% 2	0.000	816	816	816	138.336	65.238	1	53	0	4
% 4	0.000	518	518	518	449.592	466.884	1	47	0	4
x_1 = 	[138.336	65.238	53]; 
x_2 =	[449.592	466.884	47];
norm(x_1-x_2) % 508.1691

% Measure dorsal tip near CHO to femur tip
% 1	0.000	1257	1257	1257	710.544	147.768	1	92	0	3
% 2	0.000	816	816	816	138.336	65.238	1	53	0	3
x_1 = [710.544	147.768	92]; 
x_2 = [138.336	65.238	53]; 
norm(x_1-x_2) %  579.4430


%% Questions:

% What is the membrane around joints called? How does it attach? Just look
