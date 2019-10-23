%% Script_Dataset5_F_Vs_V_AllFlashStrengths
trial_ = trial;
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D)
datastruct = load(datastructfile); datastruct = datastruct.data;
blocktrials = findBlockTrials(trial,datastruct);

f =figure;
panl = panel(f);
vertdivisions = [1]; vertdivisions = num2cell(vertdivisions/sum(vertdivisions));
panl.pack('v',vertdivisions)  % response panel, stimulus panel
panl.margin = [16 16 2 2];
panl.fontname = 'Arial';

x = makeInTime(trial.params);
h = postHocExposure(trial,length(trial.forceProbeStuff.CoM));
ft = x(h.exposure);
dft = diff(ft(1:2));
Nsmooth = sum(x>=ft(1)&x<ft(3));

ndfs = nums;
for tr_idx = 1:length(nums)
    data = load(datastructfile); data = data.data;
    ndfs(tr_idx) = data(inds(tr_idx)).ndf;
end

[ndfs,order] = sort(ndfs);
nums_o = nums(order);
clrs = parula(length(nums_o)+1);
clrs = clrs(1:length(nums_o),:);

for tr_idx = 1:length(nums_o)
    trial = load(sprintf(trialStem,nums_o(tr_idx)));
    [nums_ndf,inds] = findLikeTrials('name',trial.name,'exclude',{'trialBlock'});
    %nums_ndf = intersect(nums_ndf,trialnumlist);
    
    y = zeros(length(x),length(nums_ndf));
    prb = zeros(length(ft),length(nums_ndf));
    y_ft = prb;

    for ndf_idx = 1:length(nums_ndf)
        trial = load(sprintf(trialStem,nums_ndf(ndf_idx)));
        
        y(:,ndf_idx) = trial.voltage_1;
        prb(:,ndf_idx) = trial.forceProbeStuff.CoM;
    end
    
    prb = prb - trial.forceProbeStuff.ZeroForce;
    
    correctwind = ft>-.01&ft<.03;
    
    % quick correction script for prb
    for ndf_idx = 1:length(nums_ndf)
        sigma = std(prb(ft<0&ft>-.03,ndf_idx));
        mu = mean(prb(ft<0&ft>-.03,ndf_idx));
        insrt = normrnd(mu,sigma,sum(correctwind),1);
        prb(correctwind,ndf_idx) = insrt;
        base = mean(y(1:5,ndf_idx));
        y(:,ndf_idx) = smooth(y(:,ndf_idx)-base,Nsmooth)+base;
        
        %smooth voltage into ft
        for ft_idx = 1:length(ft)
            idx = x>ft(ft_idx)-dft/2 & x<ft(ft_idx)+dft/2;
            y_ft(ft_idx,ndf_idx) = mean(y(idx,ndf_idx));
        end
    end

    t_i = -.1;
    t_f = .4;

    ax = panl(1).select();
    plot(ax,mean(prb(ft>t_i&ft<t_f,:),2),mean(y_ft(ft>t_i&ft<t_f,:),2),'color',clrs(tr_idx,:),'marker','.','markeredgecolor',clrs(tr_idx,:),'Linewidth',1,'displayname',[num2str(trial.params.ndf) ' V']); 
    hold(ax,'on');
    drawnow

end
ylabel(ax,'V_m (mV)')
xlabel(ax,'Force (um)')
legend('toggle')