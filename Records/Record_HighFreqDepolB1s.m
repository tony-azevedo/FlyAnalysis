%% Record of High Frequency Responsive B1 cells
clear all

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_HighFrequencyB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

% GH86

% VT30609
cnt = 1;
analysis_cell(cnt).name = {
    '140530_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\PiezoChirp_Raw_140530_F1_C1_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\PiezoStep_Raw_140530_F1_C1_33.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\PiezoChirp_Raw_140530_F1_C1_10.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
''
};


cnt = 2;
analysis_cell(cnt).name = {
    '140530_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_10.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_24.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_6.mat';
%'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_6.mat'; %VClamp
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_88.mat'; %Iclamp
%'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_270.mat'; %Long Vclamp
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoStep_Raw_140530_F2_C1_1.mat';
%'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_315.mat'; % Long Iclamp
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\PiezoChirp_Raw_140530_F1_C1_12.mat'; 
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_7.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
''
};


cnt = 3;
analysis_cell(cnt).name = {
    '131211_F1_C2';
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_56.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoStep_Raw_131211_F1_C2_1.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentSine_Raw_131211_F1_C2_16.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_3.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
''
};

%% Exporting PiezoStepMatrix info on cells 
close all
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoStepMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            f = PiezoStepMatrix([],obj,'');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['HP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoStepMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            
            f2 = findobj(0,'tag','PiezoStepMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'PiezoStepMatrix','PiezoStepMat_Stim');
            p.export(fn, '-rp','-l');

            end
        end
    end
end

%% Exporting PiezChirpMatrix info on cells
close all
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoChirpMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            f = PiezoChirpMatrix([],obj,'');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['HP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoChirpMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            
            f2 = findobj(0,'tag','PiezoChirpMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'PiezoChirpMatrix','PiezoChirpMat_Stim');
            p.export(fn, '-rp','-l');

            end
        end
    end
end

%% Exporting PiezoSineMatrix info on cells 
close all
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;
            
            
            f = PiezoSineMatrix([],obj,'');
            if save
            p = panel.recover(f);

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            fn = fullfile(genotypedir,['HP_', ... 
                dateID '_', ...
                flynum '_', ... 
                cellnum '_', ... 
                num2str(obj.trial.params.trialBlock) '_',...
                'PiezoSineMatrix', ...
                '.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l');

            f2 = findobj(0,'tag','PiezoSineMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'PiezoSineMatrix','PiezoSineMat_Stim');
            p.export(fn, '-rp','-l');
            end
        end
    end
end


%% Exporting PiezoSineDepolRespVsFreq info on cells 
close all
clear area freqs        
cnt = 0;
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineDepolRespVsFreq',obj.currentPrtcl))
            cnt = cnt+1;
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            if exist('f','var') && ishandle(f), close(f),end
            [area{cnt},freqs{cnt},dsplcmnts{cnt},amp{cnt}] = PiezoSineDepolRespVsFreq([],obj,'');
            f = findobj(0,'tag','PiezoSineDepolRespVsFreq');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['HP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoSineOsciRespVsFreq.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l','-a1.4');
            end
        end
    end
end

% Count the number of displacements, etc
all_dsplcmnts = [];
for d_ind = 1:length(dsplcmnts) 
    all_dsplcmnts = [all_dsplcmnts,dsplcmnts{d_ind}];
end
all_dsplcmnts = sort(unique(all_dsplcmnts));

all_freqs = [];
for d_ind = 1:length(freqs) 
    all_freqs = [all_freqs,round(freqs{d_ind}*100)/100];
end
all_freqs = sort(unique(all_freqs));

% Plotting transfer from all cells
f = figure;
pnl = panel(f);
pnl.pack('v',{1/2  1/2})  % response panel, stimulus panel
pnl.margin = [13 10 2 10];
pnl(1).marginbottom = 2;
pnl(2).marginleft = 12;

pnl(1).pack('h',length(all_dsplcmnts));

ylims = [0 -Inf];
for d_ind = 1:length(all_dsplcmnts)
    dspltranf = nan(length(area),length(all_freqs));
    ax = pnl(1,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(area)
        dspl = dsplcmnts{c_ind};
        d_i = find(round(dspl*10)/10 == all_dsplcmnts(d_ind));
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
        dspltranf(c_ind,af_i) = area{c_ind}(:,d_i)';
        
        plot(freqs{c_ind},area{c_ind}(:,d_i),...
            'parent',ax,'linestyle','-','color',[.85 .85 .85],...
            'marker','.','markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85],...
            'tag',sprintf('%.2f',dsplcmnts{c_ind}(d_ind)))
    end
    plot(all_freqs,nanmean(dspltranf,1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    set(ax,'xscale','log');
    
    ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
end
for d_ind = 1:length(all_dsplcmnts)
    set(pnl(1,d_ind).axis,'ylim',ylims);
end

% amp 
pnl(2).pack('h',length(all_dsplcmnts));
for d_ind = 1:length(all_dsplcmnts)
    dsplamp = nan(length(amp),length(all_freqs));
    ax = pnl(2,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(amp)
        dspl = dsplcmnts{c_ind};
        d_i = find(round(dspl*10)/10 == all_dsplcmnts(d_ind));
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
        dsplamp(c_ind,af_i) = amp{c_ind}(:,d_i)';
    
        plot(freqs{c_ind},amp{c_ind}(:,d_i),...
            'parent',ax,'linestyle','-','color',[.85 .85 .85],...
            'marker','.','markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85],...
            'tag',sprintf('%.2f',dsplcmnts{c_ind}(d_ind)))

    end
    plot(all_freqs,nanmean(dsplamp,1),...
        'parent',ax,'linestyle','-','color',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'marker','none','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind)

    set(ax,'xscale','log');
    ylims = [min(ylims(1),min(dsplamp(:))) max(ylims(2),max(dsplamp(:)))];
end
for d_ind = 1:length(all_dsplcmnts)
    set(pnl(2,d_ind).axis,'ylim',ylims);
end
pnl(1).ylabel('Area (mV s)')
pnl(2).ylabel('Peak (mV)')
pnl(2).xlabel('Frequency (Hz)')

fn = fullfile(savedir,['HP_',...
    'PiezoSineDepolRespVsFreq.pdf']);
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1.4');
saveas(f, regexprep(fn,'.pdf',''), 'fig')


%% Resting membrane potential
close all
for c_ind = 1:length(analysis_cell)
    trial = load(analysis_cell(c_ind).baselinetrial{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    t = makeInTime(obj.trial.params);
    if t(1)<0;
        vm_rest(c_ind) = mean(obj.trial.voltage(t<0));
    else
        vm_rest(c_ind) = mean(obj.trial.voltage(t<1));
    end
end
f = figure;
pnl = panel(f);
pnl.pack(1)  % response panel, stimulus panel
pnl.margin = [13 10 2 10];
ax = pnl(1).select();
plot(vm_rest,...
    'parent',ax,'linestyle','none','color',[1 0 0],...
    'marker','.','markerfacecolor',[1 0 0],...
    'markeredgecolor',[1 0 0])
set(ax,'ylim',[ -60 -22])
pnl(1).ylabel('Resting V_m (mV)')

fn = fullfile(savedir,['HP_',...
    'Vm_rest.pdf']);
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1');

saveas(f, regexprep(fn,'.pdf',''), 'fig')
