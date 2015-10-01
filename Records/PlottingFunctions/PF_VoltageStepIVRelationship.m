function pnl = PF_VoltageStepIVRelationship(pnl,handles,savetag)

blocktrials = findBlockTrials(handles.trial,handles.prtclData);

clear f
cnt = 1;
V = nan(size(blocktrials));
I_base =  V;
I_mean =  V;
dI =  V;
RC = V;
for bt = blocktrials(:)';
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    [I_base(cnt),I_mean(cnt),dI(cnt),RC(cnt)] = IandDeltaI(handles);
    V(cnt) = handles.trial.params.step;
    cnt = cnt+1;
end

V(cnt) = 0;
I_mean(cnt) = mean(I_base);
dI(cnt) = 0;
RC(cnt) = nan;

[Vo,o] = sort(V);
Vo = Vo(:);

Io = I_mean(o);
Io = Io(:);

hold(pnl,'on')
plot(pnl, Vo, Io,...
    'DisplayName','V vs. I',...
    'linestyle',':',...
    'color',[0 0 0],...
    'marker','o',...
    'markerfacecolor',[1 1 1]*0,...
    'markeredgecolor',[1 1 1]*0,...
    'markersize',2 ...
    )

r1 = Vo(1:3)\Io(1:3);
r2 = Vo(end-3+1:end)\Io(end-3+1:end);

plot(pnl, Vo(1:3), Vo(1:3)*r1,...
    'DisplayName','R1',...
    'linestyle',':',...
    'color',[1 1 1]*.75)
plot(pnl, Vo(end-3+1:end), Vo(end-3+1:end)*r2,...
    'DisplayName','R2',...
    'linestyle',':',...
    'color',[1 1 1]*.75)

text(Vo(1)*.95,0,sprintf('R_1=%.0f',1/r1*1000),'parent',pnl);
text(Vo(end)*.95,0,sprintf('R_2=%.0f',1/r2*1000),'HorizontalAlignment','right','parent',pnl);
    
ylabel(pnl,'I (pA)');


function varargout = IandDeltaI(handles)

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
x = makeTime(handles.trial.params);

y_name = 'current';
y = zeros(length(x),length(trials));

for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name)(1:length(x));
end

I = mean(y,2);
I_base = mean(I(x<=0));
I_mean = mean(I(x>trial.params.stimDurInSec/2 & x<trial.params.stimDurInSec));
dI = I_mean - I_base;

RC = .02;
A = -(I_mean - I_base);
B = I_mean;
coef = [B A RC];
%coef = nlinfit(x(x>=0 & x<trial.params.stimDurInSec),V(x>=0 & x<trial.params.stimDurInSec),@exponential,coef);

varargout = {I_base,I_mean,dI,coef(3)};
