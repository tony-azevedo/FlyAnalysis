% Record of Contralateral stimulation with GCaMP imaging
% Record_GCaMP6s_Imaging only including cells with large signals in
% terminals

analysis_cells = {...
    '150128_F3_C1'
    '150203_F1_C1'
    '150203_F2_C1'
};
analysis_cells_comment = {...
    'Clear, nice'
    'No drift'
    'No signal, but there appears to be some global drift.  I think the objective was falling'
    };

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c);
    analysis_cell(c).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
    analysis_cell(c).comment = analysis_cells_comment(c);
end


%%
cnt = find(strcmp(analysis_cells,'150128_F3_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F3_C1\PiezoChirp_Raw_150128_F3_C1_33.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F3_C1\PiezoChirp_Raw_150128_F3_C1_45.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F3_C1\PiezoLongCourtshipSong_Raw_150128_F3_C1_11.mat';
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150203_F1_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F1_C1\PiezoChirp_Raw_150203_F1_C1_23.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F1_C1\PiezoChirp_Raw_150203_F1_C1_31.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F1_C1\PiezoLongCourtshipSong_Raw_150203_F1_C1_11.mat';
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150203_F2_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F2_C1\PiezoChirp_Raw_150203_F2_C1_41.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F2_C1\PiezoChirp_Raw_150203_F2_C1_51.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F2_C1\PiezoLongCourtshipSong_Raw_150203_F2_C1_21.mat';
analysis_cell(cnt).SineTrial = '';

%% PiezoChirp Up
for cnt = 1:length(analysis_cell)
    
    trial = load(analysis_cell(cnt).ChirpUpTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f(cnt) = PiezoChirpScimStackFamily([],obj,'');
    
    genotypedir = fullfile(savedir,analysis_cell(cnt).genotype);
    if ~isdir(genotypedir), mkdir(genotypedir); end
    
    cd(genotypedir)
    fn = ['Contra_ChirpScimUp_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
end

%% PiezoChirp Up ROIs
for cnt = 1:length(analysis_cell)
    
    trial = load(analysis_cell(cnt).ChirpUpTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f(cnt) = scimStackROI_fig(obj.trial,obj.trial.params);
    
    set(f(cnt),'color',[1 1 1]);
    
    genotypedir = fullfile(savedir,analysis_cell(cnt).genotype);
    if ~isdir(genotypedir), mkdir(genotypedir); end
    
    cd(genotypedir)
    fn = ['Contra_ROI_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
end

%% PiezoChirp Down
for cnt = 1:length(analysis_cell)
    
    trial = load(analysis_cell(cnt).ChirpDownTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f(cnt) = PiezoChirpScimStackFamily([],obj,'');
    
    genotypedir = fullfile(savedir,analysis_cell(cnt).genotype);
    if ~isdir(genotypedir), mkdir(genotypedir); end
    
    cd(genotypedir)
    fn = ['ChirpScimDown_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
end

%% PiezoChirp Max and min plots
Contra_fig = figure();
set(Contra_fig,'color',[1 1 1]);
clear baseline peak trough peak_sem trough_sem peak_freq trough_freq
panl = panel(Contra_fig);
panl.pack('v',{1/2,1/2});
panl(2).pack('h',{1/2 1/2})

ax = panl(1).select();
for cnt = 1:length(analysis_cell)
    
    trial = load(analysis_cell(cnt).ChirpUpTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    [baseline(cnt),...
        peak(cnt),...
        trough(cnt),...
        peak_sem(cnt),...
        trough_sem(cnt),...
        peak_freq(cnt),...
        trough_freq(cnt),...
        x,scimtraces] = PiezoChirpScimStackTraceAmplitudes(obj);

    col = [1 1 0]+(cnt-1)/length(peak)*[-1 -1 1];
    line(x,scimtraces,'parent',ax,'DisplayName',analysis_cell(cnt).name{1},...
        'color',col,...
        'linestyle','-')

end
axis(ax,'tight')
set(ax,'xlim',[-2 12])
ax1 = panl(2,1).select();
ax2 = panl(2,2).select();
for cnt = 1:length(peak)
    col = [1 1 0]+(cnt-1)/length(peak)*[-1 -1 1];
    line([1,2],[peak(cnt),trough(cnt)],'parent',ax1,'DisplayName',analysis_cell(cnt).name{1},...
        'color',col,...
        'linestyle','-',...
        'marker','o',...
        'markerfacecolor',col,...
        'markeredgecolor',col,...
        'markersize',2 ...
        )
    line([1,2],[peak_freq(cnt),trough_freq(cnt)],'parent',ax2,'DisplayName',analysis_cell(cnt).name{1},...
        'color',col,...
        'linestyle','-',...
        'marker','o',...
        'markerfacecolor',col,...
        'markeredgecolor',col,...
        'markersize',2 ...
        )
end

set([ax1,ax2],'xlim',[.5 2.5])
set([ax1,ax2],'XTick',[1, 2],'xtickLabel',{'Max','Min'},'xcolor',[0 0 0]);

ylabel(ax1,'\DeltaF/F (%)');
ylabel(ax2,'Frequency (Hz)');
panl.title('Chirp Up');

legend(panl(2,2).select(),'toggle','best');

cd(genotypedir)
fn = ['Peaks_Troughs_Contralateral_Up', ...
    '.pdf'];

eval(['export_fig ''' fn '''  -pdf -transparent'])

%% PiezoChirp Max and min plots Chirp Down
Contra_fig = figure();
set(Contra_fig,'color',[1 1 1]);
clear baseline peak trough peak_sem trough_sem peak_freq trough_freq
panl = panel(Contra_fig);
panl.pack('v',{1/2,1/2});
panl(2).pack('h',{1/2 1/2})

ax = panl(1).select();
for cnt = 1:length(analysis_cell)
    
    trial = load(analysis_cell(cnt).ChirpDownTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    [baseline(cnt),...
        peak(cnt),...
        trough(cnt),...
        peak_sem(cnt),...
        trough_sem(cnt),...
        peak_freq(cnt),...
        trough_freq(cnt),...
        x,scimtraces] = PiezoChirpScimStackTraceAmplitudes(obj);

    col = [1 1 0]+(cnt-1)/length(peak)*[-1 -1 1];
    line(x,scimtraces,'parent',ax,'DisplayName',analysis_cell(cnt).name{1},...
        'color',col,...
        'linestyle','-')

end
axis(ax,'tight')
set(ax,'xlim',[-2 12])
ax1 = panl(2,1).select();
ax2 = panl(2,2).select();
for cnt = 1:length(peak)
    col = [1 1 0]+(cnt-1)/length(peak)*[-1 -1 1];
    line([1,2],[peak(cnt),trough(cnt)],'parent',ax1,'DisplayName',analysis_cell(cnt).name{1},...
        'color',col,...
        'linestyle','-',...
        'marker','o',...
        'markerfacecolor',col,...
        'markeredgecolor',col,...
        'markersize',2 ...
        )
    line([1,2],[peak_freq(cnt),trough_freq(cnt)],'parent',ax2,'DisplayName',analysis_cell(cnt).name{1},...
        'color',col,...
        'linestyle','-',...
        'marker','o',...
        'markerfacecolor',col,...
        'markeredgecolor',col,...
        'markersize',2 ...
        )
end

set([ax1,ax2],'xlim',[.5 2.5])
set([ax1,ax2],'XTick',[1, 2],'xtickLabel',{'Max','Min'},'xcolor',[0 0 0]);

ylabel(ax1,'\DeltaF/F (%)');
ylabel(ax2,'Frequency (Hz)');
panl.title('Chirp Down');
panl.margintop = 8;

legend(panl(2,2).select(),'toggle','best');

cd(genotypedir)
fn = ['Peaks_Troughs_Contralateral_Down', ...
    '.pdf'];

eval(['export_fig ''' fn '''  -pdf -transparent'])


%% PiezoLongSong
for cnt = 1:length(analysis_cell)
    trial = load(analysis_cell(cnt).LongSongTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;

    f = PiezoSongScimFamily([],obj,'');
        
    cd(genotypedir)
    fn = ['LongSong_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
end

%% 
% reject_cells = {...
%     '150106_F1_C1'; 'Very bright terminals, probably due to damage, no responses';
%     '141210_F2_C1'; 'Pulled on the contralateral AN trying to stop the motion. no good';
%     '141211_F1_C1'; 'The attachement to the antenna was not good, too much glue, it torqued the antenna into a weird position';
%     '141211_F2_C1'; 'decent movement, but no response to courtship song';
%     '141211_F3_C1'; 'No signal.  Antenna was oriented in the wrong way wasn''t able to move correctly. Led to decision to reject quickly';
%     '141210_F1_C1'; 'Really dim, ';
%     '150106_F1_C1'; 'Very bright terminals, probably due to damage, no responses';
%     };
% 
% cnt = find(strcmp(reject_cells,'141210_F2_C1'));
% 
% reject_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F2_C1\PiezoChirp_Raw_141210_F2_C1_1.mat';
% reject_cell(cnt).ChirpDownTrial = '';
% reject_cell(cnt).LongSongTrial = '';
% reject_cell(cnt).SineTrial = '';
% 
% cnt = find(strcmp(reject_cells,'141211_F1_C1'));
% 
% reject_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoChirp_Raw_141211_F1_C1_1.mat';
% reject_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoChirp_Raw_141211_F1_C1_18.mat';
% reject_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoLongCourtshipSong_Raw_141211_F1_C1_1.mat';
% reject_cell(cnt).SineTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoSine_Raw_141211_F1_C1_1.mat';
% 
% cnt = find(strcmp(reject_cells,'141211_F2_C1'));
% 
% reject_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoChirp_Raw_141211_F2_C1_2.mat';
% reject_cell(cnt).ChirpDownTrial = '';
% reject_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoLongCourtshipSong_Raw_141211_F2_C1_1.mat';
% reject_cell(cnt).SineTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoSine_Raw_141211_F2_C1_1.mat';
% 
% cnt = find(strcmp(reject_cells,'141210_F1_C1'));
% 
% reject_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoChirp_Raw_141210_F1_C1_1.mat';
% reject_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoChirp_Raw_141210_F1_C1_9.mat';
% reject_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoLongCourtshipSong_Raw_141210_F1_C1_1.mat';
% reject_cell(cnt).SineTrial = '';
% 
