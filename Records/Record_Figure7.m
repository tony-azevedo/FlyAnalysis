%% Record of V-gated conductance analysis
clear all, close all

Record_VClampCurrentIsolation_Cells

savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation';


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

