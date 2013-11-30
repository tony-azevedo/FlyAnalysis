function transfer = TransferFunctionOfLikePiezoSines(fig,handles,savetag)
% see also AverageLikeSongs

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(fig) || ~ishghandle(fig)
    fig = figure(100+trials(1)); clf
else
end

set(fig,'tag',mfilename);
if strcmp(get(fig,'type'),'figure'), set(fig,'name',mfilename);end
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
end
outname = 'sgsmonitor';
outunits = 'V';

y = zeros(length(x),length(trials));
u = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name);
    u(:,t) = trial.(outname);
end

yc = mean(y,2);
base = mean(yc(x<0));
yc = yc-base;
uc = mean(u,2);
offset = mean(uc(x<0));
uc = uc-offset;

fin = trial.params.stimDurInSec - trial.params.ramptime;
yc = yc(x>=fin-trial.params.stimDurInSec/2 & x< fin);
uc = uc(x>=fin-trial.params.stimDurInSec/2 & x< fin);
t = x(x>=fin-trial.params.stimDurInSec/2 & x< fin);

[C, Lags] = xcorr(yc,uc,'coeff');
% figure(102); plot(Lags,C);
C = C(Lags>=0);
Lags = Lags(Lags>=0);

% find the maximum correlation, negative or positive, and assure that it's
% causal
i_del = Lags(abs(C)==max(abs(C)));
t_del = t(i_del+1) - t(1);
respsign = sign(C(i_del+1));

arg = -t_del / (1/trial.params.freq) * 2*pi;

minfunc = @(x)mean(abs(yc(i_del+1:end)-x*uc(1:end-i_del)));
mag = fminsearch(minfunc ,1);
% plot(t(1:end-i_del),mag*uc(1:end-i_del),'color',[.7 0 0]), hold on

transfer = respsign * mag*(cos(arg) + 1i*sin(arg));

% figure(103); %clf
% plot(t(1:end-i_del),uc(1:end-i_del),'color',[.7 .7 .7]), hold on
% plot(t(1:end-i_del),yc(1:end-i_del),'color',[.7 .7 1]), hold on
% %plot(t(1:end-i_del),yc(i_del+1:end)), hold on
% 
% plot(t(1:end-i_del),real(u_ideal),'color',[1 .7 .7]), hold on
% plot(t(1:end-i_del),real(transfer*u_ideal),'color',[1 .7 .7]), hold on

% make the ideal stimulus, once the piezo response is accounted for
uc = uc(t>=(fin-2*(1/trial.params.freq)) & t< fin);
t = t(t>=(fin-2*(1/trial.params.freq)) & t< fin);
u_ideal = trial.params.displacement*exp(1i * (2*pi*trial.params.freq * t - pi/2));
[C, Lags] = xcorr(uc,real(u_ideal),'coeff');
i_del = Lags(C==max(C));
t_del = t(i_del+1) - t(1);
u_ideal = trial.params.displacement*exp(1i * (2*pi*trial.params.freq * (x-t_del) - pi/2));

ax = subplot(3,1,[1 2],'parent',fig);
cla(ax)
plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,x,real(transfer * u_ideal) + base,'color',[0 0 .7],'tag',savetag); hold on;
plot(ax,x, mean(y,2),'color',[.7 0 0],'tag',savetag);
axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

title([])
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);

ax = subplot(3,1,3,'parent',fig);
cla(ax)
plot(ax,x,real(transfer/abs(transfer) * u_ideal)+offset,'color',[0 0 .7],'tag',savetag); hold on;
plot(ax,x,mean(u,2),'color',[.7 .7 1],'tag',savetag); hold on;

box(ax,'off');
set(ax,'TickDir','out');

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
%ylim([4.5 5.5])
linkaxes(get(fig,'children'),'x');
drawnow
