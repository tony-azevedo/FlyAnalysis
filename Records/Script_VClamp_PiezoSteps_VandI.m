
%ac_ind = 19; %1:length(analysis_cell)
%ac = analysis_cell(ac_ind);
% disp(ac.name);

%%
close all
yyddmm = ac.name(1:6);
trial = load([fullfile('C:\Users\tony\Raw_Data\',yyddmm,ac.name) '\PiezoStep_Raw_' ac.name '_1.mat']);  
h = getShowFuncInputsFromTrial(trial);

% VClamp
VClampCtrlStepTrial = [];
IClampCtrlStepTrial = [];
VClampAchIStepTrial = [];
VClampTTXStepTrial = [];

for didx = 1:length(h.prtclData)
    if isempty(h.prtclData(didx).tags)
        if ...
                isempty(VClampCtrlStepTrial) && ...
                strcmp(h.prtclData(didx).mode,'VClamp')
            
            excluded = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial)),'excluded');
            if ~isempty(fieldnames(excluded)) && excluded.excluded
                continue
            end
            VClampCtrlStepTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
        end
        if ...
                isempty(IClampCtrlStepTrial) && ...
                strcmp(h.prtclData(didx).mode,'IClamp')
            
            IClampCtrlStepTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
        end
    end
    if sum(strcmp(h.prtclData(didx).tags,'curare')) && isempty(VClampAchIStepTrial) && ...
            strcmp(h.prtclData(didx).mode,'VClamp')
        
            VClampAchIStepTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
    end
    if sum(strcmp(h.prtclData(didx).tags,'TTX')) && isempty(VClampTTXStepTrial) && ...
            strcmp(h.prtclData(didx).mode,'VClamp')
        
            VClampTTXStepTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
    end
end

% VClamp
trial = load(VClampCtrlStepTrial);
h = getShowFuncInputsFromTrial(trial);

[fig] = PF_PiezoStepMatrix([],h,ac.genotype);
% [fig, pnl_hs] = PF_PiezoStepFam2([],h,ac.genotype);
% [fig, pnl_hs] = PF_PiezoStepFamPnl([],h,ac.genotype);
%set(pnl_hs(:),'ylim',[-35 20])
savePDF(fig,savedir,'VClampPiezoStep',[ac.name, '_VClamp']);

