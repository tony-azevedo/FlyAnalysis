%% Controls for the effects of displacing the antenna slightly
clear all
analysis_grid = {
'151103_F3_C1'  'ShakB y/X;pJFRC7/+;45D07-Gal4'    'offsets 5 6.5 8 3.5 2 voltage'
'151104_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'offsets 5 6.5 8 3.5 2 currents'
'151104_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'offsets 5 8 2 currents'
'151106_F1_C3'  'ShakB y/X;pJFRC7/+;45D07-Gal4'     'offsets 5 6.5 8 3.5 2 voltage'
'151108_F2_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'offsets 5 8 2 currents'
'151109_F1_C1'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'offsets 5 8 2 currents'
'151109_F1_C2'  'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'    'offsets 5 8 2 currents'
}

savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_PiezoOffsets';

if ~isdir(savedir)
    mkdir(savedir)
end

clear analysis_cell analysis_cells
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end


%%
ac_ind = 6;
ac = analysis_cell(ac_ind);

close all
yyddmm = ac.name(1:6);
trial = load([fullfile('C:\Users\Anthony Azevedo\Raw_Data\',yyddmm,ac.name) '\PiezoStep_Raw_' ac.name '_20.mat']);
h = getShowFuncInputsFromTrial(trial);

fig = figure;
set(fig,'color',[1 1 1],'position',[680 85 1027 893],'name','Piezo Offset Comparison');
pnl = panel(fig);
pnl.pack(length(analysis_cell)+1,length(trial.params.displacements));

for ac_ind = 1:length(analysis_cell)
    ac = analysis_cell(ac_ind);
    yyddmm = ac.name(1:6);
    trial = load([fullfile('C:\Users\Anthony Azevedo\Raw_Data\',yyddmm,ac.name) '\PiezoStep_Raw_' ac.name '_20.mat']);
    h = getShowFuncInputsFromTrial(trial);
    
    % VClamp
    VClampCtrlStepTrial = [];
    IClampCtrlStepTrial = [];
    
    for didx = 1:length(h.prtclData)
        if isempty(h.prtclData(didx).tags)
            if ...
                    isempty(VClampCtrlStepTrial) && ...
                    strcmp(h.prtclData(didx).mode,'VClamp') && ...
                    h.prtclData(didx).displacementOffset==5;
                
                VClampCtrlStepTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
            end
            if ...
                    isempty(IClampCtrlStepTrial) && ...
                    strcmp(h.prtclData(didx).mode,'IClamp') && ...
                    h.prtclData(didx).displacementOffset==5;
                
                IClampCtrlStepTrial = fullfile(h.dir,sprintf(h.trialStem,h.prtclData(didx).trial));
            end
        end
    end
    
    % if ~isdir(fullfile(savedir,'PiezoSine'))
    %     mkdir(fullfile(savedir,'PiezoSine'))
    % end
    
    % IClamp
    if ~isempty(VClampCtrlStepTrial)
        CondTrial = VClampCtrlStepTrial;
    elseif ~isempty(IClampCtrlStepTrial)
        CondTrial = IClampCtrlStepTrial;
    end
    
    if ~isempty(CondTrial)
        trial = load(CondTrial);
        h = getShowFuncInputsFromTrial(trial);
        
        BT = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'trialBlock','displacementOffset'});
        t = 1;
        while t <= length(BT)
            trials = findLikeTrials('trial',BT(t),'datastruct',h.prtclData);
            BT = setdiff(BT,setdiff(trials,BT(t)));
            t = t+1;
        end
        
        clrs = repmat(linspace(0,.9,length(BT))',1,3);
        for bidx = 1:length(BT)
            h.trial = load(fullfile(h.dir,sprintf(h.trialStem,BT(bidx))));
            h = getShowFuncInputsFromTrial(h.trial);
            famfig = PF_PiezoStepFam([],h,ac.genotype);
            
            dspls = h.trial.params.displacements;
            for didx = 1:length(dspls);
                pnl_hs(ac_ind,didx) = pnl(ac_ind,didx).select();
                
                l = findobj(findobj(famfig,'tag','quickshow_inax'),'tag',num2str(dspls(didx)));
                l = copyobj(l,pnl_hs(ac_ind,didx));
                set(l,'color',clrs(bidx,:));
            end
        end
    end
    close(famfig)
end

axis(pnl_hs(:),'tight')

for r = 1:size(pnl_hs,1)
    linkaxes(pnl_hs(r,:));
    ylims = get(pnl_hs(r,1),'ylim');
    for c=1:size(pnl_hs,2)
        ylims_from = get(pnl_hs(r,c),'ylim');
        ylims = [min(ylims(1),ylims_from(1)),...
            max(ylims(2),ylims_from(2))];
    end
    set(pnl_hs(r,1),'ylim',ylims);
    pnl(r,1).ylabel(ac.name);
end
set(pnl_hs(:),'xlim',[-.01 0.03])

for r = 1:size(pnl_hs,1)
    pnl(r,1).ylabel(analysis_cell(r).name);
end


fn = fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_AchI_RvF.pdf']);

figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig2,'paperpositionMode','auto');
saveas(fig2,fullfile(savedir,'PiezoSine',[ac.name, '_IClamp_AchI_RvF']),'fig');


