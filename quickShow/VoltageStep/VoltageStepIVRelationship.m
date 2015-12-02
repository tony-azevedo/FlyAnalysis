function fig = VoltageStepIVRelationship(fig,handles,~)
% see also AverageLikeSines

% [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,~] = extractRawIdentifiers(handles.trial.name);

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

delete(get(fig,'children'))
panl = panel(fig);
panl.pack('v',{2/3 1/3})  % response panel, stimulus panel
panl.margin = [24 18 10 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 6;
panl(2).margintop = 6;

[Vo,o] = sort(V);
Vo = Vo(:);

Io = I_mean(o);
Io = Io(:);

ax = panl(1).select();hold on
plot(ax, Vo, Io,...
    'DisplayName','V vs. I',...
    'linestyle',':',...
    'color',[0 0 0],...
    'marker','o',...
    'markerfacecolor',[1 1 1]*0,...
    'markeredgecolor',[1 1 1]*0,...
    'markersize',2 ...
    )

r1 = (Vo(1:3)-mean(Vo(1:3)))\(Io(1:3) - mean(Io(1:3)));
r2 = (Vo(end-3+1:end)-mean(Vo(end-3+1:end)))\(Io(end-3+1:end) - mean(Io(end-3+1:end)));

plot(ax, Vo(1:3), (Vo(1:3)-mean(Vo(1:3)))*r1 + mean(Io(1:3)),...
    'DisplayName','R1',...
    'linestyle',':',...
    'color',[1 1 1]*.75)
plot(ax, Vo(end-3+1:end), (Vo(end-3+1:end)-mean(Vo(end-3+1:end)))*r2 + mean(Io(end-3+1:end)),...
    'DisplayName','R2',...
    'linestyle',':',...
    'color',[1 1 1]*.75)


text(Vo(1)*.95,0,sprintf('R_1=%.0f',1/r1*1000));
text(Vo(end)*.95,0,sprintf('R_2=%.0f',1/r2*1000),'HorizontalAlignment','right');
    
set(panl(1).select(),'xtickLabel','')
panl(1).ylabel('V (mV)');

ax = panl(2).select();
plot(ax, V, RC*1000,...
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
