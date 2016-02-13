%% Record_Figure3 - PiezoSteps and phases
close all

Scripts = {
    'Record_FS_HighFreqDepolB1s'
    'Record_FS_BandPassHiB1s'
    'Record_FS_BandPassLowB1s'
    'Record_FS_LowPassB1s'
    };

figure3 = figure;
figure3.Units = 'inches';
set(figure3,'color',[1 1 1],'position',[1 0 getpref('FigureSizes','NeuronOneAndHalfColumn'),10])
pnl = panel(figure3);

figurerows = [1 4 4 4 4 4 4 4 10];
figurerows = num2cell(figurerows/sum(figurerows));

pnl.pack('v',figurerows);
pnl.margin = [16 2 4 4];


% Figure 3A: Steps for A2
Record_FS_HighFreqDepolB1s

fr = 2;
pnl(fr).pack('h',{1/4 1/4 1/2});
clear pnl_hs
for r = fr
    for c = 1:2
        pnl_hs(r-fr+1,c) = pnl(r,c).select();
    end
end

trial = load(fig3example_cell.PiezoStepTrialAnt);
h = getShowFuncInputsFromTrial(trial);
fig = PiezoStepAverage([],h,fig3example_cell.genotype);
l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr,1).select());
x = l.XData;
y = l.YData;
set(l,'XData',x(x>=-.1 & x<.3),'YData',y(x>=-.1 & x<.3));

trial = load(fig3example_cell.PiezoStepTrialPost);
h = getShowFuncInputsFromTrial(trial);
fig = PiezoStepAverage([],h,fig3example_cell.genotype);
l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr,2).select());
y = l.YData;
set(l,'XData',x(x>=-.1 & x<.3),'YData',y(x>=-.1 & x<.3));



% ****** Figure 3B: Steps and cycles for BPH ******

for sc_ind = 2:length(Scripts)
    eval(Scripts{sc_ind});
    fr = (sc_ind-1)*2+1;
    
    pnl(fr).pack('h',{1/4 1/4 1/2});
    pnl(fr+1).pack('h',{1/4 1/4 1/2});
    
    clear pnl_hs
    for r = fr:fr+1
        for c = 1:2
            pnl_hs(r-fr+1,c) = pnl(r,c).select();
        end
    end
    
    trial = load(fig3example_cell0.PiezoStepTrialAnt);
    h = getShowFuncInputsFromTrial(trial);
    fig = PiezoStepAverage([],h,fig3example_cell0.genotype);
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),pnl(fr,1).select());
    
    trial = load(fig3example_cell0.PiezoStepTrialPost);
    h = getShowFuncInputsFromTrial(trial);
    fig = PiezoStepAverage([],h,fig3example_cell0.genotype);
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),pnl(fr,2).select());
    
    
    trial = load(fig3example_cell180.PiezoStepTrialAnt);
    h = getShowFuncInputsFromTrial(trial);
    fig = PiezoStepAverage([],h,fig3example_cell180.genotype);
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),pnl(fr+1,1).select());
    
    
    trial = load(fig3example_cell180.PiezoStepTrialPost);
    h = getShowFuncInputsFromTrial(trial);
    fig = PiezoStepAverage([],h,fig3example_cell180.genotype);
    copyobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),pnl(fr+1,2).select());
    
    set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[-.1 .3]);
    set(pnl_hs(1,:),'ylim',[-45 -30]);
    set(pnl_hs(2,:),'ylim',[-40 -25]);
    delete(findobj(pnl_hs(:),'type','line','color',[1 .7 .7]));
    set(findobj(pnl_hs(2,:),'type','line','color',[.7 0 0]),'color',[0 0 1]);
    set(findobj(pnl_hs(1,:),'type','line','color',[.7 0 0]),'color',[1 0 0]);
    
    clear pnl_hs
    for r = fr:fr+1
        for c = 3
            pnl_hs(r-fr+1,c-2) = pnl(r,c).select();
        end
    end
    
    % ***** Plot sine cycles ****
    trial = load(fig3example_cell0.PiezoSine25);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr,3).select());
    l_25 = findobj(hs,'type','line','color',[.7 0 0]);
    
    trial = load(fig3example_cell0.PiezoSine50);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr,3).select());
    l_50 = findobj(hs,'type','line','color',[.7 0 0]);
    set(hs,'XData',l_25.XData(end)+.002+l_50.XData)
    
    trial = load(fig3example_cell0.PiezoSine100);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr,3).select());
    l_100 = findobj(hs,'type','line','color',[.7 0 0]);
    set(hs,'XData',l_50.XData(end)+.002+l_100.XData)
    
    % ***** Plot sine cycles ****
    trial = load(fig3example_cell180.PiezoSine25);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr+1,3).select());
    l_25 = findobj(hs,'type','line','color',[.7 0 0]);
    
    trial = load(fig3example_cell180.PiezoSine50);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr+1,3).select());
    l_50 = findobj(hs,'type','line','color',[.7 0 0]);
    set(hs,'XData',l_25.XData(end)+.002+l_50.XData)
    
    trial = load(fig3example_cell180.PiezoSine100);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr+1,3).select());
    l_100 = findobj(hs,'type','line','color',[.7 0 0]);
    set(hs,'XData',l_50.XData(end)+.002+l_100.XData)
    
    set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[]);
    set(pnl_hs(1,:),'ylim',[-45 -30]);
    set(pnl_hs(2,:),'ylim',[-40 -25]);
    %delete(findobj(pnl_hs(:),'type','line','color',[1 .7 .7]));
    set(findobj(pnl_hs(2,:),'type','line','color',[1 .7 .7]),'color',[.7 .7  1]);
    set(findobj(pnl_hs(2,:),'type','line','color',[.7 0 0]),'color',[0 0 .7]);

end

% Draw the stimuli

fr = 1;
pnl(fr).pack('h',{1/4 1/4 1/2});

clear pnl_hs
for r = fr
    for c = 1:2
        pnl_hs(r-fr+1,c) = pnl(r,c).select();
    end
end

trial = load(fig3example_cell0.PiezoStepTrialAnt);
line(makeInTime(trial.params),PiezoStepStim(trial.params),'parent',pnl(fr,1).select());

trial = load(fig3example_cell0.PiezoStepTrialPost);
line(makeInTime(trial.params),PiezoStepStim(trial.params),'parent',pnl(fr,2).select());

clear pnl_hs
for r = fr
    for c = 3
        pnl_hs(r-fr+1,c-2) = pnl(r,c).select();
    end
end

% ***** Plot sine cycles ****
trial = load(fig3example_cell180.PiezoSine25);
x = makeInTime(trial.params);
x_win = x>= trial.params.ramptime & x<trial.params.stimDurInSec-trial.params.ramptime;
s = PiezoSineStim(trial.params)/trial.params.displacement;
[~,ascd] = findSineCycle(s(x_win),0,[]);
r = min(diff(ascd));
x_ = x(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
x_ = x_-x_(1);
s_ = s(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
l_25 = line(x_,s_,'parent',pnl(fr,3).select());

trial = load(fig3example_cell180.PiezoSine50);
x = makeInTime(trial.params);
x_win = x>= trial.params.ramptime & x<trial.params.stimDurInSec-trial.params.ramptime;
s = PiezoSineStim(trial.params)/trial.params.displacement;
[~,ascd] = findSineCycle(s(x_win),0,[]);
r = min(diff(ascd));
x_ = x(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
x_ = x_-x_(1);
s_ = s(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
l_50 = line(x_,s_,'parent',pnl(fr,3).select());
set(l_50,'XData',l_25.XData(end)+.002+l_50.XData)

trial = load(fig3example_cell180.PiezoSine100);
x = makeInTime(trial.params);
x_win = x>= trial.params.ramptime & x<trial.params.stimDurInSec-trial.params.ramptime;
s = PiezoSineStim(trial.params)/trial.params.displacement;
[~,ascd] = findSineCycle(s(x_win),0,[]);
r = min(diff(ascd));
x_ = x(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
x_ = x_-x_(1);
s_ = s(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
l_100 = line(x_,s_,'parent',pnl(fr,3).select());
set(l_100,'XData',l_50.XData(end)+.002+l_100.XData)

set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[]);

% Clean up
pnl.de.marginbottom = 2;

for r = 1
    for c = 1:2
        ax = pnl(r,c).select();
        set(ax,'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[-.1 .3],'ylim',[-1 1]);
    end
    ax = pnl(r,3).select();
    set(ax,'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[0 .07388],'ylim',[-1 1]);
end


for r = 2
    ylims = [Inf,-Inf];
    for c = 1:2
        ax = pnl(r,c).select();
        axis(ax,'tight')
        yl = ax.YLim;
        ylims = ...
            [min([ylims(1),yl(1)]) ...
            max([ylims(2),yl(2)])];
    end
    %ylims = mean(ylims)+[-12.5 12.5];
    for c = 1:2
        ax = pnl(r,c).select();
        ax.YLim = ylims;
        set(ax,'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[-.1 .3]);
    end
end

for r = 3:8
    ylims = [Inf,-Inf];
    for c = 1:3
        ax = pnl(r,c).select();
        axis(ax,'tight')
        yl = ax.YLim;
        ylims = ...
            [min([ylims(1),yl(1)]) ...
            max([ylims(2),yl(2)])];
    end
    %ylims = mean(ylims)+[-12.5 12.5];
    for c = 1:3
        ax = pnl(r,c).select();
        ax.YLim = ylims;
        set(ax,'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[-.1 .3]);
    end
    set(ax,'xlim',[0 .07388]);
    
end
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure3/';
savePDF(fig,savedir,[],'Figure3ad')

%% polar plots of sine coefficients

figure3 = figure;
figure3.Units = 'inches';
set(figure3,'color',[1 1 1],'position',[1 0 getpref('FigureSizes','NeuronOneAndHalfColumn'),10])
pnl = panel(figure3);

figurerows = [1 4 4 4 4 4 4 4 20];
figurerows = num2cell(figurerows/sum(figurerows));

pnl.pack('v',figurerows);
pnl.margin = [16 2 4 4];

fr = 9;
pnl(fr).pack('h',{1/3 1/3 1/3});
pnl(fr).margintop = 2;
pnl(fr).marginbottom = 2;

for sc_ind = 2:length(Scripts)
    ax = pnl(fr,sc_ind-1).select();

    eval(Scripts{sc_ind});
    
    transfer = nan(1,length(analysis_cell));
    clrs = parula(length(analysis_cell));
    
    for c_ind = 1:length(analysis_cell)
        if ~isempty(analysis_cell(c_ind).PiezoSineTrial)
            fprintf('%s\n',analysis_cell(c_ind).name)
            trial = load(analysis_cell(c_ind).PiezoSineTrial);
            h = getShowFuncInputsFromTrial(trial);
            
            if round(h.trial.params.displacement*1000)/1000 ~=.15
                if ~isempty(regexp(h.trial.name,'131126_F2_C2'))
                    warning('Banner cell has amplitude %.2f',h.trial.params.displacement)
                elseif ~isempty(regexp(h.trial.name,'151201_F1_C2'))
                    warning('Weird cell with split block')
                    continue
                else
                   warning('This PiezoSine is the wrong amplitude')
                   continue
                end
            end
            
            % Calculate the transfer function
            transfer(c_ind) = PiezoSineOsciTransFunc([],h,'','plot',0) * h.trial.params.displacement;
        end
    end
    transfer = transfer(~isnan(transfer));
    
    idxs = 1:length(transfer);

    [~,max_idx] = max(abs(transfer));
    dot = polar(ax,angle(transfer(max_idx)),abs(transfer(max_idx))); hold on
%     dot = polar(ax,angle(transfer(max_idx)),1); hold on
    set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',clrs(max_idx,:),...
        'displayname',analysis_cell(max_idx).name)
    set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0],...
        'displayname',analysis_cell(max_idx).name)
    idxs = idxs(idxs~=max_idx);
    
    for c_ind = idxs
        dot = polar(ax,angle(transfer(c_ind)),abs(transfer(c_ind))); hold on
%         dot = polar(ax,angle(transfer(c_ind)),1); hold on
        set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',clrs(c_ind,:),...
            'displayname',analysis_cell(c_ind).name)
        set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0],...
            'displayname',analysis_cell(c_ind).name)
    end
    
    set(findobj(ax,'type','line','-regexp','displayname',fig3example_cell0.name),'MarkerFaceColor',[1 0 0])
    set(findobj(ax,'type','line','-regexp','displayname',fig3example_cell180.name),'MarkerFaceColor',[0 0 1])
    %legend('toggle')
    
end
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure3/';
savePDF(figure3,savedir,[],'Figure3e')
