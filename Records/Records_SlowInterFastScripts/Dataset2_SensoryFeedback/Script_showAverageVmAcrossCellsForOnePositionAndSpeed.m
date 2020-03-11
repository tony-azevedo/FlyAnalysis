
clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

hexclrs = [
    '3C489E'
    'D64C90'
    '00AB72'
    ];
clrs = hex2rgb(hexclrs);
hexclrs = [
    '767C9B'
    'D3A1BB'
    '8AAA9F'
    ];
lightclrs = hex2rgb(hexclrs);

rampVsPosF = figure;
rampVsPosF.Position = [680 80 1177 350];
panl = panel(rampVsPosF);
panl.pack('h',{1/4 1/4 1/4 1/4});
panl.margin = [18 10 10 10];
panl.fontname = 'Arial';

positions = 0; %[-150 -75 0 75 150];
% bringinstepspeedfactor = 5;
% dps = [-1700/bringinstepspeedfactor
%   -245.5616
%   -122.7808
%   -40.9269
%   40.9269
%   122.7808
%   245.5616
%   1700/bringinstepspeedfactor];
% gapratio = 11;
% xtick = repmat(dps,1,5)+repmat(positions,length(dps),1)*gapratio;
% dps(1) = dps(1)*bringinstepspeedfactor;
% dps(end) = dps(end)*bringinstepspeedfactor;
% xticklabels = num2str(repmat(round(dps),6,1));
% xticklabels = num2str(repmat(round(dps),6,1));

for a = 1%:4
    ax = panl(a).select(); hold(ax,'on');
    %plot(ax,[-180*gapratio 180*gapratio],[0 0],'color',[1 1 1]*.8)
    %ax.XTick = xtick(:);
    %ax.XTickLabel = {};
    %ax.XTickLabelRotation = 45;
    ax.TickDir = 'out';
end
% ax.XTickLabel = xticklabels;

% panl(2).ylabel('PSP peak (mV)');
% panl(4).ylabel('\DeltaFR (Hz)');
% panl(4).xlabel('Angular velocity (degree/s)');
% panl(5).margintop = 20;

% ax = panl(4).select(); hold(ax,'on');

% L = 419.9858; %um, approximate length of lever arm
T_RampAndStep_noIav = T_RampAndStep(~contains(T_RampAndStep.Genotype,'iav-LexA')&~(contains(T_RampAndStep.Genotype,'ChR')&contains(T_RampAndStep.Genotype,'81A07')),:);
cids = unique(T_RampAndStep_noIav.CellID);
clbls = unique(T_RampAndStep_noIav.Cell_label);

%
% ax = panl(1).select(); hold(ax,'on'); %#ok<FNDSB>
for displacement = [-10 10]
    ax = panl(round(displacement/20+1/2+1)).select(); hold(ax,'on'); %#ok<FNDSB>
    
    for clbl_idx = 1:length(clbls)
        labidx = strcmp(T_RampAndStep_noIav.Cell_label,clbls{clbl_idx});
        clblcids = unique(T_RampAndStep_noIav.CellID(labidx));
        cell_ys = [];
        
        for cidx = 1:length(clblcids)
            
            
            cellidx = strcmp(T_RampAndStep_noIav.CellID,clblcids{cidx});
            posidx = cellidx & T_RampAndStep_noIav.Position == 0;
            stepidx = posidx & T_RampAndStep_noIav.Speed == 100;%150;
            dispidx = stepidx & T_RampAndStep_noIav.Displacement == displacement;
            
            Row = T_RampAndStep_noIav(dispidx,:);
            trialStem = fullfile(fileparts(Row.TableFile{:}),[Row.Protocol{:} '_Raw_' Row.CellID{:} '_%d.mat']);
            trialStem = regexprep(trialStem,'\\','\\\');
            
            trnms = Row.Trialnums{1};
            trial = load(sprintf(trialStem,trnms(1)));
            if trial.params.sampratein<40000
                continue
            end
            x = makeInTime(trial.params);
            y = x*0;
            
            y_ = nan(length(trnms),length(x));
            for t_idx = 1:length(trnms)
                ex = load(sprintf(trialStem,trnms(t_idx)),'excluded');
                if ~isfield(ex,'excluded') || ~ex.excluded
                    v = load(sprintf(trialStem,trnms(t_idx)),'voltage_1');
                    y_(t_idx,:) = v.voltage_1;
                end
            end
            y = nanmean(y_,1);
            plot(ax,x,y,'tag',clblcids{cidx},'color',lightclrs(clbl_idx,:));
            %y = y-mean(y(x<0&x>x(1)+0.06));
            if isempty(cell_ys)
                cell_ys = nan(length(clblcids),length(x));
                cell_ys_bs = nan(length(clblcids),length(x));
            end
            cell_ys_bs(cidx,:) = y-mean(y(x<0));
            cell_ys(cidx,:) = y;

        end
        y_lbl = nanmean(cell_ys,1);
        plot(ax,x,y_lbl,'tag',clbls{clbl_idx},'color',clrs(clbl_idx,:),'linewidth',2);

        y_lbl_err = nanstd(cell_ys_bs,[],1)/sqrt(sum(~isnan(cell_ys_bs(:,1))));
        plot(ax,x,y_lbl_err,'tag','err','color',clrs(clbl_idx,:),'linewidth',1);

    end
end

%%
ax_normext = panl(3).select(); hold(ax,'on'); %#ok<FNDSB>
copyobj(findobj(panl(1).select(),'type','line','linewidth',2),ax_normext)

ax_normflex = panl(4).select(); hold(ax,'on'); %#ok<FNDSB>
copyobj(findobj(panl(2).select(),'type','line','linewidth',2),ax_normflex)

extresps = findobj(ax_normext,'type','line','linewidth',2);
normamp = [];
for l_idx = 1:length(extresps)
    l = extresps(l_idx);
    l.YData = l.YData-mean(l.YData(l.XData<0));
    
    errup = copyobj(findobj(panl(1).select(),'type','line','color',l.Color,'tag','err'),ax_normext);
    errdn = copyobj(findobj(panl(1).select(),'type','line','color',l.Color,'tag','err'),ax_normext);
    errup.YData = errup.YData/max(l.YData);%+l.YData;
    errdn.YData = -errdn.YData/max(l.YData);%+l.YData;

    l.YData = l.YData/max(l.YData);
    errup.YData = errup.YData + l.YData;
    errdn.YData = errdn.YData + l.YData;
end

flxresps = findobj(ax_normflex,'type','line','linewidth',2);
normamp = [];
for l_idx = 1:length(flxresps)
    l = flxresps(l_idx);
    l.YData = l.YData-mean(l.YData(l.XData<0));
    %l.YData = l.YData/max(l.YData);

    errup = copyobj(findobj(panl(2).select(),'type','line','color',l.Color,'tag','err'),ax_normflex);
    errdn = copyobj(findobj(panl(2).select(),'type','line','color',l.Color,'tag','err'),ax_normflex);
    errup.YData = errup.YData/max(l.YData);%+l.YData;
    errdn.YData = -errdn.YData/max(l.YData);%+l.YData;

    l.YData = l.YData/max(l.YData);
    errup.YData = errup.YData + l.YData;
    errdn.YData = errdn.YData + l.YData;

end
ax_normflex.YLim = [-1.5 1.5];
ax_normext.YLim = [-1.5 1.5];

%%

ls = findobj(panl(3).select(),'type','line');
for l_idx = 1:length(ls)
    l = ls(l_idx);
    x_ = l.XData;
    y_ = l.YData;
    x = decimate(x_,200);
    y = decimate(y_,200);
    l.XData = x;
    l.YData = y;
end
    
ls = findobj(panl(4).select(),'type','line');
for l_idx = 1:length(ls)
    l = ls(l_idx);
    x_ = l.XData;
    y_ = l.YData;
    x = decimate(x_,200);
    y = decimate(y_,200);
    l.XData = x;
    l.YData = y;
end

% ax_normflex
% %% Stats from the last fig
% 
% steps = [];
% stepsg = [];
% ramps150 = [];
% ramps150g = [];
% for a = 1:3
%     ax0 = panl0(a).select();
%     chs = ax0.Children;
%     for ch = 1:length(chs)
%         c = chs(ch);
%         if length(c.XData)>2
%             [~,xidx] = min(abs(c.XData+11.16));
%             ramps150 = cat(1,ramps150,c.YData(xidx));
%             ramps150g = cat(1,ramps150g,a);
%         elseif length(c.XData)==2
%             if all(c.YData==0)
%                 continue
%             end
%             [~,xidx] = min(c.XData);
%             steps = cat(1,steps,c.YData(xidx));
%             stepsg = cat(1,stepsg,a);
%         end
%     end
% end
% ranksum(steps(stepsg==1),steps(stepsg==2))
% ranksum(ramps150(ramps150g==1),ramps150(ramps150g==2))
% 
% 
% % [P,ANOVATAB,STATS] = anovan(steps,stepsg);
% % results = multcompare(STATS);
% % 
% % [P,ANOVATAB,STATS] = kruskalwallis(steps,stepsg);
% % results = multcompare(STATS);
% % % 
% [P,ANOVATAB,STATS] = kruskalwallis(ramps150,ramps150g);
% results = multcompare(STATS);
% 
% [P,ANOVATAB,STATS] = anovan(ramps150,ramps150g);
% results = multcompare(STATS);
% % [~,~,stats] = anovan(cavals,{clustnum extflx},'model','interaction',...
% %     'varnames',{'clustnum','extflx'});
% % 
% % results = multcompare(stats,'Dimension',[2 1]);
% 
% 
%     