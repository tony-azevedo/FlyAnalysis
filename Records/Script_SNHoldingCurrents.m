% Script_SNHoldingCurrents
trial = load(analysis_cell(1).SweepTrial);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile,notesfile] = extractRawIdentifiers(trial.name);
data = load(datastructfile);
data = data.data;
trials = findLikeTrials('name',trial.name,'datastruct',data,'exclude',{'trialBlock','tags','holdingCurrent'},'withtags',tag_to_match);

current_Inj = zeros(size(trials));
x = makeInTime(trial.params);
for t_ind = 1:length(trials)
    trial = load(fullfile([D,sprintf(trialStem,trials(t_ind))]));
    current_Inj(t_ind) = mean(trial.current(x>.6));
end

inj = round(current_Inj);
[~,ai] = unique(inj);
trials0 = trials(sort(ai));
inj0 = inj(sort(ai));
% trials0 = trials0(inj0<=0);
% inj0 = inj0(inj0<=0);

if ~exist('indx','var')
    indx = 1:length(trials0); % This can be set ahead of time
end
trial_ex = trials0(indx);
inj_ex = inj0(indx);
clear indx


f = figure;
f1 = figure; hold on; ax = findobj(f1,'type','axes'); hold(ax,'on');
set(f,'position',[7 576 1905 420],'color',[1 1 1]);
pnl = panel(f);
pnl.pack('v',{2/3 1/3});
pnl(1).pack('h',length(trial_ex));
pnl(2).pack('h',length(trial_ex));
pnl.de.marginleft = 4;
pnl.de.marginright = 4;
pnl.margintop = 10;
pnl(1).marginbottom = 4;
for t_ind = 1:length(trial_ex)
    colr = [.8 .8 .8] * (inj_ex(t_ind)-min(inj_ex))/(max(inj_ex)+.1-(min(inj_ex)));
    trial = load(fullfile([D,sprintf(trialStem,trial_ex(t_ind))]));
    plot(pnl(1,t_ind).select(),x(x>2 & x<2.3),trial.voltage(x>2 & x<2.3),...
        'color',colr);
    set(pnl(1,t_ind).select(),'ylim',mVylims,'xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1 1])
    %text(2.05,0,[num2str(inj_ex(t_ind)]
    pnl(1,t_ind).title([num2str(inj_ex(t_ind)) ' pA']);
    
    [xcor, lags] = xcorr(trial.voltage(x>0.1)-mean(trial.voltage(x>0.1)),'unbiased');
    lags = lags/trial.params.sampratein;
    plot(pnl(2,t_ind).select(),lags(lags>-.05&lags<0.05),xcor(lags>-.05&lags<0.05),...
        'color',colr);
    set(pnl(2,t_ind).select(),'ylim',mV2ylims,'xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1 1])

    plot(ax,lags(lags>-.05&lags<0.05),xcor(lags>-.05&lags<0.05)/max(xcor(lags>-.05&lags<0.05)),...
        'color',colr);
end
set(pnl(1,1).select(),'ytickmode','auto','ycolor',[0 0 0],'xtickmode','auto','xcolor',[0 0 0])

pnl(1,1).ylabel('mV')
pnl(1,1).xlabel('s')
text(2,mVylims(1),Condition,'parent',pnl(1,1).select(),'verticalalignment','bottom');

set(pnl(2,1).select(),'ytickmode','auto','ycolor',[0 0 0],'xtickmode','auto','xcolor',[0 0 0])

pnl(2,1).ylabel('mV^2')
pnl(2,1).xlabel('s')

ylabel(ax,'norm.')
xlabel(ax,'s')

fn = fullfile(savedir,[id dateID '_' flynum '_' cellnum '_' regexprep(Condition,{'\s',','},{'_',''}) '_Vm.pdf']);
pnl.fontname = 'Arial';
figure(f)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

fn = fullfile(savedir,[id dateID '_' flynum '_' cellnum '_' regexprep(Condition,{'\s',','},{'_',''}) '_VmCorr.pdf']);
figure(f1)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);