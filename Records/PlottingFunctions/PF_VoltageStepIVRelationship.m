function pnl = PF_VoltageStepIVRelationship(pnl,handles,savetag)

blocktrials = findBlockTrials(handles.trial,handles.prtclData);

clear f
cnt = 1;
V = nan(size(blocktrials));
BaseV = nan(size(blocktrials));
I_base =  V;
I_mean =  V;
I_peak =  V;
dI =  V;
RC = V;
for bt = blocktrials(:)';
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    [I_base(cnt),I_mean(cnt),I_peak(cnt),dI(cnt),RC(cnt)] = IandDeltaI(handles);
    x = makeInTime(handles.trial.params);
    BaseV(cnt) = mean(handles.trial.voltage(x>-0.06 & x<0));
    V(cnt) = handles.trial.params.step;
    
    cnt = cnt+1;
end

V(cnt) = 0;
I_mean(cnt) = mean(I_base);
I_peak(cnt) = mean(I_base);
dI(cnt) = 0;
RC(cnt) = nan;

[Vo,o] = sort(V);
Vo = Vo(:);
Vo = Vo+mean(BaseV);

Io = I_mean(o);
Io = Io(:);

Ipo = I_peak(o);
Ipo = Ipo(:);

[~,dateID,flynum,cellnum] = extractRawIdentifiers(handles.trial.name);

hold(pnl,'on')
plot(pnl, Vo, Io,...
    'DisplayName','Imean vs. V',...
    'linestyle','-',...
    'color',[0 0 0],...
    'marker','none',...
    'markerfacecolor',[1 1 1]*0,...
    'markeredgecolor',[1 1 1]*0,...
    'markersize',2, ...
    'tag',[dateID '_' flynum '_' cellnum],...
    'userdata',mean(BaseV) ...
    )

plot(pnl, Vo, Ipo,...
    'DisplayName','Ipeak vs. V',...
    'linestyle',':',...
    'color',[0 0 0],...
    'marker','o',...
    'markerfacecolor',[1 1 1]*0,...
    'markeredgecolor',[1 1 1]*0,...
    'markersize',2, ...
    'userdata',mean(BaseV) ...
    )



r1 = (Vo(1:3)-mean(Vo(1:3)))\(Io(1:3) - mean(Io(1:3)));
r2 = (Vo(end-3+1:end)-mean(Vo(end-3+1:end)))\(Io(end-3+1:end) - mean(Io(end-3+1:end)));

plot(pnl, Vo(1:3), (Vo(1:3)-mean(Vo(1:3)))*r1 + mean(Io(1:3)),...
    'DisplayName','R1',...
    'linestyle',':',...
    'color',[1 1 1]*.75)
plot(pnl, Vo(end-3+1:end), (Vo(end-3+1:end)-mean(Vo(end-3+1:end)))*r2 + mean(Io(end-3+1:end)),...
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

[~,ttpk] = max(I(x>0.005 & x < trial.params.stimDurInSec));
ttpk = ttpk + sum(x<=0.005);
I_peak = mean(I(ttpk-20:ttpk+20));

dI = I_mean - I_base;

RC = .02;
A = -(I_mean - I_base);
B = I_mean;
coef = [B A RC];
%coef = nlinfit(x(x>=0 & x<trial.params.stimDurInSec),V(x>=0 & x<trial.params.stimDurInSec),@exponential,coef);

varargout = {I_base,I_mean,I_peak,dI,coef(3)};
