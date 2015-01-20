obj.trial = trial;
[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

prtclData = load(dfile);
obj.prtclData = prtclData.data;

figure
if backgroundCorrectionFlag
    VoltagePlateauxAverageDFoverF(gcf,obj,'No Save','BGCorrectImages',true);
else
    VoltagePlateauxAverageDFoverF(gcf,obj,'No Save','BGCorrectImages',false);
end

eval(['export_fig ', ...
    [savedir ['AverageDFoverF_',dateID,'_',flynum,'_',cellnum]],...
    ' -pdf -transparent'])

figure

if backgroundCorrectionFlag
    [h,dV,dF] = DFoverFoverDV_off(gcf,obj,'No Save','BGCorrectImages',true);
else
    [h,dV,dF] = DFoverFoverDV_off(gcf,obj,'No Save','BGCorrectImages',false);
end

set(findobj(h,'color',[.3 1 .3]),'color',[.8 .8 .8])
set(findobj(h,'color',[0 .7 0]),'color',[.8 .8 .8],'markerfacecolor',[.8 .8 .8])

coef = [16.0664  943.8559   63.7402  256.1001];

[coeffout(c_ind,:)] = nlinfit(dV(:)',dF(:)',@CaoBoltzmann,coef);

lastwarn('');
[coeffout(c_ind,:),resid,jacob,covab,mse] = nlinfit(dV(:)',dF(:)',@CaoBoltzmann,coeffout(c_ind,:));
[lastmsg, lastid] = lastwarn();
if ~isempty(lastmsg)
    textbp('Illconditioned NLinFit')
end

parci = nlparci(coeffout(c_ind,:),resid,'jacobian',jacob);

deltaV_hyp = 2*min(dV(1,:)):.01: 2*max(dV(1,:));
[dFprediction, delta] = nlpredci(@CaoBoltzmann,deltaV_hyp,coeffout(c_ind,:),resid,'covar',covab);
set(gca,'xlim',[deltaV_hyp(1) deltaV_hyp(end)],'ylim',[min(dFprediction-delta),max(dFprediction+delta)])

hold on,
plot(deltaV_hyp,dFprediction,'color',colors(c_ind,:),'linewidth',2)
plot(deltaV_hyp,[dFprediction+delta;dFprediction-delta],'color',colors(c_ind,:),'linewidth',.5)
plot(get(gca,'xlim'),[DeltaF_breakin(c_ind) ,DeltaF_breakin(c_ind)],':','color',colors(c_ind,:));

% at some point, moving from left to right, breakin deltaF is
% larger than the boltzman.
mid = find(dFprediction <= DeltaF_breakin(c_ind),1,'first');
midVm = deltaV_hyp(mid);
if isempty(mid)
    mid = length(dFprediction);
    midVm = deltaV_hyp(end);
end

% then find where the measurement crosses the prediction line
left = find(dFprediction(1:mid)-delta(1:mid)>= DeltaF_breakin(c_ind),1,'last');
leftVm = deltaV_hyp(left)-midVm;
if isempty(left)
    leftVm = deltaV_hyp(1);
end
right = find(dFprediction(mid+1:end)+delta(mid+1:end)<= DeltaF_breakin(c_ind),1,'first');
if ~isempty(right)
    right = mid+right;
    rightVm = deltaV_hyp(right)-midVm;
else
    rightVm = deltaV_hyp(end);
end

plot([midVm+leftVm midVm+leftVm], get(gca,'ylim'),'k','color',[.8 .8 .8]);
plot([midVm+rightVm midVm+rightVm], get(gca,'ylim'),'k','color',[.8 .8 .8]);
plot(midVm,DeltaF_breakin(c_ind),'o','color',colors(c_ind,:),'markerfacecolor',colors(c_ind,:));

predci_delta(c_ind,:) = [leftVm rightVm];

DeltaV_breakin(c_ind) = midVm;

eval(['export_fig ', ...
    [savedir ['DeltaV_breakin_',dateID,'_',flynum,'_',cellnum]],...
    ' -pdf -transparent'])

