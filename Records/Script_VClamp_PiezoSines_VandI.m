
% ac_ind = 15; %1:length(analysis_cells)
% ac = analysis_cell(ac_ind);
% disp(ac.name);

%%
close all
yyddmm = ac.name(1:6);
trial = load([fullfile('C:\Users\tony\Raw_Data\',yyddmm,ac.name) '\PiezoSine_Raw_' ac.name '_1.mat']);  
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

% VClamp
trial = load(VClampCtrlSineTrial);
h = getShowFuncInputsFromTrial(trial);

% [fig, pnl_hs,stimpnl_hs] = PF_PiezoSineMatrix([],h,ac.genotype);
% if isempty(strfind(ac.genotype,'VT30609'))
%     set(pnl_hs(:),'ylim',[-60 40])
% else
%     set(pnl_hs(:),'ylim',[-20 10])
% end
% savePDF(fig,savedir,'VClampPiezoSineMatrices',[ac.name, '_VClamp']);
% 
% set(pnl_hs(:),'xlim',[-.02 .08])
% set(stimpnl_hs(:),'xlim',[-.02 .08])
% savePDF(fig,savedir,'VClampPiezoSineOnset',[ac.name, '_VClamp']);
% 
% [fig, pnl_hs] = PF_PiezoSineCycleMatrix([],h,ac.genotype);
% if isempty(strfind(ac.genotype,'VT30609'))
%     set(pnl_hs(:),'ylim',[-60 40])
% else
%     set(pnl_hs(:),'ylim',[-20 10])
% end
% 
% savePDF(fig,savedir,'VClampPiezoSineCycles',[ac.name, '_VClamp']);

if ~isempty(strfind(ac.comment,'A2'))
fig2 = PF_PiezoSineDepolRespVsFreq_Current([],h,ac.genotype);
savePDFandFIG(fig2,savedir,'VClampPiezoSineRvF',[ac.name, '_VClamp_RvF']);
else
fig2 = PF_PiezoSineOsciRespVsFreq([],h,ac.genotype);
savePDFandFIG(fig2,savedir,'VClampPiezoSineRvF',[ac.name, '_VClamp_RvF']);
end
close(fig2)


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
    
    
