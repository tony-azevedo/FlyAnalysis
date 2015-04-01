%% PiezoChirp Up
for cnt = 1:length(analysis_cell)
    if isempty(analysis_cell(cnt).ChirpUpTrial)
        continue
    end
    trial = load(analysis_cell(cnt).ChirpUpTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f = PiezoChirpScimStackFamily([],obj,'');
    
    genotypedir = fullfile(savedir,analysis_cell(cnt).genotype);
    if ~isdir(genotypedir), mkdir(genotypedir); end
    
    cd(genotypedir)
    fn = [SidePart, ...
        '_ChirpScimUp_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
    saveas(f, fn(1:end-4),'fig')
end

close all
%% PiezoChirp Up ROIs
for cnt = 1:length(analysis_cell)
    if isempty(analysis_cell(cnt).ChirpUpTrial)
        continue
    end
    trial = load(analysis_cell(cnt).ChirpUpTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f = scimStackChan2Mask_Fig(obj.trial,obj.trial.params);
    
    set(f,'color',[1 1 1]);
    panl = panel.recover(f);
    panl(2).title(analysis_cell(cnt).comment)
    
    genotypedir = fullfile(savedir,analysis_cell(cnt).genotype);
    cd(genotypedir)
    fn = [SidePart, ...
        '_Mask_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
    saveas(f, fn(1:end-4),'fig')
end
close all

%% PiezoChirp Up ROIs
for cnt = 1:length(analysis_cell)
    if isempty(analysis_cell(cnt).ChirpUpTrial)
        continue
    end
    trial = load(analysis_cell(cnt).ChirpUpTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f = scimStackChan2Mask_FigAlgrthm(obj.trial,obj.trial.params);
    
    set(f,'color',[1 1 1]);
    panl = panel.recover(f);
    panl(2).title(analysis_cell(cnt).comment)
    
    genotypedir = fullfile(savedir,analysis_cell(cnt).genotype);
    cd(genotypedir)
    fn = [SidePart, ...
        '_MaskAlgrthm_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
    saveas(f, fn(1:end-4),'fig')
end
close all

%% PiezoChirp Down
for cnt = 1:length(analysis_cell)
    if isempty(analysis_cell(cnt).ChirpDownTrial)
        continue
    end
    trial = load(analysis_cell(cnt).ChirpDownTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f = PiezoChirpScimStackFamily([],obj,'');
    
    genotypedir = fullfile(savedir,analysis_cell(cnt).genotype);
    if ~isdir(genotypedir), mkdir(genotypedir); end
    
    cd(genotypedir)
    fn = [SidePart, ...
        '_ChirpScimDown_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
    saveas(f, fn(1:end-4),'fig')
end
close all

%% PiezoLongSong
for cnt = 1:length(analysis_cell)
    if isempty(analysis_cell(cnt).LongSongTrial)
        continue
    end
    trial = load(analysis_cell(cnt).LongSongTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f = PiezoSongScimFamily([],obj,'');
    
    cd(genotypedir)
    fn = [SidePart, ...
        '_LongSong_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        '.pdf'];
    
    eval(['export_fig ''' fn '''  -pdf -transparent'])
    saveas(f, fn(1:end-4),'fig')
end

close all

%% PiezoChirp Max and min plots
Ipsi_fig = figure();
set(Ipsi_fig,'color',[1 1 1]);
clear baseline peak trough peak_sem trough_sem peak_freq trough_freq
panl = panel(Ipsi_fig);
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
fn = [SidePart, ...
    '_Peaks_Troughs_Up', ...
    '.pdf'];

eval(['export_fig ''' fn '''  -pdf -transparent'])
saveas(Ipsi_fig, fn(1:end-4),'fig')

eval([SidePart '_up_fig = Ipsi_fig'])

%% PiezoChirp Max and min plots Chirp Down
Ipsi_fig = figure();
set(Ipsi_fig,'color',[1 1 1]);
clear baseline peak trough peak_sem trough_sem peak_freq trough_freq
panl = panel(Ipsi_fig);
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
fn = [SidePart, ...
    '_Peaks_Troughs_Down', ...
    '.pdf'];

eval(['export_fig ''' fn '''  -pdf -transparent'])
saveas(Ipsi_fig, fn(1:end-4),'fig')

eval([SidePart '_down_fig = Ipsi_fig'])

%% PiezoSong Max and min plots Song
Ipsi_fig = figure();
set(Ipsi_fig,'color',[1 1 1]);
clear baseline peak trough peak_sem trough_sem peak_freq trough_freq
panl = panel(Ipsi_fig);
panl.pack('v',{1/2,1/2});
panl(2).pack('h',{1/2 1/2})

ax = panl(1).select();
for cnt = 1:length(analysis_cell)
    
    trial = load(analysis_cell(cnt).LongSongTrial);
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
        x,scimtraces] = PiezoLongSongScimStackTraceAmplitudes(obj);
    
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
%     line([1,2],[peak_freq(cnt),trough_freq(cnt)],'parent',ax2,'DisplayName',analysis_cell(cnt).name{1},...
%         'color',col,...
%         'linestyle','-',...
%         'marker','o',...
%         'markerfacecolor',col,...
%         'markeredgecolor',col,...
%         'markersize',2 ...
%         )
end

set([ax1,ax2],'xlim',[.5 2.5])
set([ax1,ax2],'XTick',[1, 2],'xtickLabel',{'Max','Min'},'xcolor',[0 0 0]);

ylabel(ax1,'\DeltaF/F (%)');
ylabel(ax2,'Frequency (Hz)');
panl.title('Song');
panl.margintop = 8;

legend(panl(2,2).select(),'toggle','best');

cd(genotypedir)
fn = [SidePart, ...
    '_Peaks_Troughs_Song', ...
    '.pdf'];

eval(['export_fig ''' fn '''  -pdf -transparent'])
saveas(Ipsi_fig, fn(1:end-4),'fig')

eval([SidePart '_song_fig = Ipsi_fig'])
