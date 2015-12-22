%% recording in VClamp with Cs internal and para RNAi
% Control grid is for the voltage steps.
clear all, close all

control_grid = {...

'150722_F1_C2'  '10XUAS-mCD8:GFP/+;FruGal4/+'   'BPH. ZD does take out Ih. Only 2.5V'
'150922_F2_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'   'BPH. Beautiful Cell in Fru Gal4, now need to switch the order of the drugs'
'151001_F1_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'   'BPL.'
'151001_F2_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'   'BPL.' % For this cell, the voltage changed during the curare, I've untagged the curare traces and excluded the cntrl trials
'151021_F3_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'   'BPH! Nice.'
'151022_F1_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'   'BPH! Access drifts up.'

'151007_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. crapped out after TEA,NO TTX' % Should I throw this one out?
'151007_F3_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. Should be good enough for gvt work'
'151009_F1_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
'151022_F2_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
'151029_F3_C1'  '20XUAS-mCD8:GFP;VT27938-Gal4'  'LP. '
}

reject_grid = {  % can be used in controls
'151015_F3_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve cut, BPH (dim cell body), CsGluc internal'
'151016_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antenna was not moving, some what fixed'
'151108_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
% '151104_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi' 'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'  % crapped out during the sines
'151027_F2_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (dim cell body), CsAsp TEA internal' % bad access

'151216_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, not a good recording'     
}

analysis_grid = {
'151016_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (dim cell body), CsAsp TEA internal'
'151017_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'still some Na currents remaining, band pass, identical to the others'
'151027_F3_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPL (lower capacitance), CsAsp TEA internal'
'151028_F2_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPL (lower capacitance), CsAsp TEA internal'
'151110_F1_C1'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (higher capacitance), CsAsp TEA internal'
'151110_F1_C2'  'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'    'Antennal nerve intact, BPH (higher capacitance), CsAsp TEA internal'

'151017_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151102_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151102_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151104_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151108_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'
'151109_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal' % access drifts up
'151109_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'Antennal nerve intact, LP (lower capacitance), CsAsp TEA internal'

'151212_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, decent input currents, crapped out on the piezosines'                      %'VClamp, -5 pA' 
'151215_F3_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, Gorgeous input currents for steps!'                                        %'VClamp, -5 pA' 
'151216_F2_C3'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, small input currents for steps, control cells for this fly'                %'VClamp, IClamp' 
'151216_F3_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, small input currents for steps,control cells for this fly'       
'151217_F1_C3'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, really small input currents for steps, control antenna was free'           %'VClamp, whole cell on and off' 
'151217_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'A2, assymetric step responses, sine responses oscillate'           %'VClamp, whole cell on and off' 
}

offtarget_grid = {
'151214_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp'     
'151214_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '-180 deg, band pass, not an A2, more band pass'    'VClamp, IClamp' % this is a good cell for showing how band pass currents can become low pass
'151214_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg, band pass, not an A2, more band pass'       'VClamp, IClamp' 

'151215_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   'Got an A2, but this one has spikes!'       'VClamp, IClamp' 

'151216_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg Low pass currents! interesting, with sustained inward'       'VClamp, IClamp' 
'151216_F1_C3'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg Band pass currents, with inward at high freq'       'VClamp, IClamp, stange Iclamp responses' 
'151216_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '-180 deg Band pass currents, sharp peak'       'VClamp' 
'151216_F2_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg Band pass currents'       'VClamp' 
'151216_F3_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '-180 deg Band pass currents, sharp peak'       'VClamp' 

'151217_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '0 deg, Very small currents, anteanna was stuck'       'VClamp' 
'151217_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT30609-Gal4/UAS-paraRNAi'   '-180 deg Band pass currents, smooth peak, antenna free'       'VClamp' 
}

savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents';

%%
clear analysis_cell analysis_cells control_cells control_cells
genotypes = {   '10XUAS-mCD8:GFP/+;FruGal4/+'                           '20XUAS-mCD8:GFP;VT27938-Gal4';
                'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'        'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'
};

for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end

for c = 1:size(control_grid,1)
    control_cell(c).name = control_grid{c,1}; 
    control_cell(c).genotype = control_grid{c,2}; %#ok<*SAGROW>
    control_cell(c).comment = analysis_grid{c,3};
    control_cells{c} = analysis_grid{c,1}; 
end

%%
%for ac_ind = [6 11 4 3 2 1];
for ac_ind = 15; %1:length(analysis_cell)
    ac = analysis_cell(ac_ind);
    disp(ac.name);
    
     Script_VClamp_PiezoSines_VandI;
     Script_VClamp_PiezoSteps_VandI;
     Script_VClamp_VoltageCommands_Access; 

    % Vsteps
    % PiezoSteps
    % Spontaneous noise % maybe add a tag to the right trial
    
    close all;
end
% Clean up the PiezoSine trials

%%

% Script_VClampCollect_access
% Script_VClampIinputs_VStp
Script_VClampIinputs_RespVsFreq

%% Impact of whole-cell compensation:

% compensation_on = 'C:\Users\Anthony Azevedo\Raw_Data\151102\151102_F1_C1\PiezoStep_Raw_151102_F1_C1_115.mat';
% compensation_off = 'C:\Users\Anthony Azevedo\Raw_Data\151102\151102_F1_C1\PiezoStep_Raw_151102_F1_C1_145.mat';
% 
% trial = load(compensation_on);
% h = getShowFuncInputsFromTrial(trial);
% 
% fig = figure;
% set(fig,'color',[1 1 1],'position',[680 738 1027 240],'name','Compensation Comparison');
% pnl = panel(fig);
% pnl.pack('h',length(trial.params.displacements));
% pnl.margintop = 10;
% 
% trial = load(compensation_on);
% h = getShowFuncInputsFromTrial(trial);
% famfig = PF_PiezoStepFam([],h,'');
%     
% dspls = h.trial.params.displacements;
% for didx = 1:length(dspls);
%     pnl_hs(didx) = pnl(didx).select();
%     
%     l = findobj(findobj(famfig,'tag','quickshow_inax'),'tag',num2str(dspls(didx)));
%     l = copyobj(l,pnl_hs(didx));
%     set(l,'color',[0 0 1]);
% end
% 
% trial = load(compensation_off);
% h = getShowFuncInputsFromTrial(trial);
% famfig = PF_PiezoStepFam([],h,'');
% 
% dspls = h.trial.params.displacements;
% for didx = 1:length(dspls);
%     pnl_hs(didx) = pnl(didx).select();
%     
%     l = findobj(findobj(famfig,'tag','quickshow_inax'),'tag',num2str(dspls(didx)));
%     l = copyobj(l,pnl_hs(didx));
%     set(l,'color',[0 1 0]);
% end
% 
% 
% close(famfig)
% 
% axis(pnl_hs(:),'tight')
% 
% for r = 1:size(pnl_hs,1)
%     linkaxes(pnl_hs(r,:));
%     ylims = get(pnl_hs(r,1),'ylim');
%     for c=1:size(pnl_hs,2)
%         ylims_from = get(pnl_hs(r,c),'ylim');
%         ylims = [min(ylims(1),ylims_from(1)),...
%             max(ylims(2),ylims_from(2))];
%     end
%     set(pnl_hs(r,1),'ylim',ylims);
%     pnl(1).ylabel('pA');
%     pnl(1).xlabel('s');
% end
% set(pnl_hs(:),'xlim',[-.01 0.03])
% pnl.title(ac.name)
% 
% legend(pnl_hs(1),{'off','on'})
% legend(pnl_hs(1),'boxoff')
% 
% fn = fullfile(savedir,['Compensation_comp_' ac.name '.pdf']);
% 
% figure(fig)
% eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% 
% set(fig,'paperpositionMode','auto');
% saveas(fig,fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_AchI_RvF']),'fig');
% 
% 
