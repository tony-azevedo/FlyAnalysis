function fig = CurrentStepIVRelationship(fig,handles,~)
% see also AverageLikeSines

% [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,~] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'step'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

clear f
cnt = 1;
I = nan(size(blocktrials));
V_base =  I;
V_mean =  I;
dV =  I;
RC = I;
for bt = blocktrials(:)';
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    [V_base(cnt),V_mean(cnt),dV(cnt),RC(cnt)] = VandDeltaV(handles);
    I(cnt) = handles.trial.params.step;
    cnt = cnt+1;
end

I(cnt) = 0;
V_mean(cnt) = mean(V_base);
dV(cnt) = 0;
RC(cnt) = nan;

delete(get(fig,'children'))
panl = panel(fig);
panl.pack('v',{2/3 1/3})  % response panel, stimulus panel
panl.margin = [24 18 10 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 6;
panl(2).margintop = 6;

ax = panl(1).select();hold on
plot(ax, I, V_mean,...
    'DisplayName','V vs. I',...
    'linestyle','none',...
    'marker','o',...
    'markerfacecolor',[1 1 1]*0,...
    'markeredgecolor',[1 1 1]*0,...
    'markersize',2 ...
    )

[Io,o] = sort(I);
Io = Io(:);

Vo = V_mean(o);
Vo = Vo(:);

r1 = Io(1:4)\Vo(1:4);
r2 = Io(end-3:end)\Vo(end-3:end);

plot(ax, Io(1:4), Io(1:4)*r1,...
    'DisplayName','R1',...
    'linestyle',':',...
    'color',[1 1 1]*.75)
plot(ax, Io(end-3:end), Io(end-3:end)*r2,...
    'DisplayName','R2',...
    'linestyle',':',...
    'color',[1 1 1]*.75)

text(Io(1)*.95,0,sprintf('R_1=%.0f',r1*1000));
text(Io(end)*.95,0,sprintf('R_2=%.0f',r2*1000),'HorizontalAlignment','right');
    
set(panl(1).select(),'xtickLabel','')
panl(1).ylabel('V (mV)');

ax = panl(2).select();
plot(ax, I, RC*1000,...
    'DisplayName','V vs. I',...
    'linestyle','none',...
    'marker','o',...
    'markerfacecolor',[1 1 1]*0,...
    'markeredgecolor',[1 1 1]*0,...
    'markersize',2 ...
    )
axis(panl(2).select(),'tight')
panl(2).ylabel('RC (ms)');
panl(2).xlabel('I (pA)');


function varargout = VandDeltaV(handles)

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
x = makeTime(handles.trial.params);

y_name = 'voltage';
y = zeros(length(x),length(trials));

for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name)(1:length(x));
end

V = mean(y,2);
V_base = mean(V(x<=0));
V_mean = mean(V(x>trial.params.stimDurInSec/2 & x<trial.params.stimDurInSec));
dV = V_mean - V_base;

RC = .02;
A = -(V_mean - V_base);
B = V_mean;
coef = [B A RC];
%coef = nlinfit(x(x>=0 & x<trial.params.stimDurInSec),V(x>=0 & x<trial.params.stimDurInSec),@exponential,coef);

varargout = {V_base,V_mean,dV,coef(3)};
