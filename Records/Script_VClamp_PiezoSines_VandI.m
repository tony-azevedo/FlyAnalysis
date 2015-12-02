
close all
yyddmm = ac.name(1:6);
trial = load([fullfile('C:\Users\Anthony Azevedo\Raw_Data\',yyddmm,ac.name) '\PiezoSine_Raw_' ac.name '_1.mat']);  
h = getShowFuncInputsFromTrial(trial);

% VClamp
VClampCtrlSineTrial = [];
IClampCtrlSineTrial = [];
VClampAchISineTrial = [];

for didx = 1:length(h.prtclData)
    if isempty(h.prtclData(didx).tags)
        if ...
                isempty(VClampCtrlSineTrial) && ...
                strcmp(h.prtclData(didx).mode,'VClamp')
            
            excluded = load(fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial)),'excluded');
            if ~isempty(fieldnames(excluded)) && excluded.excluded
                continue
            end
            VClampCtrlSineTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
        end
        if ...
                isempty(IClampCtrlSineTrial) && ...
                strcmp(h.prtclData(didx).mode,'IClamp')
            
            IClampCtrlSineTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
        end
    end
    if sum(strcmp(h.prtclData(didx).tags,'curare')) && isempty(VClampAchISineTrial) && ...
            strcmp(h.prtclData(didx).mode,'VClamp')
        
            VClampAchISineTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
    end
end

if ~isdir(fullfile(savedir,'PiezoSine'))
    mkdir(fullfile(savedir,'PiezoSine'))
end

% VClamp
trial = load(VClampCtrlSineTrial);
h = getShowFuncInputsFromTrial(trial);

[fig, pnl_hs] = PF_PiezoSineMatrix([],h,ac.genotype);
set(pnl_hs(:),'ylim',[-35 20])

savePDFandFIG(fig,savedir,'PiezoSine',[ac.name, '_VClamp']);


% fig2 = PF_PiezoSineOsciRespVsFreq([],h,ac.genotype);
% 
% fn = fullfile(savedir,'PiezoSine',[ac.name, '_VClamp_RvF.pdf']);
% 
% figure(fig2)
% eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% 
% set(fig2,'paperpositionMode','auto');
% saveas(fig2,fullfile(savedir,'PiezoSine',[ac.name, '_VClamp_RvF']),'fig');
% 
% close(fig)
% close(fig2)


% % IClamp
% if ~isempty(IClampCtrlSineTrial)
%     trial = load(IClampCtrlSineTrial);
%     h = getShowFuncInputsFromTrial(trial);
%     
%     fig = PF_PiezoSineMatrix([],h,ac.genotype);
%     
%     fn = fullfile(savedir,'PiezoSine',[ac.name, '_IClamp.pdf']);
%     
%     figure(fig)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
%     
%     set(fig,'paperpositionMode','auto');
%     saveas(fig,fullfile(savedir,'PiezoSine',[ac.name, '_IClamp']),'fig');
%     
%     fig2 = PF_PiezoSineOsciRespVsFreq([],h,ac.genotype);
%     
%     fn = fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_RvF.pdf']);
%     
%     figure(fig2)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
%     
%     set(fig2,'paperpositionMode','auto');
%     saveas(fig2,fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_RvF']),'fig');
%     
%     close(fig)
%     close(fig2)
% end
% 
% % VClamp Drugs
% if ~isempty(VClampAchISineTrial)
%     trial = load(VClampAchISineTrial);
%     h = getShowFuncInputsFromTrial(trial);
%     
%     fig = PF_PiezoSineMatrix([],h,ac.genotype);
%     
%     fn = fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_AchI.pdf']);
%     
%     figure(fig)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
%     
%     set(fig,'paperpositionMode','auto');
%     saveas(fig,fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_AchI']),'fig');
%     
%     fig2 = PF_PiezoSineOsciRespVsFreq([],h,ac.genotype);
% 
%     fn = fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_AchI_RvF.pdf']);
%     
%     figure(fig2)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
%     
%     set(fig2,'paperpositionMode','auto');
%     saveas(fig2,fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_AchI_RvF']),'fig');
%     
%     close(fig)
%     close(fig2)
%     
% end
    
    






