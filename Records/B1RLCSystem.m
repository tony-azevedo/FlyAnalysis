function out = B1RLCSystem(I,T,varargin)


dt = 0.00001; % s (dt = 0.01ms)
if length(T) == 1
    T = ceil(T/dt); %T  = ceil(T0/dt);
    T = (1:T-1)';
    T = T*dt;
else
    T = T(:);
    dt = T(2)-T(1);
end
if length(I) == 1
    I = ones(size(T)) * I; %T  = ceil(T0/dt);
end

% Z = (1/R + j2pif C)-1  = 1/(gL +2pifC);  
% from the IV curve in Cs internal;

% from the Z plots
Rl = .546E9; %Ohms
C = 2e-12; % Farads

tau_k = 4E-3; % ms
tau_na = tau_k/1.5; % ms

ERest=(-47.3);
ENa = 1000*nernstPotential(130, 1.5,1)-ERest;
EK = 1000*nernstPotential(3,140,1)-(ERest);
gL= 1/Rl; ERest = 0; % gL=0.3;  ERest=10.6;

ENa = ENa*1E-3; % V
EK = EK*1E-3;   % V
ERest = ERest*1E-3;   % V

v = [-20        -10       -5        -2.5        2.5         5           10          15      ]*1E-3; % V
gk = [0         0.1067    0.2493    0.3472      0.6508      0.8458      1.4141      2.1964 ] *1E-9; % S
gna = [0.2983   0.2567    0.2210    0.1968      0.1492      0.1215      0.0656      0.0048]*1E-9; % S
k0 = @(V)spline(v,gk,V);    % S
na0 = @(V)spline(v,gna,V);  % S

mbna = polyfit(v,gna,1);
mbk = polyfit(v,gk,1);

ENa_est = ERest-ENa;
EK_est = ERest-EK;

% w_0^2 = 1/LC;
% gamma = R/L;

% L = (ENa_est/tau_na*mbna(1) + EK_est/tau_k*mbk(1))^(-1);

L = 1/(135^2*C);
gna_bar = 1.7374e-10;
gk_bar = 5.7798e-10;
R = 1/(1/Rl+gna_bar+gk_bar);
gamma = R/L;

Q = 135/gamma;
Q = sqrt(L)/R/sqrt(C);

V = zeros(size(T));
k = V;
na = V;
I_k = V;
I_na = V;
I_l = V;

p = inputParser;
p.addParameter('V0',0,@isnumeric);
p.addParameter('k0',k0(0),@isnumeric);
p.addParameter('na0',na0(0),@isnumeric);
parse(p,varargin{:});
V(1)= p.Results.V0; 
k(1)= p.Results.k0;
na(1)= p.Results.na0;

for i=1:length(T)-1
    I_na(i) = na(i)*(ENa-(V(i)));
    I_k(i) = k(i)*(EK-(V(i)));
    I_l(i) = gL*(ERest-(V(i)));
    V(i+1) = V(i) + dt*1/C*(I_na(i) + I_k(i) + I_l(i) + I(i));
    
    k(i+1) = k(i) - dt * 1/tau_k * (k(i)-k0(V(i))); 
    na(i+1) = na(i) - dt * 1/tau_na * (na(i)-na0(V(i))); 
end

out.V = V;
out.k = k;
out.na = na;
out.I_k = I_k;
out.I_na = I_na;
out.I_l = I_l;
out.I = I;
out.t = T;
end
