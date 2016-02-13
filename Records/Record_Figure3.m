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
set(figure3,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneAndHalfColumn'),10])
pnl = panel(figure3);

figurerows = [1 4 1 4 4 4 4 4 4 10];
figurerows = num2cell(figurerows/sum(figurerows));

pnl.pack('v',figurerows);
pnl.margin = [16 16 4 4];

s_0 = -.01;
s_f = .03;
lilgap = .006;
gap = lilgap-s_0+s_f;

%% Figure 3A: Steps for A2
Record_FS_HighFreqDepolB1s

fr = 2;
pnl(fr).pack('h',{1/2 1/2});
pnl(fr).marginbottom = 4;
clear pnl_hs
for r = fr
    for c = 1
        pnl_hs(r-fr+1,c) = pnl(r,c).select();
    end
end

trial = load(fig3example_cell.PiezoStepTrialPost);
h = getShowFuncInputsFromTrial(trial);
fig = PF_PiezoStepAverage([],h,fig3example_cell.genotype);
l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr,1).select());
x = l.XData;
y = l.YData;
set(l,'XData',x(x>=s_0 & x<s_f),'YData',y(x>=s_0 & x<s_f));

% -- Plot anterior step off --
line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*2,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr,1).select(),'color',[.7 0 0])
close(fig)

trial = load(fig3example_cell.PiezoStepTrialAnt);
h = getShowFuncInputsFromTrial(trial);
fig = PF_PiezoStepAverage([],h,fig3example_cell.genotype);
l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr,1).select());
x = l.XData;
y = l.YData;
set(l,'XData',x(x>=s_0 & x<s_f) + gap*1,'YData',y(x>=s_0 & x<s_f));

% -- Plot posterior step off --
line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*3,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr,1).select(),'color',[.7 0 0])
close(fig)

% show the expanded timescale on the other side
trial = load(fig3example_cell.PiezoStepTrialPost);
h = getShowFuncInputsFromTrial(trial);
fig = PF_PiezoStepAverage([],h,fig3example_cell.genotype);
l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr,2).select());
x = l.XData;
y = l.YData;
set(l,'XData',x(x>=-.1 & x<.3),'YData',y(x>=-.1 & x<.3));
close(fig)


% Clean up
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
        set(ax,'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[s_0 s_0+2*gap]);
    end
    set(pnl(fr,2).select(),'xlim',[-.1 .3]);
end


%% Draw the stimuli

fr = 1;
pnl(fr).pack('h',{1/2 1/2});
pnl(fr).marginbottom = 4;
    
clear pnl_hs
for r = fr
    for c = 1
        pnl_hs(r-fr+1,c) = pnl(r,c).select();
    end
end

trial = load(fig3example_cell0.PiezoStepTrialPost);
x = makeInTime(trial.params);
y = PiezoStepStim(trial.params);
line(x(x>=s_0 & x<s_f),y(x>=s_0 & x<s_f),'parent',pnl(fr,1).select());
line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*2,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr,1).select())

trial = load(fig3example_cell0.PiezoStepTrialAnt);
x = makeInTime(trial.params);
y = PiezoStepStim(trial.params);
line(x(x>=s_0 & x<s_f)+ gap*1,y(x>=s_0 & x<s_f),'parent',pnl(fr,1).select());
line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*3,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr,1).select())
set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[s_0 s_0+2*gap]);

% put the full step and its timescale here
trial = load(fig3example_cell0.PiezoStepTrialPost);
x = makeInTime(trial.params);
y = PiezoStepStim(trial.params);
line(x,y,'parent',pnl(fr,2).select());
set(pnl(fr,2).select(),'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[-.1 .3],'ylim',[-1 1]);

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure3/';

%% ****** Figure 3B: Steps and cycles for BPH ******


for sc_ind = 2:length(Scripts)
% sc_ind = 4
    eval(Scripts{sc_ind});
    fr = (sc_ind-1)*2+2;
    
    pnl(fr).pack('h',{1/2 1/2});
    pnl(fr+1).pack('h',{1/2 1/2});
    pnl(fr).marginbottom = 4;
    pnl(fr+1).marginbottom = 4;
    
    clear pnl_hs
    for r = fr:fr+1
        for c = 1:1
            pnl_hs(r-fr+1,c) = pnl(r,c).select();
        end
    end
    
    % Post Cell: Plot anterior step --
    trial = load(fig3example_cell0.PiezoStepTrialPost);
    h = getShowFuncInputsFromTrial(trial);
    fig = PF_PiezoStepAverage([],h,fig3example_cell0.genotype);
    l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr,1).select());
    x = l.XData;
    y = l.YData;
    set(l,'XData',x(x>=s_0 & x<s_f),'YData',y(x>=s_0 & x<s_f));

    % Post Cell: Plot anterior step off --
    line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*2,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr,1).select(),'color',[.7 0 0])
    close(fig)
        
    % Post Cell: Plot posterior step --
    trial = load(fig3example_cell0.PiezoStepTrialAnt);
    h = getShowFuncInputsFromTrial(trial);
    fig = PF_PiezoStepAverage([],h,fig3example_cell0.genotype);
    l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr,1).select());
    x = l.XData;
    y = l.YData;
    set(l,'XData',x(x>=s_0 & x<s_f)+gap*1,'YData',y(x>=s_0 & x<s_f));

    % Post Cell: Plot posterior step off --
    line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*3,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr,1).select(),'color',[.7 0 0])
    close(fig)

    % Ant Cell: Plot anterior step --
    trial = load(fig3example_cell180.PiezoStepTrialPost);
    h = getShowFuncInputsFromTrial(trial);
    fig = PF_PiezoStepAverage([],h,fig3example_cell180.genotype);
    l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr+1,1).select());
    x = l.XData;
    y = l.YData;
    set(l,'XData',x(x>=s_0 & x<s_f),'YData',y(x>=s_0 & x<s_f));

    % Ant Cell: Plot anterior step off --
    line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*2,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr+1,1).select(),'color',[.7 0 0])
    close(fig)

    % Ant Cell: Plot posterior step --
    trial = load(fig3example_cell180.PiezoStepTrialAnt);
    h = getShowFuncInputsFromTrial(trial);
    fig = PF_PiezoStepAverage([],h,fig3example_cell180.genotype);
    l = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line','color',[ .7 0 0]),pnl(fr+1,1).select());
    x = l.XData;
    y = l.YData;
    set(l,'XData',x(x>=s_0 & x<s_f)+gap*1,'YData',y(x>=s_0 & x<s_f));

    % Ant Cell: Plot posterior step off --
    line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*3,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr+1,1).select(),'color',[.7 0 0])
    close(fig)

    set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[s_0 s_0+2*gap]);
    set(pnl_hs(1,:),'ylim',[-45 -30]);
    set(pnl_hs(2,:),'ylim',[-40 -25]);
    delete(findobj(pnl_hs(:),'type','line','color',[1 .7 .7]));
    set(findobj(pnl_hs(2,:),'type','line','color',[.7 0 0]),'color',[0 0 1]);
    set(findobj(pnl_hs(1,:),'type','line','color',[.7 0 0]),'color',[1 0 0]);
    
    clear pnl_hs
    for r = fr:fr+1
        for c = 2
            pnl_hs(r-fr+1,c-1) = pnl(r,c).select();
        end
    end
    
    % ***** Plot sine cycles ****
    trial = load(fig3example_cell0.PiezoSine25);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr,c).select());
    l_25 = findobj(hs,'type','line','color',[.7 0 0]);
    close(fig)
    
    trial = load(fig3example_cell0.PiezoSine50);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr,c).select());
    l_50 = findobj(hs,'type','line','color',[.7 0 0]);
    set(hs,'XData',l_25.XData(end)+lilgap+l_50.XData)
    close(fig)
    
    trial = load(fig3example_cell0.PiezoSine100);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr,c).select());
    l_100 = findobj(hs,'type','line','color',[.7 0 0]);
    set(hs,'XData',l_50.XData(end)+lilgap+l_100.XData)
    close(fig)
    
    % ***** Plot sine cycles ****
    trial = load(fig3example_cell180.PiezoSine25);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr+1,c).select());
    l_25 = findobj(hs,'type','line','color',[.7 0 0]);
    close(fig)
    
    trial = load(fig3example_cell180.PiezoSine50);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr+1,c).select());
    l_50 = findobj(hs,'type','line','color',[.7 0 0]);
    set(hs,'XData',l_25.XData(end)+lilgap+l_50.XData)
    close(fig)
    
    trial = load(fig3example_cell180.PiezoSine100);
    fig = PiezoSineCycle([],getShowFuncInputsFromTrial(trial),fig3example_cell0.genotype);
    hs = copyobj(findobj(get(findobj(fig,'type','axes','tag','response_ax'),'Children'),'type','line'),pnl(fr+1,c).select());
    l_100 = findobj(hs,'type','line','color',[.7 0 0]);
    set(hs,'XData',l_50.XData(end)+lilgap+l_100.XData)
    close(fig)
    
    set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[s_0 s_0+2*gap]);
    set(pnl_hs(1,:),'ylim',[-45 -30]);
    set(pnl_hs(2,:),'ylim',[-40 -25]);
    %delete(findobj(pnl_hs(:),'type','line','color',[1 .7 .7]));
    set(findobj(pnl_hs(2,:),'type','line','color',[1 .7 .7]),'color',[.7 .7  1]);
    set(findobj(pnl_hs(2,:),'type','line','color',[.7 0 0]),'color',[0 0 .7]);
    
    figure(figure3)

    for r = fr:fr+1
        ylims = [Inf,-Inf];
        for c = 1:2
            ax = pnl(r,c).select();
            axis(ax,'tight')
            yl = ax.YLim;
            ylims = ...
                [min([ylims(1),yl(1)]) ...
                max([ylims(2),yl(2)])];
        end
        for c = 1:2
            ax = pnl(r,c).select();
            ax.YLim = ylims;
            set(ax,'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[s_0 s_0+2*gap]);
        end
        
    end
end
%
%% Draw the stimuli

fr = 3;
pnl(fr).pack('h',{1/2 1/2});
pnl(fr).marginbottom = 4;
    
clear pnl_hs
for r = fr
    for c = 1
        pnl_hs(r-fr+1,c) = pnl(r,c).select();
    end
end

trial = load(fig3example_cell0.PiezoStepTrialPost);
x = makeInTime(trial.params);
y = PiezoStepStim(trial.params);
line(x(x>=s_0 & x<s_f),y(x>=s_0 & x<s_f),'parent',pnl(fr,1).select());
line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*2,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr,1).select())

trial = load(fig3example_cell0.PiezoStepTrialAnt);
x = makeInTime(trial.params);
y = PiezoStepStim(trial.params);
line(x(x>=s_0 & x<s_f)+ gap*1,y(x>=s_0 & x<s_f),'parent',pnl(fr,1).select());
line(x(x>=.2+s_0 & x<.2+s_f)-.2 + gap*3,y(x>=.2+s_0 & x<.2+s_f),'parent',pnl(fr,1).select())
set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[s_0 s_0+2*gap]);

clear pnl_hs
for r = fr
    for c = 2
        pnl_hs(r-fr+1,c-1) = pnl(r,c).select();
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
l_25 = line(x_,s_,'parent',pnl(fr,2).select());

trial = load(fig3example_cell180.PiezoSine50);
x = makeInTime(trial.params);
x_win = x>= trial.params.ramptime & x<trial.params.stimDurInSec-trial.params.ramptime;
s = PiezoSineStim(trial.params)/trial.params.displacement;
[~,ascd] = findSineCycle(s(x_win),0,[]);
r = min(diff(ascd));
x_ = x(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
x_ = x_-x_(1);
s_ = s(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
l_50 = line(x_,s_,'parent',pnl(fr,2).select());
set(l_50,'XData',l_25.XData(end)+lilgap+l_50.XData)

trial = load(fig3example_cell180.PiezoSine100);
x = makeInTime(trial.params);
x_win = x>= trial.params.ramptime & x<trial.params.stimDurInSec-trial.params.ramptime;
s = PiezoSineStim(trial.params)/trial.params.displacement;
[~,ascd] = findSineCycle(s(x_win),0,[]);
r = min(diff(ascd));
x_ = x(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
x_ = x_-x_(1);
s_ = s(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
l_100 = line(x_,s_,'parent',pnl(fr,2).select());
set(l_100,'XData',l_50.XData(end)+lilgap+l_100.XData)

set(pnl_hs(:),'tickdir','out','xcolor',[1 1 1],'xtick',[],'xlim',[s_0 s_0+2*gap]);


% savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure3/';
% % savePDF(figure3,savedir,[],'Figure3ad')

%% polar plots of sine coefficients

% figure3 = figure;
% figure3.Units = 'inches';
% set(figure3,'color',[1 1 1],'position',[1 0 getpref('FigureSizes','NeuronOneAndHalfColumn'),10])
% pnl = panel(figure3);
% 
% figurerows = [1 4 4 4 4 4 4 4 20];
% figurerows = num2cell(figurerows/sum(figurerows));
% 
% pnl.pack('v',figurerows);
% pnl.margin = [16 2 4 4];
% 
fr = 10;
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
    dot = plot(ax,transfer(max_idx)); hold on
%    dot = polar(ax,angle(transfer(max_idx)),abs(transfer(max_idx))); hold on
%     dot = polar(ax,angle(transfer(max_idx)),1); hold on
%     set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',clrs(max_idx,:),...
%         'displayname',analysis_cell(max_idx).name)
    set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0],...
        'displayname',analysis_cell(max_idx).name)
    idxs = idxs(idxs~=max_idx);
    
    for c_ind = idxs
        dot = plot(ax,transfer(c_ind)); hold on
%        dot = polar(ax,angle(transfer(c_ind)),abs(transfer(c_ind))); hold on
%         dot = polar(ax,angle(transfer(c_ind)),1); hold on
%         set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',clrs(c_ind,:),...
%             'displayname',analysis_cell(c_ind).name)
        set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',[0 0 0],...
            'displayname',analysis_cell(c_ind).name)
    end
    
    set(findobj(ax,'type','line','-regexp','displayname',fig3example_cell0.name),'MarkerFaceColor',[1 0 0])
    set(findobj(ax,'type','line','-regexp','displayname',fig3example_cell180.name),'MarkerFaceColor',[0 0 1])
    %legend('toggle')
    
    % draw some polar radii
    xy = [0 0; -1 1];
    th = pi/6;
    rot = [cos(th) -sin(th); sin(th) cos(th)];
    for th_ = 0:5
        line(abs(transfer(max_idx))*1.1*xy(1,:),abs(transfer(max_idx))*1.1*xy(2,:),'parent',ax,'color',[ 1 1 1]*.9);
        xy = rot*xy;
    end
    
    set(ax,'box','off','TickDir','out')
    axis(ax,'equal')
end
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure3/';
savePDF(figure3,savedir,[],'Figure3')
