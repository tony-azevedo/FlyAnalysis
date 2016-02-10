
fru_grid = {
'151016_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (dim cell body), CsAsp TEA internal'
'151017_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'still some Na currents remaining, band pass, identical to the others'
'151027_F3_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPL (lower capacitance), CsAsp TEA internal'
'151028_F2_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPL (lower capacitance), CsAsp TEA internal'
'151110_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (higher capacitance), CsAsp TEA internal'
'151110_F1_C2'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (higher capacitance), CsAsp TEA internal'
};

vt_grid = {
'151017_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151102_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151102_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151104_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151108_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151109_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal' % access drifts up
'151109_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
};

a2_grid = {
%'151212_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, decent input currents, crapped out on the piezosines'                      %'VClamp, -5 pA' 
'151215_F3_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, Gorgeous input currents for steps!'                                        %'VClamp, -5 pA' 
'151216_F2_C3'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, small input currents for steps, control cells for this fly'                %'VClamp, IClamp' 
'151216_F3_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, small input currents for steps,control cells for this fly'       
'151217_F1_C3'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, really small input currents for steps, control antenna was free'           %'VClamp, whole cell on and off' 
'151217_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, assymetric step responses, sine responses oscillate'           %'VClamp, whole cell on and off' 
'151215_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'Got an A2, but this one has spikes!'      % 'VClamp, IClamp' 
};

r45D07_grid = {
'151219_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;R45D07-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp'     
% '151219_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;R45D07-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp'     
'151219_F1_C3'  'UAS-Dcr;20XUAS-mCD8:GFP/+;R45D07-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp'     
};

offtarget_grid = {
'151214_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp'     
'151214_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '-180 deg, band pass, not an A2, more band pass'    'VClamp, IClamp' % this is a good cell for showing how band pass currents can become low pass
'151214_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp, IClamp' 

% '151215_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'Got an A2, but this one has spikes!'       'VClamp, IClamp' 

'151216_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg Low pass currents! interesting, with sustained inward'       'VClamp, IClamp' 
'151216_F1_C3'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg Band pass currents, with inward at high freq'       'VClamp, IClamp, stange Iclamp responses' 
'151216_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '-180 deg Band pass currents, sharp peak'       'VClamp' 
'151216_F2_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg Band pass currents'       'VClamp' 
'151216_F3_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '-180 deg Band pass currents, sharp peak'       'VClamp' 

'151217_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg, Very small currents, anteanna was stuck'       'VClamp' 
'151217_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '-180 deg Band pass currents, smooth peak, antenna free'       'VClamp' 

'151219_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;R45D07-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp'     
'151219_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;R45D07-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp'     
'151219_F1_C3'  'UAS-Dcr;20XUAS-mCD8:GFP/+;R45D07-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp'     
};

savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents';

%%
clear analysis_cell analysis_cells control_cells control_cells 
clear fru_cells fru_cell vt_cell vt_cells a2_cell a2_cells  offtarget_cell offtarget_cells r45D07_cell r45D07_cells

for c = 1:size(fru_grid,1)
    fru_cell(c).name = fru_grid{c,1}; 
    fru_cell(c).genotype = fru_grid{c,2}; %#ok<*SAGROW>
    fru_cell(c).comment = fru_grid{c,3};
    fru_cells{c} = fru_grid{c,1}; 
end

for c = 1:size(vt_grid,1)
    vt_cell(c).name = vt_grid{c,1}; 
    vt_cell(c).genotype = vt_grid{c,2}; %#ok<*SAGROW>
    vt_cell(c).comment = vt_grid{c,3};
    vt_cells{c} = vt_grid{c,1}; 
end

for c = 1:size(a2_grid,1)
    a2_cell(c).name = a2_grid{c,1}; 
    a2_cell(c).genotype = a2_grid{c,2}; %#ok<*SAGROW>
    a2_cell(c).comment = a2_grid{c,3};
    a2_cells{c} = a2_grid{c,1}; 
end

for c = 1:size(r45D07_grid,1)
    r45D07_cell(c).name = r45D07_grid{c,1}; 
    r45D07_cell(c).genotype = r45D07_grid{c,2}; %#ok<*SAGROW>
    r45D07_cell(c).comment = r45D07_grid{c,3};
    r45D07_cells{c} = r45D07_grid{c,1}; 
end

for c = 1:size(offtarget_grid,1)
    offtarget_cell(c).name = offtarget_grid{c,1}; 
    offtarget_cell(c).genotype = offtarget_grid{c,2}; %#ok<*SAGROW>
    offtarget_cell(c).comment = offtarget_grid{c,3};
    offtarget_cells{c} = offtarget_grid{c,1}; 
end

%% Examples

a2example.name = '151215_F3_C1';
a2example.PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F3_C1\PiezoSine_Raw_151215_F3_C1_183.mat';
a2example.PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F3_C1\PiezoStep_Raw_151215_F3_C1_1.mat';

fruexample.name = '151016_F1_C1'; % '151028_F2_C1' '151027_F3_C1' '151110_F1_C1'
fruexample.PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\PiezoSine_Raw_151016_F1_C1_7.mat';
fruexample.PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\PiezoStep_Raw_151016_F1_C1_2.mat';
fruexample.PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\PiezoSine_Raw_151016_F1_C1_360.mat';
fruexample.PiezoStepTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\PiezoStep_Raw_151016_F1_C1_50.mat';

vtexample.name = '151108_F2_C1'; % '151102_F1_C1' '151108_F2_C1' '151027_F3_C1' '151102_F2_C1'
vtexample.PiezoSineTrial = ... 'C:\Users\tony\Raw_Data\151102\151102_F1_C1\PiezoSine_Raw_151102_F1_C1_7.mat';
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\PiezoSine_Raw_151108_F2_C1_7.mat';
vtexample.PiezoStepTrial = ... 'C:\Users\tony\Raw_Data\151102\151102_F1_C1\PiezoStep_Raw_151102_F1_C1_2.mat';
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\PiezoStep_Raw_151108_F2_C1_2.mat';

r45D07example.name = '151219_F1_C1'; % 151219_F1_C3
r45D07example.PiezoSineTrial = ... 
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoSine_Raw_151219_F1_C1_7.mat';
r45D07example.PiezoStepTrial = ... 
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoStep_Raw_151219_F1_C1_2.mat';


offtargetexample.name = '151219_F1_C1';% '151214_F1_C1'; 
offtargetexample.PiezoSineTrial = ... 
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoSine_Raw_151219_F1_C1_7.mat'; % 'C:\Users\tony\Raw_Data\151214\151214_F1_C1\PiezoSine_Raw_151214_F1_C1_7.mat';
offtargetexample.PiezoStepTrial = ... 
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoStep_Raw_151219_F1_C1_2.mat'; %'C:\Users\tony\Raw_Data\151214\151214_F1_C1\PiezoStep_Raw_151214_F1_C1_2.mat';


%% A2: 

% not a good recording
cnt = find(strcmp(a2_cells,'151212_F1_C1'));
if ~isempty(cnt)
    a2_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151212\151212_F1_C1\PiezoSine_Raw_151212_F1_C1_7.mat';
    a2_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151212\151212_F1_C1\PiezoStep_Raw_151212_F1_C1_32.mat';
end

% 
cnt = find(strcmp(a2_cells,'151215_F3_C1'));
if ~isempty(cnt)
    a2_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F3_C1\PiezoSine_Raw_151215_F3_C1_183.mat';
    a2_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F3_C1\PiezoStep_Raw_151215_F3_C1_1.mat';
end

% 
cnt = find(strcmp(a2_cells,'151216_F2_C3'));
if ~isempty(cnt)
    a2_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F2_C3\PiezoSine_Raw_151216_F2_C3_1.mat';
    a2_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F2_C3\PiezoStep_Raw_151216_F2_C3_1.mat';
end

% 
cnt = find(strcmp(a2_cells,'151216_F3_C2'));
if ~isempty(cnt)
    a2_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F3_C2\PiezoSine_Raw_151216_F3_C2_7.mat';
    a2_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F3_C2\PiezoStep_Raw_151216_F3_C2_1.mat';
end

% 
cnt = find(strcmp(a2_cells,'151217_F1_C3'));
if ~isempty(cnt)
    a2_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F1_C3\PiezoSine_Raw_151217_F1_C3_7.mat';
    a2_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F1_C3\PiezoStep_Raw_151217_F1_C3_1.mat';
end

% 
cnt = find(strcmp(a2_cells,'151217_F2_C1'));
if ~isempty(cnt)
    a2_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F2_C1\PiezoSine_Raw_151217_F2_C1_7.mat';
    a2_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F2_C1\PiezoStep_Raw_151217_F2_C1_7.mat';
end

% Has spikes
cnt = find(strcmp(a2_cells,'151215_F2_C1'));
if ~isempty(cnt)
    a2_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F2_C1\PiezoSine_Raw_151215_F2_C1_7.mat';
a2_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F2_C1\PiezoStep_Raw_151215_F2_C1_1.mat';
end


%% Fru: 

% example, nice access
cnt = find(strcmp(fru_cells,'151016_F1_C1'));
if ~isempty(cnt)
    fru_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\PiezoSine_Raw_151016_F1_C1_7.mat';
fru_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\PiezoStep_Raw_151016_F1_C1_2.mat';
fru_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\PiezoSine_Raw_151016_F1_C1_360.mat';
fru_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\VoltageStep_Raw_151016_F1_C1_1.mat';
fru_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\VoltageCommand_Raw_151016_F1_C1_1.mat';
fru_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151016\151016_F1_C1\CurrentChirp_Raw_151016_F1_C1_1.mat';
end

% Small responses
cnt = find(strcmp(fru_cells,'151017_F1_C1'));
if ~isempty(cnt)
    fru_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F1_C1\PiezoSine_Raw_151017_F1_C1_4.mat';
fru_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F1_C1\PiezoStep_Raw_151017_F1_C1_2.mat';
fru_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151017\151017_F1_C1\PiezoSine_Raw_151017_F1_C1_227.mat';
fru_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F1_C1\VoltageStep_Raw_151017_F1_C1_1.mat';
fru_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F1_C1\VoltageCommand_Raw_151017_F1_C1_1.mat';
fru_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F1_C1\CurrentChirp_Raw_151017_F1_C1_1.mat';
end

% Good, but lots of transients, not great example
cnt = find(strcmp(fru_cells,'151027_F3_C1'));
if ~isempty(cnt)
    fru_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151027\151027_F3_C1\PiezoSine_Raw_151027_F3_C1_7.mat';
fru_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151027\151027_F3_C1\PiezoStep_Raw_151027_F3_C1_1.mat';
fru_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151027\151027_F3_C1\PiezoSine_Raw_151027_F3_C1_222.mat';  % 25 50 100 200 400; 0.05 0.5
fru_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151027\151027_F3_C1\VoltageStep_Raw_151027_F3_C1_1.mat';
fru_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151027\151027_F3_C1\VoltageCommand_Raw_151027_F3_C1_1.mat';
fru_cell(cnt).CurrentChirpTrial = ...
'';
end

% Possible
cnt = find(strcmp(fru_cells,'151028_F2_C1'));
if ~isempty(cnt)
    fru_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151028\151028_F2_C1\PiezoSine_Raw_151028_F2_C1_7.mat';
fru_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151028\151028_F2_C1\PiezoStep_Raw_151028_F2_C1_1.mat';
fru_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151028\151028_F2_C1\PiezoSine_Raw_151028_F2_C1_224.mat'; % 0.05 0.5
fru_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151028\151028_F2_C1\VoltageStep_Raw_151028_F2_C1_1.mat';
fru_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151028\151028_F2_C1\VoltageCommand_Raw_151028_F2_C1_1.mat';
fru_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151028\151028_F2_C1\CurrentChirp_Raw_151028_F2_C1_1.mat';
end

% biggest responses
cnt = find(strcmp(fru_cells,'151110_F1_C1'));
if ~isempty(cnt)
    fru_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C1\PiezoSine_Raw_151110_F1_C1_7.mat';
fru_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C1\PiezoStep_Raw_151110_F1_C1_12.mat';
fru_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C1\PiezoSine_Raw_151110_F1_C1_274.mat'; % 0.05 0.5
fru_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C1\VoltageStep_Raw_151110_F1_C1_7.mat';
fru_cell(cnt).VoltageCommandTrial = ...
'';
fru_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C1\CurrentChirp_Raw_151110_F1_C1_1.mat';
end

% bit of an outlier, not as much band pass, antiphase
cnt = find(strcmp(fru_cells,'151110_F1_C2'));
if ~isempty(cnt)
    fru_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C2\PiezoSine_Raw_151110_F1_C2_7.mat';
fru_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C2\PiezoStep_Raw_151110_F1_C2_1.mat';
fru_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C2\PiezoSine_Raw_151110_F1_C2_274.mat';
fru_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C2\VoltageStep_Raw_151110_F1_C2_1.mat';
fru_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C2\VoltageCommand_Raw_151110_F1_C2_1.mat';
fru_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151110\151110_F1_C2\CurrentChirp_Raw_151110_F1_C2_1.mat';
end

%% VT: 

% Crazy outlier, big responses, outlier
cnt = find(strcmp(vt_cells,'151017_F2_C1'));
if ~isempty(cnt)
    vt_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\PiezoSine_Raw_151017_F2_C1_32.mat';
vt_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\PiezoStep_Raw_151017_F2_C1_1.mat';
vt_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\PiezoSine_Raw_151017_F2_C1_252.mat';
vt_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\VoltageStep_Raw_151017_F2_C1_1.mat';
vt_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\VoltageCommand_Raw_151017_F2_C1_1.mat';
vt_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151017\151017_F2_C1\CurrentChirp_Raw_151017_F2_C1_1.mat';
end

% typical relationship, large, very nice responses, access fine
cnt = find(strcmp(vt_cells,'151102_F1_C1'));
if ~isempty(cnt)
    vt_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\PiezoSine_Raw_151102_F1_C1_7.mat';
vt_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\PiezoStep_Raw_151102_F1_C1_2.mat';
vt_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\PiezoSine_Raw_151102_F1_C1_264.mat';
vt_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\VoltageStep_Raw_151102_F1_C1_1.mat';
vt_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\VoltageCommand_Raw_151102_F1_C1_1.mat';
vt_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F1_C1\CurrentChirp_Raw_151102_F1_C1_1.mat';
end

% typical relationship but largest 
cnt = find(strcmp(vt_cells,'151102_F2_C1'));
if ~isempty(cnt)
    vt_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\PiezoSine_Raw_151102_F2_C1_7.mat';
vt_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\PiezoStep_Raw_151102_F2_C1_1.mat';
vt_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\PiezoSine_Raw_151102_F2_C1_268.mat';
vt_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\VoltageStep_Raw_151102_F2_C1_1.mat';
vt_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\VoltageCommand_Raw_151102_F2_C1_1.mat';
vt_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151102\151102_F2_C1\CurrentChirp_Raw_151102_F2_C1_1.mat';
end

% smaller, more low pass
cnt = find(strcmp(vt_cells,'151104_F1_C2'));
if ~isempty(cnt)
    vt_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\PiezoSine_Raw_151104_F1_C2_7.mat';
vt_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\PiezoStep_Raw_151104_F1_C2_7.mat';
vt_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\PiezoSine_Raw_151104_F1_C2_268.mat';
vt_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\VoltageStep_Raw_151104_F1_C2_1.mat';
vt_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\VoltageCommand_Raw_151104_F1_C2_1.mat';
vt_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151104\151104_F1_C2\CurrentChirp_Raw_151104_F1_C2_1.mat';
end

% also good looking, access is very stable
cnt = find(strcmp(vt_cells,'151108_F2_C1'));
if ~isempty(cnt)
    vt_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\PiezoSine_Raw_151108_F2_C1_7.mat';
vt_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\PiezoStep_Raw_151108_F2_C1_2.mat';
vt_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\PiezoSine_Raw_151108_F2_C1_280.mat';
vt_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\VoltageCommand_Raw_151108_F2_C1_1.mat';
vt_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151108\151108_F2_C1\VoltageStep_Raw_151108_F2_C1_1.mat';
vt_cell(cnt).CurrentChirpTrial = ...
'';
end

% smaller, more low pass
cnt = find(strcmp(vt_cells,'151109_F1_C1'));
if ~isempty(cnt)
    vt_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C1\PiezoSine_Raw_151109_F1_C1_7.mat';
vt_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C1\PiezoStep_Raw_151109_F1_C1_2.mat';
vt_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C1\PiezoSine_Raw_151109_F1_C1_268.mat';
vt_cell(cnt).VoltageCommandTrial = ...
'';
vt_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C1\VoltageStep_Raw_151109_F1_C1_1.mat';
vt_cell(cnt).CurrentChirpTrial = ...
'';
end

% smaller, more low pass, antiphase
cnt = find(strcmp(vt_cells,'151109_F1_C2'));
if ~isempty(cnt)
    vt_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C2\PiezoSine_Raw_151109_F1_C2_7.mat';
vt_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C2\PiezoStep_Raw_151109_F1_C2_1.mat';
vt_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C2\PiezoSine_Raw_151109_F1_C2_282.mat';
vt_cell(cnt).VoltageCommandTrial = ...
'';
vt_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151109\151109_F1_C2\VoltageStep_Raw_151109_F1_C2_1.mat';
vt_cell(cnt).CurrentChirpTrial = ...
'';
end

%% 45D07
cnt = find(strcmp(offtarget_cells,'151219_F1_C1'));
if ~isempty(cnt)
    R45D07_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoSine_Raw_151219_F1_C1_7.mat';
R45D07_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoStep_Raw_151219_F1_C1_2.mat';
R45D07_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoSine_Raw_151219_F1_C1_226.mat';
R45D07_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\VoltageStep_Raw_151219_F1_C1_1.mat';
R45D07_cell(cnt).VoltageCommandTrial = ...
'';
R45D07_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151219_F1_C2'));
if ~isempty(cnt)
    R45D07_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C2\PiezoSine_Raw_151219_F1_C2_7.mat';
R45D07_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C2\PiezoStep_Raw_151219_F1_C2_1.mat';
R45D07_cell(cnt).PiezoSineTrial_IClamp = ...
'';
R45D07_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C2\VoltageStep_Raw_151219_F1_C2_1.mat';
R45D07_cell(cnt).VoltageCommandTrial = ...
'';
R45D07_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151219_F1_C3'));
if ~isempty(cnt)
    R45D07_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C3\PiezoSine_Raw_151219_F1_C3_7.mat';
R45D07_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C3\PiezoStep_Raw_151219_F1_C3_1.mat';
R45D07_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C3\PiezoSine_Raw_151219_F1_C3_178.mat';
R45D07_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C3\VoltageStep_Raw_151219_F1_C3_1.mat';
R45D07_cell(cnt).VoltageCommandTrial = ...
'';
R45D07_cell(cnt).CurrentChirpTrial = ...
'';
end

%% offtarget (VT30609, 45D07)

% Crazy outlier, big responses, outlier
cnt = find(strcmp(offtarget_cells,'151214_F1_C1'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F1_C1\PiezoSine_Raw_151214_F1_C1_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F1_C1\PiezoStep_Raw_151214_F1_C1_2.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F1_C1\VoltageStep_Raw_151214_F1_C1_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151214_F1_C2'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F1_C2\PiezoSine_Raw_151214_F1_C2_15.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F1_C2\PiezoStep_Raw_151214_F1_C2_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151214\151214_F1_C2\PiezoSine_Raw_151214_F1_C2_280.mat';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F1_C2\VoltageStep_Raw_151214_F1_C2_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F1_C2\CurrentChirp_Raw_151214_F1_C2_1.mat';
end

cnt = find(strcmp(offtarget_cells,'151214_F2_C1'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F2_C1\PiezoSine_Raw_151214_F2_C1_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F2_C1\PiezoStep_Raw_151214_F2_C1_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151214\151214_F2_C1\PiezoSine_Raw_151214_F2_C1_272.mat';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F2_C1\VoltageStep_Raw_151214_F2_C1_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'C:\Users\tony\Raw_Data\151214\151214_F2_C1\CurrentChirp_Raw_151214_F2_C1_1.mat';
end

cnt = find(strcmp(offtarget_cells,'151215_F2_C1'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F2_C1\PiezoSine_Raw_151215_F2_C1_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F2_C1\PiezoStep_Raw_151215_F2_C1_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151215\151215_F2_C1\PiezoSine_Raw_151215_F2_C1_272.mat';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F2_C1\VoltageStep_Raw_151215_F2_C1_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'C:\Users\tony\Raw_Data\151215\151215_F2_C1\VoltageCommand_Raw_151215_F2_C1_1.mat';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end


cnt = find(strcmp(offtarget_cells,'151216_F1_C1'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F1_C1\PiezoSine_Raw_151216_F1_C1_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F1_C1\PiezoStep_Raw_151216_F1_C1_44.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F1_C1\VoltageStep_Raw_151216_F1_C1_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151216_F1_C3'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F1_C3\PiezoSine_Raw_151216_F1_C3_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F1_C3\PiezoStep_Raw_151216_F1_C3_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151216\151216_F1_C3\PiezoSine_Raw_151216_F1_C3_272.mat';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F1_C3\VoltageStep_Raw_151216_F1_C3_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151216_F2_C1'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F2_C1\PiezoSine_Raw_151216_F2_C1_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F2_C1\PiezoStep_Raw_151216_F2_C1_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'';
offtarget_cell(cnt).VoltageStepTrial = ...
'';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151216_F2_C2'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F2_C2\PiezoSine_Raw_151216_F2_C2_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F2_C2\PiezoStep_Raw_151216_F2_C2_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F2_C2\VoltageStep_Raw_151216_F2_C2_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151216_F3_C1'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F3_C1\PiezoSine_Raw_151216_F3_C1_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F3_C1\PiezoStep_Raw_151216_F3_C1_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151216\151216_F3_C1\VoltageStep_Raw_151216_F3_C1_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151217_F1_C1'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F1_C1\PiezoSine_Raw_151217_F1_C1_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F1_C1\PiezoStep_Raw_151217_F1_C1_2.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F1_C1\VoltageStep_Raw_151217_F1_C1_1.mat';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151217_F1_C2'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F1_C2\PiezoSine_Raw_151217_F1_C2_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F1_C2\PiezoStep_Raw_151217_F1_C2_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151217\151217_F1_C2\VoltageStep_Raw_151217_F1_C2_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

% ----- 45D07 ------
cnt = find(strcmp(offtarget_cells,'151219_F1_C1'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoSine_Raw_151219_F1_C1_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoStep_Raw_151219_F1_C1_2.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\PiezoSine_Raw_151219_F1_C1_226.mat';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C1\VoltageStep_Raw_151219_F1_C1_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151219_F1_C2'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C2\PiezoSine_Raw_151219_F1_C2_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C2\PiezoStep_Raw_151219_F1_C2_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C2\VoltageStep_Raw_151219_F1_C2_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end

cnt = find(strcmp(offtarget_cells,'151219_F1_C3'));
if ~isempty(cnt)
    offtarget_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C3\PiezoSine_Raw_151219_F1_C3_7.mat';
offtarget_cell(cnt).PiezoStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C3\PiezoStep_Raw_151219_F1_C3_1.mat';
offtarget_cell(cnt).PiezoSineTrial_IClamp = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C3\PiezoSine_Raw_151219_F1_C3_178.mat';
offtarget_cell(cnt).VoltageStepTrial = ...
'C:\Users\tony\Raw_Data\151219\151219_F1_C3\VoltageStep_Raw_151219_F1_C3_1.mat';
offtarget_cell(cnt).VoltageCommandTrial = ...
'';
offtarget_cell(cnt).CurrentChirpTrial = ...
'';
end