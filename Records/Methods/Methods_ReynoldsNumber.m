%% Ren
nu = 1E-6; %H2O Re - 5
nu = 1.48E-5; %air Re - 0.3378
L = 5E-4;
u = 1e-2;

Re = u*L/nu;

%% Drag Coefficient - not the correct calculation!

rho = 1E3% H2O;
% rho = 1% air;
u = 5E-2;
A = 5E-4*1E-5;
F_d = 30E-6; % 30 uN,a guess

c_D = 2*F_d / (rho * u^2 * A);