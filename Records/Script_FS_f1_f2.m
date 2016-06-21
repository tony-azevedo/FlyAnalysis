%% Plot f2/f2 ratio for PiezoSine

f_ind = figure;
set(f_ind,'position',[517 9   968   988],'color',[1 1 1])
pnlf1vf2 = panel(f_ind);
pnlf1vf2.pack(ceil(length(analysis_cell)/3),3)
pnlf1vf2.margin = [20 20 10 10];

for c_ind = 1:length(analysis_cell)
    x = ceil(c_ind/3);
    y = mod(c_ind,3); if y ==0,y=3;end
    pnlf1vf2(x,y).pack('v',{1/3 1/3 1/3})
    pnlf1vf2(x,y).de.marginbottom = 2;
    pnlf1vf2(x,y).de.margintop = 2;
    axF1 = pnlf1vf2(x,y,1).select(); hold on
    axF2 = pnlf1vf2(x,y,2).select(); hold on
    axRa = pnlf1vf2(x,y,3).select(); hold on
    set([axF1,axF2],'xtick',[],'xcolor',[1 1 1]);
    set([axF1,axF2,axRa],'xscale','log');
    pnlf1vf2(x,y,1).title(regexprep(analysis_cell(c_ind).name,'_','\\_'));
    drawnow
    
    trial = load(analysis_cell(c_ind).PiezoSineTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
        
    % hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
    [Ratio,F1,F2,freqs,displ] = PF_PiezoSineF2_2_F1([],obj,'','plot',0);
    max_power_ratio = -Inf;
    
    for d_ind = 1:length(displ)
        plot(axF1,freqs,F1(:,d_ind),...
            'color',[0 d_ind/length(displ) 0],...
            'displayname',[num2str(displ(d_ind)) 'V']);
        plot(axF2,freqs,F2(:,d_ind),...
            'color',[0 d_ind/length(displ) 0],...
            'displayname',[num2str(displ(d_ind)) 'V']);
        plot(axRa,freqs,Ratio(:,d_ind),...
            'linestyle','none',...
            'marker','o',...
            'markersize',1.5,...
            'markerfacecolor',[0 d_ind/length(displ) 0],...
            'markeredgecolor',[0 d_ind/length(displ) 0],...
            'displayname',[num2str(displ(d_ind)) 'V']);
    end
    set([axF1,axF2,axRa],'xlim',[10 1000]);
    drawnow
    Freqs{c_ind} = freqs;
    Displ{c_ind} = displ;
    F1s{c_ind} = F1;
    F2s{c_ind} = F2;
    Ratios{c_ind} = Ratio;
end

%%
f = figure;
f.Units = 'inches';
set(f,'color',[1 1 1],'position',[1 2 getpref('FigureSizes','NeuronOneColumn'), getpref('FigureSizes','NeuronOneColumn')])
frompnl = panel(f);
frompnl.margin = [20 20 10 10];
frompnl.pack('v',2);

ax1 = frompnl(1).select(); hold(ax1,'on');
ax2 = frompnl(2).select(); hold(ax2,'on');

all_dsplcmnts = [0.015 0.05 0.15 .5];
all_freqs = round(25 * sqrt(2) .^ (-1:1:9) * 1000)/1000; 

for d_ind = 1:length(all_dsplcmnts)
    F1_ = nan(length(F1s),length(all_freqs));
    F2_ = nan(length(F1s),length(all_freqs));
    for c_ind = 1:length(F1s)
        dspl_o = Displ{c_ind};
        dspl = round(dspl_o*1000)/1000;

        d_i = find(dspl == all_dsplcmnts(d_ind));

        if isempty(d_i)
            continue
        end

        [~,af_i,af_f] = intersect(all_freqs,round(Freqs{c_ind}*1000)/1000);
        F1_(c_ind,af_i) = F1s{c_ind}(af_f,d_i)';
        F2_(c_ind,af_i) = F2s{c_ind}(af_f,d_i)';
    end
        
    plot(ax1,all_freqs,nanmean(F1_,1),...
        'displayname',[num2str(all_dsplcmnts(d_ind),2),' V' ],...
        'marker','o','markerfacecolor','none','markeredgecolor','none',...[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    plot(ax2,all_freqs,nanmean(F2_,1),...
        'displayname',[num2str(all_dsplcmnts(d_ind),2),' V' ],...
        'marker','o','markerfacecolor','none','markeredgecolor','none',...[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'color',[0 1/length(all_dsplcmnts) 0]*d_ind);

    F1_ = F1_(~isnan(F1_(:,1)),:);
    SEM = nanstd(F1_,[],1)/sqrt(sum(~isnan(F1_(:,1))));
    %     ts = tinv([0.025  0.975],sum(~isnan(dspltranf(:,1)))-1);
    ts = [-1 1];
    CI_up = ts(1)*SEM;
    CI_down = ts(2)*SEM;
    
    errorbar(ax1,all_freqs,nanmean(F1_,1),CI_down,CI_up,'linestyle','none','marker','none','color',[0 1/length(all_dsplcmnts) 0]*d_ind);

    F2_ = F2_(~isnan(F2_(:,1)),:);
    SEM = nanstd(F2_,[],1)/sqrt(sum(~isnan(F2_(:,1))));
    %     ts = tinv([0.025  0.975],sum(~isnan(dspltranf(:,1)))-1);
    ts = [-1 1];
    CI_up = ts(1)*SEM;
    CI_down = ts(2)*SEM;
    
    errorbar(ax2,all_freqs,nanmean(F2_,1),CI_down,CI_up,'linestyle','none','marker','none','color',[0 1/length(all_dsplcmnts) 0]*d_ind);

end
set(ax1,'ylim',[0 1],'xscale','log','xlim',[15 600]);
set(ax2,'ylim',[0 1],'xscale','log','xlim',[15 600]);

% if save_log
%     fn = fullfile(savedir,[id 'F1vsF2components.pdf']);
%     pnlf1vf2.fontname = 'Arial';
%     pnlf1vf2.fontsize = 7;
%     figure(f_ind)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% end
