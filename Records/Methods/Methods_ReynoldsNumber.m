%% Reynolds number calculation
nu = 1E-6; %H2O Re - 5
% nu = 1.48E-5; %air Re - 0.3378
L = 5E-4; % Fly ~1/2 a milimeter
% L = 1; % human ~ meter

u = 2e-2;   % velocity of fly
% u = 1;   % velocity of human

Re = u*L/nu;

% Fly air: 10
% Fly water: 0.34
% Human air: 68 E3
% Human water: 1 E6

%% Drag Coefficient - not the correct calculation!

rho = 1E3% H2O;
% rho = 1% air;
u = 5E-2;
A = 5E-4*1E-5;
F_d = 30E-6; % 30 uN,a guess

c_D = 2*F_d / (rho * u^2 * A);