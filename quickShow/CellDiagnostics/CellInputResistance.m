function varargout = CellInputResistance(intrial,varargin)
% varargout = CellInputResistance(trial,varargin)
%   plot all the input resistance measurements from the cell.  Save them to
%   the data structure

fig = findobj('type','figure','Name', 'Input Resistance','tag',mfilename);
if isempty(fig);
    if ~ispref('AnalysisFigures') ||~ispref('AnalysisFigures',mfilename) % rmpref('AnalysisFigures','CellInputResistance')
        proplist = {...
            'tag',mfilename,...
            'Position',[8   276   820   720],...
            'NumberTitle', 'off',...
            'Name', 'Input Resistance',... % 'DeleteFcn',@obj.setDisplay);
            };
        setpref('AnalysisFigures',mfilename,proplist);
    end
    proplist =  getpref('AnalysisFigures',mfilename);
    fig = figure(proplist{:});

    %     p = uicontrol('parent',fig,'style','pushbutton',...
    %         'units','normalized','position',[.01 .92 .1 .08],...
    %         'string','Clear',...
    %         'callback',@clearaverage);
    % set(p,'units','points')
else
    clf(fig);
end

% Load in the first file
%[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = 
[~,dateID,flynum,cellnum,~,Dir,~,dfile] = ...
    extractRawIdentifiers(intrial.name);

% Find all the rawfiles
rawfiles = dir([Dir '*_Raw_*.mat']);
l = false(1,length(rawfiles));
for r_ind = 1:length(rawfiles)
    l(r_ind) = isempty(strfind(rawfiles(r_ind).name,'SealAndLeak'));
end
rawfiles = rawfiles(l); 
 
% Find all the protocols run in this file
% protocols = cell(length(rawfiles),1);
% for f = 1:length(rawfiles)
%     protocols{f} = strtok(rawfiles(f).name,'_');
% end
% protocols = unique(protocols);

Ri_struct.time = [];
Ri_struct.mode = '';
Ri_struct.Ri = [];
Ri_struct.V_mh = [];

Ri_struct = repmat(Ri_struct,size(rawfiles));
trialtime = nan(size(rawfiles));
mode = cell(size(rawfiles));
Ri = nan(size(rawfiles));
access = nan(size(rawfiles));
V_mh = nan(size(rawfiles));
trialorder = V_mh;
block = V_mh;
name = cell(size(rawfiles));

tic
for r_ind = 1:length(rawfiles)
    % load each trial in turn
    
    trial = load(rawfiles(r_ind).name);
    [prot,~,~,~,num,~,~,~] = ...
        extractRawIdentifiers(trial.name);
    name{r_ind} = [num2str(trial.params.trialBlock) ' ' prot];
    if strcmp('Sweep',prot) && isfield(trial,'excluded') && trial.excluded
        continue
    end
    if strcmp('PiezoStep',prot) && sum(strcmp(trial.tags,'turn on')) && isfield(trial,'excluded') && trial.excluded
        continue
    end
    if sum(strcmp(trial.tags,'Total Crap')) && isfield(trial,'excluded') && trial.excluded
        continue
    end

    % get the creation date
    if isfield(trial,'timestamp')
        trialtime(r_ind) = trial.timestamp;
        trialorder(r_ind) = getTrialOrderFromNotes(trial);
    else
        [trialorder(r_ind),trialtime(r_ind)] = getTrialOrderFromNotes(trial);
        trial.timestamp = trialtime(r_ind);
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end
    
    block(r_ind) = trial.params.trialBlock;
    if ~isempty(trial.tags), drgs{r_ind} = trial.tags{end}; else drgs{r_ind} = ' '; end
    
    % get the mode
    mode{r_ind} = trial.params.mode;
        
    if strcmp(mode{r_ind},'IClamp')
        out = 'current';
        in = 'voltage';
    elseif strcmp(mode{r_ind},'VClamp')
        out = 'voltage';
        in = 'current';
    else
        error
    end        
    t = makeInTime(trial.params);
    
    if strcmp('Sweep',prot)
        outmu = mean(trial.(out)(t>.25 & t<.3));
    else
        outmu = mean(trial.(out)(t>-.01 & t<0));
    end
    
    step_start = find(trial.(out) < outmu - 1,1);
    step_dur = find(trial.(out)(step_start:end) > outmu - 1,1)-2;
    step_amp = mean(trial.(out)(step_start+1:step_dur)) - outmu;
    
    if sum(strcmp(trial.tags,'break-in'))
        step_start = .01*trial.params.sampratein;
        step_dur = .05*trial.params.sampratein;
        step_amp = -2.5;
    end
    
    resp_i = mean(trial.(in)(1:step_start));
    resp_f = mean(trial.(in)(step_start+step_dur-step_start+1:step_start+step_dur));
    resp_min = min(trial.(in)(step_start:step_start+round(step_dur/4)));
    resp_max = max(trial.(in)(step_start+step_dur:step_start+step_dur+round(step_dur/4)));

    if strcmp(mode{r_ind},'IClamp')
        Ri(r_ind) = (resp_f-resp_i)/step_amp;
        V_mh(r_ind) = resp_i;
        colr = [1 0 1];
    elseif strcmp(mode{r_ind},'VClamp')
        Ri(r_ind) = step_amp/(resp_f-resp_i);
        V_mh(r_ind) = outmu; 
        colr = [0 1 1];
        if ~isnan(step_amp), access(r_ind) = step_amp/mean([(resp_min-resp_i) -abs(resp_max-resp_i)]); end
    end
               
end
trialtime = trialtime(~isnan(trialorder));
Ri = Ri(~isnan(trialorder));
access = access(~isnan(trialorder));
V_mh = V_mh(~isnan(trialorder));
block = block(~isnan(trialorder));
name = name(~isnan(trialorder));
mode = mode(~isnan(trialorder));
drgs = drgs(~isnan(trialorder));
trialorder = trialorder(~isnan(trialorder));


[tro, ord] = sort(trialorder);
trialtime = trialtime(ord);
Ri = Ri(ord);
access = access(ord);
V_mh = V_mh(ord);
block = block(ord);
name = name(ord);
mode = mode(ord);
drgs = drgs(ord);

ax = subplot(1,1,1,'parent',fig);
set(ax,'XTickLabel',{[]});
ylabel(ax,'R (G\Omega; m - IC, c - VC)')
xlabel(ax,'Trials');
title(ax,[dateID '\_' flynum '\_' cellnum])

block_diff = [1; diff(block)];
drug = drgs{1};
text_y = mean(Ri(Ri>0))*.2;

toc
for r_ind = 1:length(tro)
    if strcmp(mode{r_ind},'IClamp')
        colr = [1 0 1];
    elseif strcmp(mode{r_ind},'VClamp')
        colr = [0 1 1];
    end
    if Ri(r_ind)>4
        line(trialtime(r_ind),Ri(r_ind)/100,'parent',ax,'linestyle','none','marker','p','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0]);
    elseif Ri(r_ind)>0;
        line(trialtime(r_ind),Ri(r_ind),'parent',ax,'linestyle','none','marker','o','markerfacecolor',colr,'markeredgecolor',colr,'markersize',2);
    else
        line(trialtime(r_ind),0,'parent',ax,'linestyle','none','marker','s','markerfacecolor',[0 0 0],'markeredgecolor',colr);
    end
    
    line(trialtime(r_ind),access(r_ind),'parent',ax,'linestyle','none','marker','+','markerfacecolor',.75* colr,'markeredgecolor',.75 * colr,'markersize',2,'tag','access');
    
    if block_diff(r_ind)
        text(trialtime(r_ind),-.5,regexprep(name{r_ind},'_',' '),'rotation',45,'fontsize',7);
    end
    if ~strcmp(drgs{r_ind},drug)
        drug = drgs{r_ind};
        text(trialtime(r_ind),1,drug,'verticalalignment','top','horizontalalignment','left');
    end
    if strcmp(drgs{r_ind},'break-in')
        text(trialtime(r_ind),.2,[sprintf('%.0f',(Ri(r_ind))) ' G\Omega'],'verticalalignment','top','horizontalalignment','left');
    end
   
    Ri_struct(r_ind).time = trialtime(r_ind);
    Ri_struct(r_ind).mode = mode{r_ind};
    Ri_struct(r_ind).Ri = Ri(r_ind);
    Ri_struct(r_ind).V_mh = V_mh(r_ind);
    Ri_struct(r_ind).name = name{r_ind};
    Ri_struct(r_ind).access = access(r_ind);
end
toc

%ylims = get(ax,'ylim');
axis(ax,'tight')
xlims = get(ax,'xlim');
ylims = get(ax,'ylim');
set(ax,'ylim',[-.6 ylims(2)])
line(xlims,[0 0],'parent',ax,'linestyle','-','color',[.8 .8 .8],'tag','baseline');

% Is there a relationship between Ri vs holding Potential?
% ax = subplot(3,1,3,'parent',fig);
% plot(ax,Ri(Ri>0),V_mh(Ri>0),'.k');
% 
% axis(ax,'tight')
% xlim(ax,[0,2])
% xlabel(ax,'R_i (G\Omega)');
% ylabel(ax,'Holding V_m (mV)');

set(fig,'Name',[dateID '_' flynum '_' cellnum '_InputR'])

toc
varargout = {trial,fig,Ri_struct,access};

%
%     data = load(dfile); data = data.data;
