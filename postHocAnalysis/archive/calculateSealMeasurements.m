function varargout = calculateSealMeasurements(data,params,varargin)
% calculateSealMeasurements(data,params,varargin)

if ~isfield(params,'mode') || ~sum(strcmp({'VClamp'},params.mode));
    varargout = {};
    return
end

fig = findobj('tag',mfilename); 
if isempty(fig);
    if ~ispref('AnalysisFigures') ||~ispref('AnalysisFigures',mfilename) %rmpref('AnalysisFigures','calculateSealMeasurements')
        proplist = {...
            'tag',mfilename,...
            'Position',[9    10   560   219],...
            'NumberTitle', 'off',...
            'Name', mfilename,... % 'DeleteFcn',@setDisplay);
            };
        setpref('AnalysisFigures',mfilename,proplist);
    end
    proplist =  getpref('AnalysisFigures',mfilename);
    fig = figure(proplist{:});
end
if nargin>2
    t = varargin{1};
else
    t = makeTime(params);
    if mod(t,2)
        t = t(1:end-1);
    end
end
if nargin>3
    data.name = varargin{2};
end
if nargin>4
    data.tags = varargin{3};
end


[prot,d,fly,cell,trial,D] = extractRawIdentifiers(data.name);
set(fig,'FileName',[mfilename '_' prot '_' d '_' fly '_' cell '_' trial]);

y = data.current(:,1);
stimpnts = params.stepdur*params.samprateout;
y = reshape(y,2*stimpnts,params.pulses);

base = mean(mean(y(round(15/8*stimpnts):end,:),2));

y_bar = mean(y,2) - base;

% R = V/I(at end of step);
sealRes_Est1 = params.stepamp/1000 / (mean(y_bar(stimpnts-100:stimpnts))*1e-12);
accessRes_Est1 = params.stepamp/1000 / (max(y_bar)*1e-12);

[peakI,ttpk1] = max(y_bar);
[~,ttpk] = min(y_bar(ttpk1:stimpnts/2));
curr_end_on = mean(y_bar(ttpk1+ttpk-4:ttpk1+ttpk+4));

inputRes_Est1 = params.stepamp/1000 / (curr_end_on*1e-12);

t_x_ = t(ttpk1:ttpk1+ttpk-1) - t(ttpk1);
t_y_ = y_bar(ttpk1:ttpk1+ttpk-1);
transientdecay = nlinfit(t_x_,t_y_,@exponential,[curr_end_on,peakI,inputRes_Est1*1E-13]);

cellCap_Est1 = transientdecay(3)/inputRes_Est1;

curr_end_off = mean(y_bar(stimpnts-100:stimpnts));
[peakI,ttpk1] = min(y_bar);
[~,ttpk] = max(y_bar(ttpk1:ttpk1+stimpnts/2));
curr_start_off = mean(y_bar(ttpk1+ttpk-4:ttpk1+ttpk+4));

inputRes_Est2 = params.stepamp/1000 / ((curr_end_off-curr_start_off)*1e-12);

t_x_ = t(ttpk1:ttpk1+ttpk-1) - t(ttpk1);
t_y_ = y_bar(ttpk1:ttpk1+ttpk-1);
transientdecay = nlinfit(t_x_,t_y_,@exponential,[curr_start_off,peakI,inputRes_Est2*1E-13]);

cellCap_Est2 = transientdecay(3)/inputRes_Est2;

cellCap = mean([cellCap_Est1 cellCap_Est2]);

str = sprintf('R_a (M\\Omega) = %.0f; \nR_i_{on} (M\\Omega) = %.0f; \nR_i_{off} (M\\Omega) = %.0f \nC (fF) = %.0f',...
    accessRes_Est1/1e6,...
    inputRes_Est1/1e6,...
    inputRes_Est2/1e6,...
    cellCap/1e-15);

ax = findobj(fig,'type','axes','-not','tag','legend');
if isempty(ax)
    ax = subplot(1,1,1,'parent',fig,'tag',[mfilename 'ax']);
else
    delete(get(ax,'children'));
end

plot(t(t>=0 & t< params.stepdur*2),y,'parent',ax,'color',[1 .7 .7],'linewidth',1); hold on
line(t(t>=0 & t< params.stepdur*2),y_bar+base,'parent',ax,'color',[.7 0 0],'linewidth',1,'displayname',str);
line(t(t>=0 & t< params.stepdur*2),base,'parent',ax,'color',[.5 .5 .5],'linewidth',1,'displayname',str);
line(t(t>=0 & t< params.stepdur/2),curr_end_on+base,'parent',ax,'color',[.5 .5 .5],'linewidth',1,'displayname',str);
line(t(t>=params.stepdur & t< params.stepdur+params.stepdur/2),curr_start_off+base,'parent',ax,'color',[.5 .5 1],'linewidth',1,'displayname',str);
line(t(t>=params.stepdur & t< params.stepdur+params.stepdur/2),curr_end_off+base,'parent',ax,'color',[.5 .5 1],'linewidth',1,'displayname',str);
text(t(stimpnts+100),min(y_bar)+base,...
    str,'parent',ax,...
    'fontsize',10,'verticalAlignment','bottom');
box off; set(gca,'TickDir','out');

ylabel(ax,'pA'); %xlim([0 max(t)]);
xlabel(ax,'Time (s)'); xlim(ax,[t(1) params.stepdur*2]);
title(ax,sprintf('%s %s\\}', [prot ' ' d ' ' fly ' ' cell ' ' trial], sprintf('\\{%s;',data.tags{:})));

[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(data.name);
set(fig,'name',[protocol '_' dateID '_' flynum '_' cellnum '_' trialnum '_' mfilename])

figure(fig);
varargout = {inputRes_Est1,inputRes_Est2,accessRes_Est1,cellCap,sealRes_Est1,fig};
