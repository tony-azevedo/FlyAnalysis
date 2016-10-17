%% Conductance model
% This script provides code to use the B1 dynamical models. All units here
% are in SI units: seconds, Amps, Volts, Farads, Ohms, S etc. so there are a lot
% of very small numbers and very large numbers.
% each section below performs some of the computations

%% play with chirps

V0 = 4.4849E-4; % Vrest - where the model comes to rest with I=0
na0 = 1.6934e-10; % Resting Na conductance when I=0
k0 = 5.1157e-10; % Resting K conductance when I=0

dur = 2;                        % Chirp duration
dt = 0.0001; sr = 1/dt;         % Time step
t = (0:dt:dur-dt)';             % time vector
ramp = .04;                     % the stimulus ramps on and off
amp = 30E-12;                   % the amplitude of current injection
            
stimpnts = round(1:dur*sr);
            
w = window(@triang,2*ramp*sr);
w = [w(1:ramp*sr);...
    ones(length(stimpnts)-length(w),1);...
    w(ramp*sr+1:end)];

standardstim = chirp(t,.3,dur,400); % create a chirp from 0.3 to 400 Hz

I = w.*standardstim*amp;

% --- Run the Model ---
out_IClamp = B1DynamicalSystem(I,t,'V0',V0,'na0',na0,'k0',k0);

out = out_IClamp;

% Calculate impedance
Vz = hilbert(out_IClamp.V-V0);
Iz = hilbert(out_IClamp.I - mean(out_IClamp.I));
Z = Vz./Iz;

f = t*((400-.3)/dur)+.03;

% Plot stuff
figure(3);
set(3,'position',[164        -148        1609         964])

subplot(4,2,1), 
plot(f,out.I,'color',[0 0 0]);
ylabel('V');
title('Current Injection')

subplot(4,2,3), title('Feedback Current')
plot(f,out.V,'color',[0 0 0]); hold off
ylabel('A');
title('Membrane Potential')

subplot(4,2,5), 
plot(f,(out.I+(out.I_na+out.I_k)),'color',[0 1 0]); hold on
plot(f,-(out.I_na+out.I_k),'color',[1 0 1]); 
ylabel('A');
xlabel('Hz');
legend({'I_{RC}','I_{na}+I_k'}); hold off
title('RC current + VG current')

subplot(4,2,7),
plot(f,out.na,'color',[1 0 0]); hold on
plot(f,out.k,'color',[0 0 1]); hold off
ylabel('S');
xlabel('Hz');
legend({'g_{na}','g_k'});
title('Na and K conductance')
 
subplot(4,2,2), 
plot(f(1:end-ramp*sr),abs(Z(1:end-ramp*sr)),'color',[0 0 0]); hold off
ylabel('\Omega');
xlabel('Hz');
title('Impedance amplitude')

subplot(4,2,4), title('Impedance phase')
plot(f(1:end-ramp*sr),angle(Z(1:end-ramp*sr))/2/pi,'color',[0 0 0]); hold off
ylabel('rad');
xlabel('Hz');
title('Impedance phase')


linkaxes(get(3,'children'),'x')

% ---- Now go to the figure and zoom in. The axes should be linked and you
% should be able to cruise around and check out the phase relationships
% between current and voltage

%% Now play with chirps with VG blocked
V0 = 4.4849E-4; % Vrest
na0 = 1.6934e-10; 
k0 = 5.1157e-10; 

dur = 2;
dt = 0.0001; sr = 1/dt;
t = (0:dt:dur-dt)';
ramp = .04;
amp = 30E-12;            
            
stimpnts = round(1:dur*sr);
            
w = window(@triang,2*ramp*sr);
w = [w(1:ramp*sr);...
    ones(length(stimpnts)-length(w),1);...
    w(ramp*sr+1:end)];

standardstim = chirp(t,.3,dur,400);

I = w.*standardstim*amp;

% --- Note: Model include the VG conductances, but they have not effect ---
out_IClamp_DRUGS = B1DynamicalSystem_VGBlock(I,t,'V0',V0,'na0',na0,'k0',k0);

out = out_IClamp_DRUGS;

Vz = hilbert(out.V-V0);
Iz = hilbert(out.I - mean(out.I));
Z = Vz./Iz;

f = t*((400-.3)/dur)+.03;

figure(2);
set(2,'position',[164        -148        1609         964])

subplot(4,2,1), 
plot(f,out.I,'color',[0 0 0]);
ylabel('V');
title('Current Injection')

subplot(4,2,3), title('Feedback Current')
plot(f,out.V,'color',[0 0 0]); hold off
ylabel('A');
title('Membrane Potential')

subplot(4,2,5), 
plot(f,(out.I+(out.I_na+out.I_k)),'color',[0 1 0]); hold on
plot(f,-(out.I_na+out.I_k),'color',[1 0 1]); 
ylabel('A');
xlabel('Hz');
legend({'I_{RC}','I_{na}+I_k'}); hold off
title('RC current + VG current')

subplot(4,2,7),
plot(f,out.na,'color',[1 0 0]); hold on
plot(f,out.k,'color',[0 0 1]); hold off
ylabel('S');
xlabel('Hz');
legend({'g_{na}','g_k'});
title('Na and K conductance')
 
subplot(4,2,2), 
plot(f(1:end-ramp*sr),abs(Z(1:end-ramp*sr)),'color',[0 0 0]); hold off
ylabel('\Omega');
xlabel('Hz');
title('Impedance amplitude')

subplot(4,2,4), title('Impedance phase')
plot(f(1:end-ramp*sr),angle(Z(1:end-ramp*sr))/2/pi,'color',[0 0 0]); hold off
ylabel('rad');
xlabel('Hz');
title('Impedance phase')


linkaxes(get(2,'children'),'x')

% ---- Now go to the figure and zoom in. The axes should be linked and you
% should be able to cruise around and check out the phase relationships
% between current and voltage

%% Now play with Voltage Chirps
V0 = 4.4849E-4; % Vrest
na0 = 1.6934e-10; 
k0 = 5.1157e-10; 

dur = 2;
dt = 0.0001; sr = 1/dt;
t = (0:dt:dur-dt)';
ramp = .04;
amp = 7.5E-3;            
            
stimpnts = round(1:dur*sr);
            
w = window(@triang,2*ramp*sr);
w = [w(1:ramp*sr);...
    ones(length(stimpnts)-length(w),1);...
    w(ramp*sr+1:end)];

standardstim = chirp(t,.3,dur,400);

V = (w.*standardstim)*amp+V0; % oscillate about rest

% --- Run the Model ---
out_VClamp = B1DynamicalSystem_VClamp(V,t,'I0',0,'na0',na0,'k0',k0);

Vz = hilbert(out_VClamp.V-V0);
Iz = hilbert(out_VClamp.I - mean(out_VClamp.I));
Z = Vz./Iz;

f = t*((400-.3)/dur)+.03;

figure(4);
set(4,'position',[164        -148        1609         964])

out = out_VClamp;
subplot(4,2,1)
plot(f,V,'color',[0 0 0]); hold off
ylabel('V');
title('Holding Command')

subplot(4,2,3)
plot(f,out.I,'color',[0 0 0]); hold off
ylabel('A');
title('Feedback Current')

subplot(4,2,5), 
plot(f,(out.I+(out.I_na+out.I_k)),'color',[0 1 0]); hold on
plot(f,-(out.I_na+out.I_k),'color',[1 0 1]); 
ylabel('A');
xlabel('Hz');
legend({'I_{RC}','I_{na}+I_k'}); hold off
title('RC current + VG current')

subplot(4,2,7), 
plot(f,out.na,'color',[1 0 0]); hold on
plot(f,out.k,'color',[0 0 1]); hold off
ylabel('S');
xlabel('Hz');
legend({'g_{na}','g_k'});
title('Na and K conductance')

subplot(4,2,2), 
plot(f(1:end-ramp*sr),abs(Z(1:end-ramp*sr)),'color',[0 0 0]); hold off
ylabel('\Omega');
xlabel('Hz');
title('Impedance amplitude')

subplot(4,2,4),
plot(f(1:end-ramp*sr),angle(Z(1:end-ramp*sr))/2/pi,'color',[0 0 0]); hold off
ylabel('rad');
xlabel('Hz');
 title('Impedance phase')
 
linkaxes(get(4,'children'),'x')

% ---- Now go to the figure and zoom in. The axes should be linked and you
% should be able to cruise around and check out the phase relationships
% between current and voltage

%% Now play with Voltage Chirps with VG conductances blocked
V0 = 4.4849E-4; % Vrest
na0 = 1.6934e-10; % Vrest
k0 = 5.1157e-10; % Vrest


dur = 2;
dt = 0.0001; sr = 1/dt;
t = (0:dt:dur-dt)';
ramp = .04;
amp = 7.5E-3;            
            
stimpnts = round(1:dur*sr);
            
w = window(@triang,2*ramp*sr);
w = [w(1:ramp*sr);...
    ones(length(stimpnts)-length(w),1);...
    w(ramp*sr+1:end)];

standardstim = chirp(t,.3,dur,400);

V = (w.*standardstim)*amp+V0;

out_DRUGS = B1DynamicalSystem_VClamp_VGBLock(V,t,'I0',0,'na0',na0,'k0',k0);

Vz = hilbert(out_DRUGS.V-V0);
Iz = hilbert(out_DRUGS.I - mean(out_DRUGS.I));
Z = Vz./Iz;

f = t*((400-.3)/dur)+.03;

figure(5);
set(5,'position',[164        -148        1609         964])

out = out_DRUGS;

subplot(4,2,1), 
plot(f,V,'color',[0 0 0]);
ylabel('V');
title('Holding Command')

subplot(4,2,3), title('Feedback Current')
plot(f,out.I,'color',[0 0 0]); hold off
ylabel('A');
title('Feedback Current')

subplot(4,2,5), 
plot(f,(out.I+(out.I_na+out.I_k)),'color',[0 1 0]); hold on
plot(f,-(out.I_na+out.I_k),'color',[1 0 1]); 
ylabel('A');
xlabel('Hz');
legend({'I_{RC}','I_{na}+I_k'}); hold off
title('RC current + VG current')

subplot(4,2,7),
plot(f,out.na,'color',[1 0 0]); hold on
plot(f,out.k,'color',[0 0 1]); hold off
ylabel('S');
xlabel('Hz');
legend({'g_{na}','g_k'});
 title('Na and K conductance')
 
subplot(4,2,2), 
plot(f(1:end-ramp*sr),abs(Z(1:end-ramp*sr)),'color',[0 0 0]); hold off
ylabel('\Omega');
xlabel('Hz');
title('Impedance amplitude')

subplot(4,2,4), title('Impedance phase')
plot(f(1:end-ramp*sr),angle(Z(1:end-ramp*sr))/2/pi,'color',[0 0 0]); hold off
ylabel('rad');
xlabel('Hz');
title('Impedance phase')


linkaxes(get(5,'children'),'x')

% ---- Now go in and check out the phase relationships between current and
% voltage

