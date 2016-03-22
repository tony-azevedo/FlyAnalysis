function varargout = PF_VoltageStepIVRelationship_NoPlot(h,savetag)

blocktrials = findBlockTrials(h.trial,h.prtclData);

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
    h.trial = load(fullfile(h.dir,sprintf(h.trialStem,bt)));
    [I_base(cnt),I_mean(cnt),I_peak(cnt),dI(cnt),RC(cnt)] = IandDeltaI(h);
    x = makeInTime(h.trial.params);
    BaseV(cnt) = mean(h.trial.voltage(x>-0.06 & x<0));
    V(cnt) = h.trial.params.step;
    
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

r1 = (Vo(1:3)-mean(Vo(1:3)))\(Io(1:3) - mean(Io(1:3)));
r2 = (Vo(end-3+1:end)-mean(Vo(end-3+1:end)))\(Io(end-3+1:end) - mean(Io(end-3+1:end)));
    
varargout = {Vo,Io,mean(BaseV),1/r1*1000,1/r2*1000};


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
