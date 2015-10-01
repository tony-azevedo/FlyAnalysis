%% Record_FS - take from the different types and agreggate here
close all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS';
if ~isdir(savedir)
    mkdir(savedir)
end

%% Populations
close all
uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_LowPassB1s\LP__PiezoSineOsciRespVsFreq.fig',1)
fig_low = gcf; chi = get(gcf,'children');
%ax_low = findobj(fig_low,'position',[0.3664    0.7002    0.2870    0.2496]);
ax_low = chi(7); %(fig_low,'position',[0.3664    0.7002    0.2870    0.2496]);

uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassLowB1s\BPL__PiezoSineOsciRespVsFreq.fig',1)
fig_bpl = gcf; chi = get(gcf,'children');
ax_bpl = chi(7);

uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassHighB1s\BPH__PiezoSineOsciRespVsFreq.fig',1)
fig_bph = gcf; chi = get(gcf,'children');
ax_bph  = chi(7);

uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_HighPassB1s\HP_PiezoSineDepolRespVsFreq.fig',1)
fig_hi = gcf; chi = get(gcf,'children');
ax_hi = chi(7);

fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 3 10 3.7],'name','Summary_FrequencySelectivity');
pnl = panel(fig);
pnl.margin = [20 18 6 12];
pnl.pack('h',4);
pnl.de.margin = [4 4 4 4];

copyobj(get(ax_low,'children'),pnl(1).select()); 
copyobj(get(ax_bpl,'children'),pnl(2).select()); 
copyobj(get(ax_bph,'children'),pnl(3).select()); 
copyobj(get(ax_hi,'children'),pnl(4).select()); 

axs = [pnl(1).select(),pnl(2).select(),pnl(3).select(),pnl(4).select()];
set(axs,'xlim',[0 400],'xtick',[100 200 300],'tickdir','out');

set(findobj(fig,'color',[0 0 0]),'marker','none','color',[1 1 1]*.8);

set(findobj(fig,'color',[0 1/3*2 0]),...
    'markeredgecolor',[0 0 0],'markerfacecolor',[0 0 0],'color',[0 0 0])

set([pnl(1).select(),pnl(2).select(),pnl(3).select()],'ylim',[0 6],'ytick',[2 4 6])
set([pnl(4).select()],'ylim',[0 15],'ytick',[5 10 15])

pnl.fontname = 'Arial';
pnl.fontsize = 18;

xlabel(pnl(1).select(),'(Hz)');
ylabel(pnl(1).select(),'Magnitude (mV)');

fn = fullfile(savedir, 'Summary_FrequencySelectivity.pdf');
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

%% examples
close all

trials = {
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\PiezoSine_Raw_150513_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_56.mat';    
}

fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 3 10 3],'name','Summary_FrequencySelectivity');
pnl = panel(fig);
pnl.margin = [20 18 6 12];
pnl.pack('h',4);
pnl.de.margin = [4 4 4 4];

trial = load(analysis_cell(c_ind).PiezoSineTrial);
obj.trial = trial;

[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

cnt = cnt+1;
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

if exist('f','var') && ishandle(f), close(f),end

% hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
[transfer{cnt},freqs{cnt},dsplcmnts{cnt}] = PiezoSineDepolRespVsFreq([],obj,'');
f = findobj(0,'tag','PiezoSineDepolRespVsFreq');
if save_log
    p = panel.recover(f);
    if isfield(obj.trial.params,'trialBlock'), tb = num2str(obj.trial.params.trialBlock);
    else tb = 'NaN';
    end
    fn = fullfile(savedir,[id dateID '_' flynum '_' cellnum '_' tb '_',...
        'PiezoSineDepolRespVsFreq.pdf']);
    p.fontname = 'Arial';
    p.export(fn, '-rp','-l','-a1.4');
end

