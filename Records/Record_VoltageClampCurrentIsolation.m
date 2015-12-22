%% Record of V-gated conductance analysis
clear all, close all

reject_grid = {

'150727_F0_C0'  'Model cell'                    'Model cell, Change in resistance'
'150928_F0_C1'  'Model cell'                    'Model cell Rs'
'150715_F0_C1'  'Model cell'                    'Model cell'

'150617_F2_C1'  '20XUAS-mCD8:GFP;63A03-Gal4'         'Testing and analysis design'
'150704_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'Testing drugs, 4AP->Cs->TTX->Cd'                 
'150706_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'Testing drugs, TTX->4AP->Cs->Cd'                
'150709_F1_C2'  '10XUAS-mCD8:GFP;FruGal4'    'Testing drugs, TTX->4AP->TEA->CsCd'
   
'150723_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH. Used CsAsp internal without TEA'
'150730_F3_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL. 0 Ca causes problems, lost it during TEA';
'150826_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL. Blew this one up, unfortunately';
'150827_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL. combined 4AP and TEA, blew it up, combined a lot of conditions, not a good protocol';
'150902_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'TTX 4AP TEA cocktail all at once, compare MLA';

'150903_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL. Charybdotoxin attempts.'
'150903_F3_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL. Charybdotoxin attempts.'

'150718_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'High Access'
'150720_F1_C2'  '10XUAS-mCD8:GFP;FruGal4'    'High Access'
'150721_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'High Access'

'150913_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'High Access'
'151002_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'High Access'  
'151007_F4_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'High Access variance'  
'151021_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'No effect of TEA or 4AP, not normal.'

};

interesting_but_ancillary = {
'150903_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'                        'BPL. MLA block. Starting to think about how to block this strange persistent K current.'
'150903_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'                        'BPL. Charybdotoxin attempts.'
'150903_F3_C1'  '10XUAS-mCD8:GFP;FruGal4'                        'BPL. Charybdotoxin attempts.'
'150911_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'BPL. What happens when blocking para with RNAi?'
'150912_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'BPL. Older fly, clear Na currents, perhaps too old?'
'150912_F2_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'BPL. What happens when blocking para with RNAi? Younger fly, seems like there is not much left?'
'150926_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL. Need to see the impact of series resistance compensation'
'151117_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! ' 
% This cell, I did the NaV channel experiments. I think this really fucks
% the neuron up, compared to others. There is some severe hysteresis
% (TEA 4AP sensitive currents are not very big, probably because the
% neuron is hyperpolarized and K channels are severely deactivated)
}

bad_access = {
'150826_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL. Fairly nice cell, not great access';
'151128_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! Access drifts up.'
}

sham_grid = {
'150923_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL. control cell to check for drift'    
'151005_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'                        'BPH. drift control, sham. Old KOH, bad internal'
'151005_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'                        'BPL. drift control, sham. Old KOH, bad internal'
'151006_F3_C1'  '10XUAS-mCD8:GFP;FruGal4'                        'BPL. drift control, sham'
'151006_F3_C2'  '10XUAS-mCD8:GFP;FruGal4'                        'BPH. drift control, sham'    
}

cesiumPara_grid = {
'151015_F3_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve cut, BPH (dim cell body), CsGluc internal'
'151027_F2_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (dim cell body), CsAsp TEA internal'
'151027_F3_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPL (lower capacitance), CsAsp TEA internal'
'151028_F2_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPL (lower capacitance), CsAsp TEA internal'

'151102_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151102_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
}

highPref_grid = {
'151030_F1_C1'      'pJRCR7; VT30609-Gal4'              'Beautiful cell, current isolation'
'151203_F3_C3'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Decent recording, saw spikes, but no current step injection before TTX'
'151203_F4_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Decent recording, saw spikes, but no current step injection before TTX'
}


analysis_grid = {...

'150722_F1_C2'  '10XUAS-mCD8:GFP;FruGal4'    'BPH. ZD does take out Ih. Only 2.5V'
'150922_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH. Beautiful Cell in Fru Gal4, now need to switch the order of the drugs'
'151001_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL.'
'151001_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL.' % For this cell, the voltage changed during the curare, I've untagged the curare traces and excluded the cntrl trials
'151021_F3_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! Nice.'
'151022_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! Access drifts up.'
'151210_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! Access drifts up.'
'151210_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! Access drifts up.'
'151210_F3_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! Access drifts up.'

'151007_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. crapped out after TEA,NO TTX' % Should I throw this one out?
'151007_F3_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. Should be good enough for gvt work'
'151009_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
'151022_F2_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
'151029_F3_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
'151118_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'   'LP'
'151121_F3_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'   'Did the ramp at a different potential. What to do?' % For this cell, the voltage changed during the curare, I've untagged the curare traces and excluded the cntrl trials

'151030_F1_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'              'Beautiful cell, current isolation'
'151203_F3_C3'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Decent recording, saw spikes, but no current step injection before TTX'
'151203_F4_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Decent recording, saw spikes, but no current step injection before TTX'
'151207_F1_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Nice recording, cell in the nerve, quick dissection'
'151207_F2_C1'      '20XUAS-mCD8:GFP;VT30609-Gal4'        'Nice recording, cell in the nerve, quick dissection'
}

savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation';

%% Included
savedir = fullfile(savedir,'include');
if ~isdir(savedir)
    mkdir(savedir)
end

%% OR sham
savedir = fullfile(savedir,'sham');
if ~isdir(savedir)
    mkdir(savedir)
end
analysis_grid = sham_grid;

%% OR cesiumPara
savedir = fullfile(savedir,'cesiumPara');
if ~isdir(savedir)
    mkdir(savedir)
end
analysis_grid = cesiumPara_grid;

%%
clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end
Script_VClamp_Cells

%%
for ac_ind = 9:9%1:length(analysis_cell)
    ac = analysis_cell(ac_ind);
    Script_VClamp_VoltageCommandSetup

    Script_VClamp_VoltageCommands_Access;
    Script_VClamp_VoltageCommands_Vm;
    Script_VClamp_VoltageCommands_Ramp;
    Script_VClamp_VoltageCommands_VStp
    Script_VClamp_VoltageCommands_VStpSbtr
    Script_VClamp_VoltageCommands_VS
    % Script_VClamp_VoltageCommands_VSCycles
%     Script_VClamp_VoltageCommands_VSImped
%     Script_VClamp_VoltageCommands_VSCond
    close all;
end

%% 
% Script_VClamp_NaCurrentComparison

%% 
Script_VClampCollect_access
 Script_VClampCollect_ramps
 Script_VClampCollect_iv
 Script_VClampCollect_steps
 Script_VClampCollect_Vm
% Script_VClampCollect_vSines_2_5V
%Script_VClampCollect_vSines_7_5V

