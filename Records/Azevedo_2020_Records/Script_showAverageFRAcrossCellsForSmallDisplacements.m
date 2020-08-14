

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
rampVsPosF.Position = [680 80 731 484];
panl = panel(rampVsPosF);
panl.pack('h',{1/2 1/2});
panl.margin = [18 10 10 10];
panl.fontname = 'Arial';

T_Step_noIav = T_Step(~contains(T_Step.Genotype,'iav-LexA')&~(contains(T_Step.Genotype,'ChR')&contains(T_Step.Genotype,'81A07')),:);
cids = unique(T_Step_noIav.CellID);
clbls = unique(T_Step_noIav.Cell_label);

%
% ax = panl(1).select(); hold(ax,'on'); %#ok<FNDSB>
for displacement = -[1 3]
    c = find([-1 -3]==displacement);
    panl(c).pack('v',{1/3 1/3 1/3})
    ax = panl(c,1).select(); hold(ax,'on'); %#ok<FNDSB>
    ax.TickDir = 'out';
    ax.XLim = [-.4 .9];
    
    ax_fr1 = panl(c,2).select(); hold(ax_fr1,'on'); %#ok<FNDSB>
    ax_fr1.TickDir = 'out';
    ax_fr1.XLim = [-.4 .9];

    ax_fr = panl(c,3).select(); hold(ax_fr,'on'); %#ok<FNDSB>
    ax_fr.TickDir = 'out';
    s_cnt = 0;
    ax_fr.YLim = [0 60];
    ax_fr.XLim = [-.4 .9];

    for clbl_idx = 3 %1:length(clbls)
        labidx = strcmp(T_Step_noIav.Cell_label,'slow');
        clblcids = unique(T_Step_noIav.CellID(labidx));
        cell_fr = [];
        
        for cidx = 1:length(clblcids)
            fprintf('%s: \n',clblcids{cidx});
            cellidx = strcmp(T_Step_noIav.CellID,clblcids{cidx});
            posidx = cellidx & T_Step_noIav.Position == 0;
            %stepidx = posidx & T_Step_noIav.Speed == 150;
            dispidx = posidx & T_Step_noIav.Displacement == displacement;
            
            Row = T_Step_noIav(dispidx,:);
            trialStem = fullfile(fileparts(Row.TableFile{:}),[Row.Protocol{:} '_Raw_' Row.CellID{:} '_%d.mat']);
            trialStem = regexprep(trialStem,'\\','\\\');
            
            trnms = Row.Trialnums{1};
            trial = load(sprintf(trialStem,trnms(1)));
            if trial.params.sampratein<40000
                continue
            end
            x = makeInTime(trial.params);
            
            spikes_ = zeros(length(trnms),length(x));
            for t_idx = 1:length(trnms)
                fprintf('\ttrial %d:\t',trnms(t_idx));

                trial = load(sprintf(trialStem,trnms(t_idx)));
                if ~isfield(ex,'excluded') || ~ex.excluded
                    if isfield(trial,'spikes')
                        fprintf('spikes\n');

                        s_cnt = s_cnt+1;
                        spikes_(t_idx,trial.spikes) = 1;
                        if strcmp(clblcids{cidx},'181128_F2_C1')
                            r = raster(ax, x(trial.spikes),s_cnt+[-.4 .4]);
                            set(r,'tag',clblcids{cidx})
                        end
                    else
                        fprintf('no spikes\n');

                        spikes_(t_idx,:) = nan;
                    end
                else
                    fprintf('excluded\n');
                    spikes_(t_idx,:) = nan;
                end
                drawnow
            end
    
            DT = 10/300;
            if ~sum(~isnan(spikes_(:,1)))
                continue
            end
            fr = firingRate(x,spikes_,10/300);
            
            
            %y = nanmean(spikes_,1);
            plot(ax_fr,x,fr,'tag',clblcids{cidx},'color',lightclrs(clbl_idx,:));
            %y = y-mean(y(x<0&x>x(1)+0.06));
            if strcmp(clblcids{cidx},'181128_F2_C1')
                plot(ax_fr1,x,fr,'tag',clblcids{cidx},'color',lightclrs(clbl_idx,:));
            end

            if isempty(cell_ys)
                cell_ys = nan(length(clblcids),length(x));
            end
            cell_ys(cidx,:) = fr;
        end
        y_lbl = nanmean(cell_ys,1);
        fr_err = nanstd(cell_ys,[],1)/sqrt(sum(~isnan(cell_ys(:,1))));
        plot(ax_fr,x,y_lbl,'tag',clbls{clbl_idx},'color',clrs(clbl_idx,:),'linewidth',2);
        plot(ax_fr,x,y_lbl+fr_err,'tag',clbls{clbl_idx},'color',clrs(clbl_idx,:),'linewidth',2);
        plot(ax_fr,x,y_lbl-fr_err,'tag',clbls{clbl_idx},'color',clrs(clbl_idx,:),'linewidth',2);
        
        ax_fr.YLim = [0 60];
    end
end


%%
% ax_normext = panl(3).select(); hold(ax,'on'); %#ok<FNDSB>
% copyobj(findobj(panl(1).select(),'type','line','linewidth',2),ax_normext)
% 
% ax_normflex = panl(4).select(); hold(ax,'on'); %#ok<FNDSB>
% copyobj(findobj(panl(2).select(),'type','line','linewidth',2),ax_normflex)
% 
% extresps = findobj(ax_normext,'type','line','linewidth',2);
% normamp = [];
% for l_idx = 1:length(extresps)
%     l = extresps(l_idx);
%     l.YData = l.YData-mean(l.YData(l.XData<0));
%     %l.YData = l.YData/max(l.YData);
% end
% 
% flxresps = findobj(ax_normflex,'type','line','linewidth',2);
% normamp = [];
% for l_idx = 1:length(flxresps)
%     l = flxresps(l_idx);
%     l.YData = l.YData-mean(l.YData(l.XData<0));
%     %l.YData = l.YData/max(l.YData);
% end
% 
% 
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