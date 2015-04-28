%% Record of Low Frequency Responsive Cells

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_LowFrequencyB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1
%%

analysis_cells = {...
'140128_F1_C1'
'140122_F2_C1'
'131015_F3_C1'
'130911_F2_C1'
'150402_F3_C2'
'150402_F1_C1'
'150326_F1_C1'
};

analysis_cells_comment = {...
    'Complete over harmonics, slight band pass';
    'coarse freq sample, single amplitude, VCLAMP data!';
    'coarse frequency, no current injections';
    'coarse frequency, no current injections';
};

analysis_cells_genotype = {...
'pJFRC7;VT30609'
'pJFRC7;VT30609'
'GH86;pJFRC7'
'pJFRC7;VT45599'
};

%%
clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%%

cnt = find(strcmp(analysis_cells,'140128_F1_C1'));

analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\CurrentStep_Raw_140128_F1_C1_15.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\CurrentStep_Raw_140128_F1_C1_10.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_100.mat'; % Combined with the earlier trial
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoStep_Raw_140128_F1_C1_1.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_6.mat';
};

%%
cnt = find(strcmp(analysis_cells,'140122_F2_C1'));
analysis_cell(cnt).exampletrials = {...
    % 'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_5.mat'; %VClamp
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\CurrentStep_Raw_140122_F2_C1_5.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_35.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoStep_Raw_140122_F2_C1_6.mat';
    };
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_16.mat';
};

%%

cnt = find(strcmp(analysis_cells,'131015_F3_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\PiezoSine_Raw_131015_F3_C1_43.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\PiezoStep_Raw_131015_F3_C1_1.mat';
    };
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_2.mat';
};

%% VT45599
cnt = find(strcmp(analysis_cells,'130911_F2_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\130911\130911_F2_C1\PiezoSine_Raw_130911_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\130911\130911_F2_C1\PiezoStep_Raw_130911_F2_C1_1.mat';
    };
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\130911\130911_F2_C1\PiezoSine_Raw_130911_F2_C1_1.mat';
};


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

            fn = fullfile(genotypedir,['LF_', ... 
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

%% Exporting PiezoSineOsciRespVsFreq info on cells with X-functions
close all
clear transfer freqs dsplcmnts        
cnt = 0;
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineOsciRespVsFreq',obj.currentPrtcl))
            cnt = cnt+1;
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            if exist('f','var') && ishandle(f), close(f),end
            
            hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
            [transfer{cnt},freqs{cnt},dsplcmnts{cnt}] = PiezoSineOsciRespVsFreq([],obj,'');
            f = findobj(0,'tag','PiezoSineOsciRespVsFreq');
            if save
            p = panel.recover(f);
            if isfield(obj.trial.params,'trialBlock'), tb = obj.trial.params.trialBlock;
            else tb = '';
            end
            fn = fullfile(genotypedir,['BP_' dateID '_' flynum '_' cellnum '_' num2str(tb) '_',...
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
pnl.pack('v',{2/3  1/3})  % response panel, stimulus panel
pnl.margin = [13 10 2 10];
pnl(1).marginbottom = 2;
pnl(2).marginleft = 12;

pnl(1).pack('h',length(all_dsplcmnts));

ylims = [0 -Inf];
for d_ind = 1:length(all_dsplcmnts)
    dspltranf = nan(length(transfer),length(all_freqs));
    ax = pnl(1,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(transfer)
        dspl = dsplcmnts{c_ind};
        d_i = find(round(dspl*10)/10 == all_dsplcmnts(d_ind));
        if isempty(d_i)
            continue
        end
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
        dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(:,d_i)))';
        
        plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i))),...
            'parent',ax,'linestyle','-','color',[.85 .85 .85],...
            'marker','.','markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85])
    end
    plot(all_freqs(~isnan(dspltranf(3,:))),nanmean(dspltranf(:,~isnan(dspltranf(3,:))),1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    % plot(all_freqs,nanmean(dspltranf,1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);

    set(ax,'xscale','log');
    
    ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
end
for d_ind = 1:length(all_dsplcmnts)
    set(pnl(1,d_ind).axis,'ylim',ylims);
end

%phases (all the same?)
pnl(2).pack('h',length(all_dsplcmnts));
for d_ind = 1:length(all_dsplcmnts)
    dsplphase = nan(length(transfer),length(all_freqs));
    ax = pnl(2,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(transfer)
        dspl = dsplcmnts{c_ind};
        d_i = find(round(dspl*10)/10 == all_dsplcmnts(d_ind));
        if isempty(d_i)
            continue
        end
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
        dsplphase(c_ind,af_i) = angle(transfer{c_ind}(:,d_i))';
        
        
    end
    for col_ind = 1:size(dsplphase,2);
        dsplphase(:,col_ind) = clusterPhases(dsplphase(:,col_ind));
    end
    %dsplphase = dsplphase/(2*pi)*360;
    plot(all_freqs,dsplphase,...
        'parent',ax,'linestyle','none','color',[.85 .85 .85],...
        'marker','.','markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85],...
        'tag',sprintf('%.2f',dsplcmnts{c_ind}(d_ind)))
    plot(all_freqs,nanmean(dsplphase,1),...
        'parent',ax,'linestyle','none','color',[.85 .85 .85],...
        'marker','.','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind)

    set(ax,'xscale','log');
    set(ax,'yticklabel',{'-\pi','0','\pi'});
end
for d_ind = 1:length(all_dsplcmnts)
     set(pnl(2,d_ind).select(),'YTick',[-pi,0, pi])
end

fn = fullfile(savedir,'LP_PiezoSineOsciRespVsFreq.pdf');
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1.4');
saveas(f, regexprep(fn,'.pdf',''), 'fig')

%% Exporting CurrentStepFamMatrix info on cells 
close all
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('CurrentStepFamMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            f = CurrentStepFamMatrix([],obj,'');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['LF_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'CurrentStepFamMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            end
        end
    end
end

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
            fn = fullfile(genotypedir,['LF_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoStepMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            end
        end
    end
end

%% Plot f2/f2 ratio for PiezoSine

%% Resting membrane potential
close all
vm_rest = nan(size(analysis_cell));
for c_ind = 1:length(analysis_cell)
    if isempty(analysis_cell(c_ind).baselinetrial{1}), continue,end
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
pnl.margin = [16 12 2 12];
ax = pnl(1).select(); hold(ax,'on')
colors = get(ax,'colorOrder');
colors = [colors; (2/3)*colors];

for c_ind = 1:length(analysis_cell)
    plot(c_ind,vm_rest(c_ind),...
        'parent',ax,'linestyle','none','color',colors(c_ind,:),...
        'marker','o','markerfacecolor',colors(c_ind,:),...
        'markeredgecolor',colors(c_ind,:))
end
set(ax,'ylim',[ -60 -22])
pnl(1).ylabel('Resting V_m (mV)')

fn = fullfile(savedir,'LF_Vm_rest.pdf');
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1');
saveas(f, regexprep(fn,'.pdf',''), 'fig')

%% Spontaneous oscillations

close all

fig = figure;
pnl = panel(fig);
pnl.pack('v',{1/3 2/3})  % response panel, stimulus panel
pnl.margin = [16 12 2 10];
ax = pnl(1).select(); hold(ax,'on');

colors = get(ax,'colorOrder');
colors = [colors; (2/3)*colors];

% plot the FFT of spontaneous oscilations
% get the peak
peak = nan(size(analysis_cell));
spontFreq = peak;

for c_ind = 1:length(analysis_cell)
    if isempty(analysis_cell(c_ind).baselinetrial{1}), continue,end
    trial = load(analysis_cell(c_ind).baselinetrial{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    t = makeInTime(obj.trial.params);
    if ~isempty(strfind(obj.currentPrtcl,'Sweep'))
        t_ind = ~isnan(t);
    elseif ~isempty(strfind(obj.currentPrtcl,'PiezoChirp'))
        t_ind = t>(t(end)-3);
    else
        t_ind = t>(t(end)-trial.params.postDurInSec);
    end
    x = t(t_ind);
    y = obj.trial.voltage(t_ind);
    
    % section for averaging
    dT = .5;
    dX = sum(x<x(1)+dT);
    x_mat = reshape(x,dX,[]);
    y_mat = reshape(y,dX,[]);
    
    f_ = trial.params.sampratein/dX*[0:dX/2]; f_ = [f_, fliplr(f_(2:end-1))];

    Y_mat = fft(y_mat,[],1);    
    Y_mat = real(conj(Y_mat).*Y_mat);
    %figure; loglog(f,Y_mat), pause, close(gcf);

    mean_Y_mat = mean(Y_mat,2);
    ax = pnl(1).select(); hold(ax,'on');
    plot(f_,mean_Y_mat,...
        'parent',ax,'linestyle','-','color',colors(c_ind,:),...
        'marker','none','markerfacecolor',colors(c_ind,:),...
        'markeredgecolor',colors(c_ind,:))
    
    [peak(c_ind),f_ind] = max(mean_Y_mat(f_>10&f_<1000));
    spontFreq(c_ind) = f_(f_ind+(sum(f_<=10)+1)/2);
    
    plot(spontFreq(c_ind),peak(c_ind),...
        'parent',ax,'linestyle','none','color',colors(c_ind,:),...
        'marker','o','markerfacecolor','none',...
        'markeredgecolor',colors(c_ind,:))
end

set(ax,'xscale','log','yscale','log')
set(ax,'xlim',[10 1000])
pnl(1).ylabel('Power (mV^2/Hz^2)')
pnl(1).xlabel('Frequency (Hz)')

%% Plot the spontaneous oscillations versus the peak freqency sensitivity

clear transfer freqs dsplcmnts 
selectFreq = nan(size(spontFreq));
log_switch = nan(size(spontFreq));
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoChirpZAP',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;
            [~,~,transfer,f_sampled] = PiezoChirpZAP([],obj,'','plot',0);
            [trpk,f_ind] = max(transfer(f_sampled > 25 ... %min(trial.params.freqStart,trial.params.freqEnd) ...
                                    & f_sampled < max(trial.params.freqStart,trial.params.freqEnd)));
            selectFreq(c_ind) = f_sampled(f_ind+sum(f_sampled <= 25));
            log_switch(c_ind) = 1;
            break

        elseif ~isempty(strfind('PiezoSineOsciRespVsFreq',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;
            
            [transfer,freqs,dsplcmnts] = PiezoSineOsciRespVsFreq([],obj,'','plot',0);
            tr = real(abs(transfer));
            [trpk,inds] = max(tr,[],1);
            
            selectFreq(c_ind) = mean(freqs(inds));
            log_switch(c_ind) = 0;
        end
    end
end
log_switch(isnan(log_switch)) = 0;
ax = pnl(2).select(); hold(ax,'on');

colors = get(ax,'colorOrder');
colors = [colors; (2/3)*colors];
for c_ind = 1:length(analysis_cell)
    l = plot(spontFreq(c_ind), selectFreq(c_ind),'parent',ax, ...
        'linestyle','none','color',[0 0 0],...
        'marker','o','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0]);
    if log_switch(c_ind)
    set(l,...
        'markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85])
    
    end
end
set(ax,'xscale','log','yscale','log')
set(ax,'xlim',[10 1000],'ylim',[10 300])
l_chirp = findobj(ax,'markerfacecolor',[.85 .85 .85]);
l_sine = findobj(ax,'markerfacecolor',[0 0 0]);
if ~isempty(l_chirp) && ~ isempty(l_sine)
    legend([l_chirp(1),l_sine(1)],{'chirp','sine'});
elseif ~isempty(l_chirp)
    legend(l_chirp(1),{'chirp'});
elseif ~isempty(l_sine)
    legend(l_sine(1),{'sine'});
end
pnl(2).ylabel('Preferred Freq (Hz)')
pnl(2).xlabel('Spontaneous Freq (Hz)')

figure(fig)
fn = fullfile(savedir,'LF_SelectivityVsSpontaneous.pdf');
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1');
