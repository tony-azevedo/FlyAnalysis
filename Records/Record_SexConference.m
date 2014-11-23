%% Code for the Gordon Conference poster.
savedir = 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab';
JunctionPotential = 13; % Gouwens and Wilson

%% Frequency responses

close all
figure(1)
clear analysis_cell

cnt = 1;  % Low frequency
analysis_cell(cnt).name = {...  % 131015_F3_C1
    '140128_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_81.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoStep_Raw_140128_F1_C1_1.mat';
    };

cnt = 2; % Mid frequency
analysis_cell(cnt).name = {
    '131122_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoStep_Raw_131122_F2_C1_1.mat';
};

cnt = 3; % Mid frequency Spiking
analysis_cell(cnt).name = {
    '131126_F2_C2';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_9.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
};


cnt = 4; % High Freq rectifying.
analysis_cell(cnt).name = {
    '131211_F1_C2'; 
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_56.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoStep_Raw_131211_F1_C2_1.mat';
    };

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 8.7]);
pnl = panel(fig);
pnl.pack(4,4)  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 6;

for c_ind = 1:length(analysis_cell)
    % for display use freqs:
    freqs = [25,100,200,400];
    
    % for display use displacements:
    displacements = [.2];
    
    trial = load(analysis_cell(c_ind).exampletrials{1});
    
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;    
    
    blocktrials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData,'exclude',{'displacement','freq'});
    for bt = blocktrials;
        obj.trial = load(fullfile(obj.dir,sprintf(obj.trialStem,bt)));
        freq = round(obj.trial.params.freq);
        dspl = round(obj.trial.params.displacement*10)/10;
        if (sum(freq == freqs) && sum(dspl == displacements))
            f_ind = find(freq == freqs);
            t_fig = PiezoSineAverage([],obj,'');
            
            pnl(f_ind,c_ind).pack('v',{5/6 1/6})
            pnl(f_ind,c_ind).marginbottom = 2;

            to_ax = pnl(f_ind,c_ind,1).select();
            copyobj(findobj(findobj(t_fig,'tag','response_ax'),'type','line'),to_ax);
            
            axis(to_ax,'tight')
            set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out')
            if c_ind~=1
                set(to_ax,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
            else
                set(to_ax,'YTick',[-45 -25],'YTickLabel',{'-45' '-25'});
            end
            set(to_ax,'xlim',[-.1  .4],'ylim',[-48.5390  -20.9780])
            
            to_ax = pnl(f_ind,c_ind,2).select();
            axes(to_ax)
            copyobj(findobj(findobj(t_fig,'tag','stimulus_ax'),'type','line'),to_ax);
            axis(to_ax,'tight')
            set(to_ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
            set(to_ax,'xlim',[-.1  .4])
            
            freqs(f_ind) = nan;
        end
    end
end
figure(fig)
pnl.xlabel('Time (s)');
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab\FrequencySelectivityTraces.pdf'

%% Frequency responses single traces, junction potential corrected.

close all
figure(1)
clear analysis_cell

cnt = 1;  % Low frequency
analysis_cell(cnt).name = {...  % 131015_F3_C1
    '140128_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_81.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoStep_Raw_140128_F1_C1_1.mat';
    };

cnt = 2; % Mid frequency
analysis_cell(cnt).name = {
    '131122_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoStep_Raw_131122_F2_C1_1.mat';
};

cnt = 3; % Mid frequency Spiking
analysis_cell(cnt).name = {
    '131126_F2_C2';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_9.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
};


cnt = 4; % High Freq rectifying.
analysis_cell(cnt).name = {
    '131211_F1_C2'; 
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_56.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoStep_Raw_131211_F1_C2_1.mat';
    };

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 8.7]);
pnl = panel(fig);
pnl.pack(4,4)  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 6;

for c_ind = 1:length(analysis_cell)
    % for display use freqs:
    freqs = [25,100,200,400];
    
    % for display use displacements:
    displacements = [.2];
    
    trial = load(analysis_cell(c_ind).exampletrials{1});
    
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;    
    
    blocktrials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData,'exclude',{'displacement','freq'});
    for bt = blocktrials;
        obj.trial = load(fullfile(obj.dir,sprintf(obj.trialStem,bt)));
        freq = round(obj.trial.params.freq);
        dspl = round(obj.trial.params.displacement*10)/10;
        if (sum(freq == freqs) && sum(dspl == displacements))
            f_ind = find(freq == freqs);
            t_fig = PiezoSineAverage([],obj,'');
            
            pnl(f_ind,c_ind).pack('v',{5/6 1/6})
            pnl(f_ind,c_ind).marginbottom = 2;

            to_ax = pnl(f_ind,c_ind,1).select();
            c = copyobj(findobj(findobj(t_fig,'tag','response_ax'),'type','line'),to_ax);
            ave_line = findobj(c,'color',[.7 0 0]);
            rnd_line = c(c~=ave_line);
            delete(ave_line);
            delete(rnd_line(2:end));
            
            rnd_line = rnd_line(1);
            set(rnd_line,'ydata',get(rnd_line,'ydata')-JunctionPotential);
            
            axis(to_ax,'tight')
            set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out')
            if c_ind~=1
                set(to_ax,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
            else
                set(to_ax,'YTick',[-60 -40],'YTickLabel',{'-60' '-40'});
            end
            set(to_ax,'xlim',[-.1  .4],'ylim',[-48.5390  -20.9780]-JunctionPotential)
            
            to_ax = pnl(f_ind,c_ind,2).select();
            axes(to_ax)
            copyobj(findobj(findobj(t_fig,'tag','stimulus_ax'),'type','line'),to_ax);
            axis(to_ax,'tight')
            set(to_ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
            set(to_ax,'xlim',[-.1  .4])
            
            freqs(f_ind) = nan;
        end
    end
end
figure(fig)
pnl.xlabel('Time (s)');
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab\FrequencySelectivitySingleTracesJC.pdf'

%% Intensity Response

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 3.25]);
pnl = panel(fig);
pnl.pack('h',4)  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 6;

for c_ind = 1:length(analysis_cell)    
    trial = load(analysis_cell(c_ind).exampletrials{1});
    
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;    
    
    t_fig = figure;
    if c_ind<4
        PiezoSineOsciRespVsFreq(t_fig,obj,'');
    else
        PiezoSineDepolRespVsFreq(t_fig,obj,'');
    end
    to_ax = pnl(c_ind).select();
    copyobj(findobj(findobj(t_fig,'tag','magnitude_ax'),'type','line'),to_ax);
    
    axis(to_ax,'tight')
    set(to_ax,'TickDir','out')
    set(to_ax,'xlim',[20 400])
    set(to_ax,'XTick',[100 200 300],'XTickLabel',{'100' '200' '300'});
end
figure(fig)
pnl.xlabel('Frequency (Hz)');
pnl.ylabel('Magnitude (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab\FrequencySelectivity.pdf'

%% Population
close all
clear fn
savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_LowFrequencyB1s';
fn{1} = fullfile(savedir,'LP_PiezoSineOsciRespVsFreq.fig');
ax_ind(1) = 6;

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_MidFrequencyB1s';
fn{2} = fullfile(savedir,'BP_PiezoSineOsciRespVsFreq.fig');
ax_ind(2) = 4;

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_MidFrequencySpikingB1s';
fn{3} = fullfile(savedir,'BPS_PiezoSineOsciRespVsFreq.fig');
ax_ind(3) = 4;

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_HighFrequencyB1s';
fn{4} = fullfile(savedir,'HP_PiezoSineDepolRespVsFreq.fig');
ax_ind(4) = 4;

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 3.25]);
pnl = panel(fig);
pnl.pack('h',4)  % response panel, stimulus panel
pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 6;

for c_ind = 1:length(fn)    

    from_fig = open(fn{c_ind});
    axs = get(gcf,'children');
    from_ax = axs(ax_ind(c_ind));
    to_ax = pnl(c_ind).select();
    copyobj(findobj(from_ax,'type','line','color',[.85 .85 .85]),to_ax);
    set(findobj(to_ax,'type','line','color',[.85 .85 .85]),'marker','none','color',[0 0 0])
    axis(to_ax,'tight')
    set(to_ax,'TickDir','out')
    set(to_ax,'xlim',[20 400])
    set(to_ax,'XTick',[100 200 300],'XTickLabel',{'100' '200' '300'});
end

figure(fig)
pnl.xlabel('Frequency (Hz)');
pnl.ylabel('Magnitude (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab\PopulationSelectivity.pdf'

%% Step responses - Single traces, Junction Potential corrected

close all
figure(1)

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 3]);
pnl = panel(fig);
pnl.pack(2,4)  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 6;

for c_ind = 1:length(analysis_cell)    
    % for display use displacements:
    displacements = [-1 1];
    
    trial = load(analysis_cell(c_ind).exampletrials{2});
    
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;    
    
    blocktrials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData,'exclude',{'displacement'});
    for bt = blocktrials;
        obj.trial = load(fullfile(obj.dir,sprintf(obj.trialStem,bt)));
        dspl = round(obj.trial.params.displacement*10)/10;
        if sum(dspl == displacements)
            d_ind = find(dspl == displacements);
            t_fig = PiezoStepAverage([],obj,'');
            
            pnl(d_ind,c_ind).pack('v',{5/6 1/6})
            pnl(d_ind,c_ind).marginbottom = 2;

            to_ax = pnl(d_ind,c_ind,1).select();
            
            % Single trace part. 
            copied = copyobj(findobj(findobj(t_fig,'tag','response_ax'),'type','line'),to_ax);

            ave_line = findobj(copied,'color',[.7 0 0]);
            rnd_line = copied(copied~=ave_line);
            rnd_line = circshift(rnd_line,2);
            delete(ave_line);
            delete(rnd_line(2:end));
            
            rnd_line = rnd_line(1);
            
            % Junction correction part
            set(rnd_line,'ydata',get(rnd_line,'ydata')-JunctionPotential);
            
            axis(to_ax,'tight')
            set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out')
            if c_ind~=1
                set(to_ax,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
            else
                set(to_ax,'YTick',[-60 -40],'YTickLabel',{'-60' '-40'});
            end
            set(to_ax,'xlim',[-.1  .4],'ylim',[-48.5390  -20.9780]-JunctionPotential)
            
            % 
            
            to_ax = pnl(d_ind,c_ind,2).select();
            axes(to_ax)
            copyobj(findobj(findobj(t_fig,'tag','stimulus_ax'),'type','line'),to_ax);
            axis(to_ax,'tight')
            set(to_ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
            set(to_ax,'xlim',[-.1  .4])
            
            displacements(d_ind) = nan;
        end
    end
end
figure(fig)
pnl.xlabel('Time (s)');
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab\StepTraces.pdf'
    
%% Opponency
clear analysis_cell
cnt = 2;
analysis_cell(1).name = {
    '131126_F2_C2';
    };
analysis_cell(1).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_9.mat';
};
analysis_cell(1).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(1).exampletrials{1})));
analysis_cell(1).comment = {
    '~180 out of phase with next';
    };

cnt = 2;
analysis_cell(cnt).name = {
    '131016_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoSine_Raw_131016_F1_C1_18.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));

savedir = 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab';

close all
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        analysis_cell(c_ind).exampletrials{t_ind}
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineAverage',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;
            f(c_ind) = PiezoSineAverage([],obj,'');
        end
    end
end
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[3 3  6.5 3]);
pnl = panel(fig);
pnl.pack('v',{2/5  2/5  1/5})  % response panel, stimulus panel
pnl.margin = [16 16 2 2];
pnl(1).marginbottom = 2;
pnl(2).marginbottom = 2;

from_ax = findobj(f(1),'tag','response_ax');
to_ax = pnl(1).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.05 0.1])%,'ylim',[-40 -25])

from_ax = findobj(f(2),'tag','response_ax');
to_ax = pnl(2).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.05 0.1])%,'ylim',[-40 -25])

from_ax = findobj(f(2),'tag','stimulus_ax');
to_ax = pnl(3).select();
copyobj(findobj(from_ax,'color',[0 0 1]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.05 0.1]);%,'ylim',[-40 -25])
xlabel(to_ax,'Time (s)');
textbp(sprintf('%d Hz %.2f deg',trial.params.freq,trial.params.displacement*3/140/2/pi*360))

pnl.fontname = 'Arial';
pnl.fontsize = 18;

export_fig 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab\Opponency_Step_Sine.pdf'

% fn = fullfile(savedir,['Opponency_Step_Sine.pdf']);
% pnl.export(fn, '-rp','-l');

%% Opponency Steps
clear analysis_cell
cnt = 2;
analysis_cell(1).name = {
    '131126_F2_C2';
    };
analysis_cell(1).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
};
analysis_cell(1).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(1).exampletrials{1})));
analysis_cell(1).comment = {
    '~180 out of phase with next';
    };

cnt = 2;
analysis_cell(cnt).name = {
    '131016_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoStep_Raw_131016_F1_C1_1.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));

savedir = 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab';

close all
for c_ind = 1:length(analysis_cell)
    f(c_ind) = figure;
    trial = load(analysis_cell(c_ind).exampletrials{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    PiezoStepAverage(f(c_ind),obj,'');
end
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[3 3  3 3]);
pnl = panel(fig);
pnl.pack('v',{2/5  2/5  1/5})  % response panel, stimulus panel
pnl.margin = [16 16 2 2];
pnl(1).marginbottom = 2;
pnl(2).marginbottom = 2;
pnl(1).pack('h',{1/2  1/2})  % response panel, stimulus panel
pnl(2).pack('h',{1/2  1/2})  % response panel, stimulus panel
pnl(3).pack('h',{1/2  1/2})  % response panel, stimulus panel
pnl(1).margin = 2;
pnl(2).margin = 2;
pnl(3).margin = 2;

from_ax = findobj(f(1),'tag','response_ax');
to_ax = pnl(1,1).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.03 0.04]);%,'ylim',[-40 -25])

to_ax = pnl(1,2).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out','yticklabel',{})
set(to_ax,'xlim',[.17 0.24]);%,'ylim',[-40 -25])


from_ax = findobj(f(2),'tag','response_ax');
to_ax = pnl(2,1).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.03 0.04]);%,'ylim',[-40 -25])

to_ax = pnl(2,2).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out','yticklabel',{})
set(to_ax,'xlim',[.17 0.24]);%,'ylim',[-40 -25])

from_ax = findobj(f(2),'tag','stimulus_ax');
to_ax = pnl(3,1).select();
copyobj(findobj(from_ax,'color',[0 0 1]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.03 0.04],'ylim',[3.9 6.1])
xlabel(to_ax,'Time (s)');
textbp(sprintf('%.2f deg',trial.params.displacement*3/140/2/pi*360))

to_ax = pnl(3,2).select();
copyobj(findobj(from_ax,'color',[0 0 1]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out','yticklabel',{})
set(to_ax,'xlim',[.17 0.24],'ylim',[3.9 6.1])

pnl.fontname = 'Arial';
pnl.fontsize = 18;

close(f);
fn = fullfile(savedir,['Opponency_Step_Medial.pdf']);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab\Opponency_Step_Medial.pdf.pdf'
%pnl.export(fn, '-rp','-l');

%% Opponency Steps
clear analysis_cell
cnt = 2;
analysis_cell(1).name = {
    '131126_F2_C2';
    };
analysis_cell(1).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_6.mat';
};
analysis_cell(1).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(1).exampletrials{1})));
analysis_cell(1).comment = {
    '~180 out of phase with next';
    };

cnt = 2;
analysis_cell(cnt).name = {
    '131016_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoStep_Raw_131016_F1_C1_6.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));

savedir = 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab';

close all
for c_ind = 1:length(analysis_cell)
    f(c_ind) = figure;
    trial = load(analysis_cell(c_ind).exampletrials{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    PiezoStepAverage(f(c_ind),obj,'');
end
fig = figure;
pnl = panel(fig);
pnl.pack('v',{2/5  2/5  1/5})  % response panel, stimulus panel
pnl.margin = [16 12 2 2];
pnl(1).marginbottom = 2;
pnl(2).marginbottom = 2;
pnl(1).pack('h',{1/2  1/2})  % response panel, stimulus panel
pnl(2).pack('h',{1/2  1/2})  % response panel, stimulus panel
pnl(3).pack('h',{1/2  1/2})  % response panel, stimulus panel
pnl(1).margin = 2;
pnl(2).margin = 2;
pnl(3).margin = 2;

from_ax = findobj(f(1),'tag','response_ax');
to_ax = pnl(1,1).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.05 0.1]);%,'ylim',[-40 -25])

to_ax = pnl(1,2).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out','yticklabel',{})
set(to_ax,'xlim',[.15 0.3]);%,'ylim',[-40 -25])


from_ax = findobj(f(2),'tag','response_ax');
to_ax = pnl(2,1).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.05 0.1]);%,'ylim',[-40 -25])

to_ax = pnl(2,2).select();
copyobj(findobj(from_ax,'color',[.7 0 0]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out','yticklabel',{})
set(to_ax,'xlim',[.15 0.3]);%,'ylim',[-40 -25])

from_ax = findobj(f(2),'tag','stimulus_ax');
to_ax = pnl(3,1).select();
copyobj(findobj(from_ax,'color',[0 0 1]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out')
set(to_ax,'xlim',[-.05 0.1],'ylim',[3.9 6.1])
xlabel(to_ax,'Time (s)');
textbp(sprintf('%.2f deg',trial.params.displacement*3/140/2/pi*360))

to_ax = pnl(3,2).select();
copyobj(findobj(from_ax,'color',[0 0 1]),to_ax);
axis(to_ax,'tight')
set(to_ax,'tickdir','out','yticklabel',{})
set(to_ax,'xlim',[.15 0.3],'ylim',[3.9 6.1])

pnl.fontname = 'Arial';
pnl.fontsize = 18;

close(f);
fn = fullfile(savedir,['Opponency_Step_Lateral.pdf']);
pnl.export(fn, '-rp','-l');

%% Chirp plot
close all
clear analysis_cell

cnt = 1;  % Low frequency
analysis_cell(cnt).name = {...  % 131015_F3_C1
    '140602_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentChirp_Raw_140602_F1_C1_2.mat';
};
cnt = 2;  % Low frequency
analysis_cell(cnt).name = {...  % 131015_F3_C1
    '140602_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentChirp_Raw_140602_F2_C1_2.mat';
};

fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 4]);
pnl = panel(fig);
pnl.pack('h',{2/3,1/3})  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 20;

pnl(1).pack('v',{3/7,3/7,1/7})  % response panel, stimulus panel
pnl.de.marginbottom = 2;

trial = load(analysis_cell(1).exampletrials{1});
obj.trial = trial;
[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;
t_fig = figure;
CurrentChirpAverage(t_fig,obj,'');

from_ax = findobj(t_fig,'tag','response_ax');
to_ax = pnl(1,1).select();
copyobj(get(from_ax,'children'),to_ax);
l = findobj(to_ax,'color',[.7 0 0]);
set(l,'color',[1 0 0])
delete(findobj(to_ax,'color',[1 .7 .7]));
axis(to_ax,'tight');
set(to_ax,'xlim',[-.1 1])
            set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');

to_ax = pnl(2).select();
t_fig = figure;
CurrentChirpZAP(t_fig,obj,'');
l = findobj(t_fig,'color',[0 .5 0]);
peak = max(get(l,'ydata'));
l = copyobj(l,to_ax);
set(l,'ydata',get(l,'ydata')/peak);
set(l,'color',[1 0 0])

% Non-spiking
trial = load(analysis_cell(2).exampletrials{1});
obj.trial = trial;
[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;
t_fig = figure;
CurrentChirpAverage(t_fig,obj,'');

from_ax = findobj(t_fig,'tag','response_ax');
to_ax = pnl(1,2).select();
copyobj(get(from_ax,'children'),to_ax);
l = findobj(to_ax,'color',[.7 0 0]);
set(l,'color',[0 0 1])
delete(findobj(to_ax,'color',[1 .7 .7]));
axis(to_ax,'tight');
set(to_ax,'xlim',[-.1 1])
            set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');

from_ax = findobj(t_fig,'tag','stimulus_ax');
to_ax = pnl(1,3).select();
l = findobj(from_ax,'color',[0 0 1]);
l = copyobj(l,to_ax);
set(l,'color',[.7 .7 .7])
axis(to_ax,'tight');
set(to_ax,'xlim',[-.1 1])

% Get Fig for Current ZAP
to_ax = pnl(2).select();
t_fig = figure;
CurrentChirpZAP(t_fig,obj,'');
l = findobj(t_fig,'color',[0 .5 0]);
peak = max(get(l,'ydata'));
l = copyobj(l,to_ax);
set(l,'ydata',get(l,'ydata')/peak);
set(to_ax,'xlim',[17 75],'ylim',[.6 1])
set(l,'color',[0 0 1])
%export_fig 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\ChirpZAPSpikingExample_140602_F1_C1.pdf'

figure(fig)

pnl.xlabel('Time (s)');
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

export_fig 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab\ChirpPanel.pdf'

%% ArcLight Imaging: run the arcLight record and output the main big fig

edit Record_ArcLightImaging.m

%% 3rd Order Neurons: Freq Response curves
clear analysis_cell
cnt = 1;
analysis_cell(cnt).name = {
    '140219_F3_C4'
    };
analysis_cell(cnt).comment = {
    '140 Hz, very selective, interesting PiezoChirp Response'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoSine_Raw_140219_F3_C4_27.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoCourtshipSong_Raw_140219_F3_C4_12.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoBWCourtshipSong_Raw_140219_F3_C4_3.mat';
    };

cnt = 2;
analysis_cell(cnt).name = {
    '140110_F1_C1';
    };
analysis_cell(cnt).comment = {
    'High Frequency selective, hints of inhibition. Assymetric response to forward and back CourtS'
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoSine_Raw_140110_F1_C1_17.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoCourtshipSong_Raw_140110_F1_C1_2.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoBWCourtshipSong_Raw_140110_F1_C1_4.mat';
    };


close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 3]);
pnl = panel(fig);
pnl.pack('h',{1/2 1/2})  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 16;
pnl(1).pack('h',{1/2 1/2})  % response panel, stimulus panel
pnl(2).pack('h',{1/2 1/2})  % response panel, stimulus panel
pnl(1).de.marginleft = 6;
pnl(2).de.marginleft = 6;

for c_ind = 1:length(analysis_cell)
    % for display use freqs:
    freqs = [141,400];
    
    % for display use displacements:
    displacements = [.4];
    
    trial = load(analysis_cell(c_ind).exampletrials{1});
    
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;    
    
    blocktrials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData,'exclude',{'displacement','freq'});
    for bt = blocktrials;
        obj.trial = load(fullfile(obj.dir,sprintf(obj.trialStem,bt)));
        freq = round(obj.trial.params.freq);
        dspl = round(obj.trial.params.displacement*10)/10;
        if (sum(freq == freqs) && sum(dspl == displacements))
            f_ind = find(freq == freqs);
            t_fig = PiezoSineAverage([],obj,'');
            
            pnl(c_ind,f_ind).pack('v',{5/6 1/6})
            pnl(c_ind,f_ind).marginbottom = 2;

            to_ax = pnl(c_ind,f_ind,1).select();
            copied = copyobj(findobj(findobj(t_fig,'tag','response_ax'),'type','line'),to_ax);
            
            %             ave_line = findobj(copied,'color',[.7 0 0]);
            %             rnd_line = copied(copied~=ave_line);
            %             rnd_line = circshift(rnd_line,2);
            %             delete(ave_line);
            %             delete(rnd_line(2:end));
            %
            %             rnd_line = rnd_line(1);
            
            % Junction correction part
            for copied_ind = 1:length(copied)
                set(copied(copied_ind),'ydata',get(copied(copied_ind),'ydata')-JunctionPotential);
            end
            
            axis(to_ax,'tight')
            set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out')
            if f_ind~=1
                set(to_ax,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
            else
                set(to_ax,'YTick',[-60 -40],'YTickLabel',{'-60' '-40'});
            end
            set(to_ax,'xlim',[-.15  .5],'ylim',[-55  -15]-JunctionPotential)
            
            to_ax = pnl(c_ind,f_ind,2).select();
            axes(to_ax)
            copyobj(findobj(findobj(t_fig,'tag','stimulus_ax'),'type','line'),to_ax);
            axis(to_ax,'tight')
            set(to_ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
            set(to_ax,'xlim',[-.15  .5])
            
            freqs(f_ind) = nan;
        end
    end
end
figure(fig)
pnl.xlabel('Time (s)');
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab\WedgeFrequencyResponses.pdf'

%% 3rd Order Neurons: sound responses to courtship song
clear analysis_cell
cnt = 1;
analysis_cell(cnt).name = {
    '140219_F3_C4'
    };
analysis_cell(cnt).comment = {
    '140 Hz, very selective, interesting PiezoChirp Response'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoSine_Raw_140219_F3_C4_27.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoCourtshipSong_Raw_140219_F3_C4_12.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoBWCourtshipSong_Raw_140219_F3_C4_3.mat';
    };

cnt = 2;
analysis_cell(cnt).name = {
    '140110_F1_C1';
    };
analysis_cell(cnt).comment = {
    'High Frequency selective, hints of inhibition. Assymetric response to forward and back CourtS'
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoSine_Raw_140110_F1_C1_17.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoCourtshipSong_Raw_140110_F1_C1_2.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoBWCourtshipSong_Raw_140110_F1_C1_4.mat';
    };


close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 3]);
pnl = panel(fig);
pnl.pack('h',{1/2 1/2})  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 16;
pnl(1).pack('h',{1/2 1/2})  % response panel, stimulus panel
pnl(2).pack('h',{1/2 1/2})  % response panel, stimulus panel
pnl(1).de.marginleft = 6;
pnl(2).de.marginleft = 6;

for c_ind = 1:length(analysis_cell)
    % for display use freqs:
    %freqs = [141,400];
    
    % for display use displacements:
    displacements = [.4];
    
    trial = load(analysis_cell(c_ind).exampletrials{3});
    
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;    
    
    blocktrials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData,'exclude',{'displacement','freq'});
    for bt = blocktrials;
        obj.trial = load(fullfile(obj.dir,sprintf(obj.trialStem,bt)));
        %freq = round(obj.trial.params.freq);
        dspl = round(obj.trial.params.displacement*10)/10;
        if sum(dspl == displacements)
            %f_ind = find(freq == freqs);
            t_fig = PiezoSongAverage([],obj,'');
            
            pnl(c_ind,f_ind).pack('v',{5/6 1/6})
            pnl(c_ind,f_ind).marginbottom = 2;

            to_ax = pnl(c_ind,f_ind,1).select();
            copied = copyobj(findobj(findobj(t_fig,'tag','response_ax'),'type','line'),to_ax);
            
            %             ave_line = findobj(copied,'color',[.7 0 0]);
            %             rnd_line = copied(copied~=ave_line);
            %             rnd_line = circshift(rnd_line,2);
            %             delete(ave_line);
            %             delete(rnd_line(2:end));
            %
            %             rnd_line = rnd_line(1);
            
            % Junction correction part
            for copied_ind = 1:length(copied)
                set(copied(copied_ind),'ydata',get(copied(copied_ind),'ydata')-JunctionPotential);
            end
            
            axis(to_ax,'tight')
            set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out')
            if f_ind~=1
                set(to_ax,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
            else
                set(to_ax,'YTick',[-60 -40],'YTickLabel',{'-60' '-40'});
            end
            set(to_ax,'xlim',[-.15  .5],'ylim',[-55  -15]-JunctionPotential)
            
            to_ax = pnl(c_ind,f_ind,2).select();
            axes(to_ax)
            copyobj(findobj(findobj(t_fig,'tag','stimulus_ax'),'type','line'),to_ax);
            axis(to_ax,'tight')
            set(to_ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(to_ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
            set(to_ax,'xlim',[-.15  .5])
            
            freqs(f_ind) = nan;
        end
    end
end
figure(fig)
pnl.xlabel('Time (s)');
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab\WedgeFrequencyResponses.pdf'

%% 3rd Order Neurons: Intensity Response

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 3.25]);
pnl = panel(fig);
pnl.pack('h',4)  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 6;

for c_ind = 1:length(analysis_cell)    
    trial = load(analysis_cell(c_ind).exampletrials{1});
    
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;    
    
    t_fig = figure;
    if c_ind<1
        PiezoSineOsciRespVsFreq(t_fig,obj,'');
    else
        PiezoSineDepolRespVsFreq(t_fig,obj,'');
    end
    to_ax = pnl(c_ind).select();
    copyobj(findobj(findobj(t_fig,'tag','magnitude_ax'),'type','line'),to_ax);
    
    axis(to_ax,'tight')
    set(to_ax,'TickDir','out')
    set(to_ax,'xlim',[20 400])
    set(to_ax,'XTick',[100 200 300],'XTickLabel',{'100' '200' '300'});
end
figure(fig)
pnl.xlabel('Frequency (Hz)');
pnl.ylabel('Magnitude (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab\FrequencySelectivity.pdf'

%% Resting Membrane potential
close all
clear fn
savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_LowFrequencyB1s';
fn{1} = fullfile(savedir,'LF_Vm_rest.fig');
colors(1,:) = [1 0 0];

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_MidFrequencyB1s';
fn{2} = fullfile(savedir,'BP_Vm_rest.fig');
colors(2,:) = [0 .7 0];

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_MidFrequencySpikingB1s';
fn{3} = fullfile(savedir,'BPS_Vm_rest.fig');
colors(3,:) = [0 0 1];

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_HighFrequencyB1s';
fn{4} = fullfile(savedir,'HP_Vm_rest.fig');
colors(4,:) = [0 0 0];

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 3 3.25]);
pnl = panel(fig);
pnl.pack(1)  % response panel, stimulus panel
pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 6;

for c_ind = 1:length(fn)    

    from_fig = open(fn{c_ind});
    to_ax = pnl(1).select();
    cur_dots = copyobj(findobj(from_fig,'type','line'),to_ax);
    set(cur_dots,'marker','o','markeredgecolor',colors(c_ind,:),'markerfacecolor',colors(c_ind,:))
    axis(to_ax,'tight')
    set(to_ax,'TickDir','out')
    set(to_ax,'ylim',[-60 -10],'xlim',[-5,20])
    set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
end

figure(fig)
%pnl.xlabel('Frequency (Hz)');
pnl.ylabel('Resting V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab\RestingMembranePotential.pdf'


%% Intrinsic Excitability

% BS cell
clear analysis_cell
cnt = 1;
analysis_cell(cnt).name = {
    '131126_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\Sweep_Raw_131126_F2_C1_3.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\Sweep_Raw_131126_F2_C1_6.mat';
};

cnt = 2;
analysis_cell(cnt).name = {
    '131126_F2_C2'; 
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_4.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_9.mat';
    };

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 3]);
pnl = panel(fig);
pnl.pack('h',{1/2 1/2})  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 16;
pnl(1).pack('h',{1/2 1/2})  % response panel, stimulus panel
pnl(2).pack('h',{1/2 1/2})  % response panel, stimulus panel
pnl(1).de.marginleft = 6;
pnl(2).de.marginleft = 6;

for c_ind = 1:length(analysis_cell);
    figA = figure;
    trial = load(analysis_cell(c_ind).exampletrials{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    figA = UnabridgedSweep(figA,obj,'');
    from_axA = findobj(figA,'tag','quickshow_inax');
    to_ax = pnl(c_ind,1).select();
    l = copyobj(findobj(from_axA,'type','line'),to_ax);
    set(l,'color',[0 0 0]);
    set(to_ax,'xlim',[3.2  3.55])
    set(to_ax,'tickdir','out')
    set(to_ax,'ylim',[ -85.6025   11.6207])
    set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
    
    figB = figure;
    trial = load(analysis_cell(c_ind).exampletrials{2});
    obj.trial = trial;
    
    [obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    figB = UnabridgedSweep(figB,obj,'');
    from_axB = findobj(figB,'tag','quickshow_inax');
    
    to_ax = pnl(c_ind,2).select();
    l = copyobj(findobj(from_axB,'type','line'),to_ax);
    set(l,'color',[0 0 0]);
    set(to_ax,'xlim',[3.2  3.55])
    set(to_ax,'ylim',[ -85.6025   11.6207])
    set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(to_ax,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
    
    %close(figA,figB);
end
figure(fig)
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab\IntrinsicOscillations.pdf'

%% Current injection

% BS cell
clear analysis_cell
cnt = 1;
analysis_cell(cnt).name = {
    '140602_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentStep_Raw_140602_F2_C1_1.mat';
};

cnt = 2;
analysis_cell(cnt).name = {
    '140602_F1_C1'; 
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentStep_Raw_140602_F1_C1_1.mat';
    };

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 10 3]);
pnl = panel(fig);
pnl.pack('h',{1/2 1/2})  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 16;

pnl(1).pack('v',{7/8 1/8})  % response panel, stimulus panel
pnl(2).pack('v',{7/8 1/8})  % response panel, stimulus panel
pnl(1).de.marginleft = 6;
pnl(2).de.marginleft = 6;

for c_ind = 1:length(analysis_cell);
    figA = figure;
    trial = load(analysis_cell(c_ind).exampletrials{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    figA = CurrentStepAverage(figA,obj,'');
    from_axA = findobj(figA,'tag','response_ax');
    to_ax = pnl(c_ind,1).select();
    l = copyobj(findobj(from_axA,'type','line','color',[.7 0 0]),to_ax);
    set(l,'color',[0 0 0]);
    set(to_ax,'xlim',[-0.1 .55])
    set(to_ax,'tickdir','out')
    set(to_ax,'ylim',[ -110   11.6207])
    set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
        
    to_ax = pnl(c_ind,2).select();
    from_axB = findobj(figA,'tag','stimulus_ax');
    l = copyobj(findobj(from_axB,'type','line'),to_ax);
    set(l,'color',[.7 .7 .7]);
    axis(to_ax,'tight');
    set(to_ax,'xlim',[-0.1 .55])
    set(to_ax,'tickdir','out')
    %set(to_ax,'ylim',[ -110   11.6207])
    set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(to_ax,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
    %close(figA,figB);
end
figure(fig)
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\SexCircuits2014\Matlab\CurrentSteps.pdf'

%% Current injection Insets

% BS cell
clear analysis_cell
cnt = 1;
analysis_cell(cnt).name = {
    '140602_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\CurrentStep_Raw_140602_F2_C1_1.mat';
};

cnt = 2;
analysis_cell(cnt).name = {
    '140602_F1_C1'; 
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentStep_Raw_140602_F1_C1_1.mat';
    };

close all
fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 1 4 3]);
pnl = panel(fig);
pnl.pack('h',{1/2 1/2})  % response panel, stimulus panel
%pnl.select('all');

pnl.margin = [20 16 2 2];
pnl.de.marginbottom = 6;
pnl.de.marginleft = 16;

pnl(1).pack('v',{7/8 1/8})  % response panel, stimulus panel
pnl(2).pack('v',{7/8 1/8})  % response panel, stimulus panel
pnl(1).de.marginleft = 6;
pnl(2).de.marginleft = 6;

for c_ind = 1:length(analysis_cell);
    figA = figure;
    trial = load(analysis_cell(c_ind).exampletrials{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    figA = CurrentStepAverage(figA,obj,'');
    from_axA = findobj(figA,'tag','response_ax');
    to_ax = pnl(c_ind,1).select();
    l = copyobj(findobj(from_axA,'type','line','color',[.7 0 0]),to_ax);
    set(l,'color',[0 0 0]);
    set(to_ax,'xlim',[.35 .45])
    set(to_ax,'tickdir','out')
    set(to_ax,'ylim',[ -110   11.6207])
    set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
        
    to_ax = pnl(c_ind,2).select();
    from_axB = findobj(figA,'tag','stimulus_ax');
    l = copyobj(findobj(from_axB,'type','line'),to_ax);
    set(l,'color',[.7 .7 .7]);
    axis(to_ax,'tight');
    set(to_ax,'xlim',[.35 .45])
    set(to_ax,'tickdir','out')
    %set(to_ax,'ylim',[ -110   11.6207])
    set(to_ax,'XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(to_ax,'YColor',[1 1 1],'YTick',[],'YTickLabel','');
    %close(figA,figB);
end
figure(fig)
pnl.ylabel('V_m (mV)');
pnl.fontname = 'Arial';
pnl.fontsize = 18;

%textbp(sprintf('%d Hz',freqs(f_ind)),'fontname','Arial','fontsize',12);
export_fig 'C:\Users\Anthony Azevedo\Dropbox\Gordon2014\Matlab\CurrentStepsInsets.pdf'
