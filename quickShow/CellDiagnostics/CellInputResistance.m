function varargout = CellInputResistance(intrial,varargin)
% varargout = CellInputResistance(trial,varargin)
%   plot all the input resistance measurements from the cell.  Save them to
%   the data structure

fig = findobj('type','figure','Name', 'Input Resistance','tag',mfilename);
if isempty(fig);
    if ~ispref('AnalysisFigures') ||~ispref('AnalysisFigures',mfilename) % rmpref('AnalysisFigures','CellInputResistance')
        proplist = {...
            'tag',mfilename,...
            'Position',[8   643   820   354],...
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
V_mh = nan(size(rawfiles));
trialorder = V_mh;
block = V_mh;
name = cell(size(rawfiles));

for r_ind = 1:length(rawfiles)
    % load each trial in turn
    
    trial = load(rawfiles(r_ind).name);
    [prot,~,~,~,num,~,~,~] = ...
        extractRawIdentifiers(trial.name);
    name{r_ind} = [prot '_' num];

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
    
    resp_i = mean(trial.(in)(1:step_start));
    resp_f = mean(trial.(in)(step_start+step_dur-step_start+1:step_start+step_dur));
    
    if strcmp(mode{r_ind},'IClamp')
        Ri(r_ind) = (resp_f-resp_i)/step_amp;
        V_mh(r_ind) = resp_i;
        colr = [1 0 1];
    elseif strcmp(mode{r_ind},'VClamp')
        Ri(r_ind) = step_amp/(resp_f-resp_i);
        V_mh(r_ind) = outmu; 
        colr = [0 1 1];
    end
               
end
[tro, ord] = sort(trialorder);
trialtime = trialtime(ord);
Ri = Ri(ord);
V_mh = V_mh(ord);
block = block(ord);
name = name(ord);

ax = subplot(3,1,[1 2],'parent',fig);
set(ax,'XTickLabel',{[]});
ylabel(ax,'R (m - IC, c - VC)')
title(ax,[dateID '\_' flynum '\_' cellnum])

block_diff = [1; diff(block)];
text_y = mean(Ri(Ri>0))*.2;

for r_ind = 1:length(tro)
    if strcmp(mode{r_ind},'IClamp')
        colr = [1 0 1];
    elseif strcmp(mode{r_ind},'VClamp')
        colr = [0 1 1];
    end
    if Ri(r_ind)>0;
        line(trialtime(r_ind),Ri(r_ind),'parent',ax,'linestyle','none','marker','.','markerfacecolor',colr,'markeredgecolor',colr);
    else
        line(trialtime(r_ind),0,'parent',ax,'linestyle','none','marker','s','markerfacecolor',[0 0 0],'markeredgecolor',colr);
    end
    if block_diff(r_ind)
        text(trialtime(r_ind),-.5,regexprep(name{r_ind},'_',' '),'rotation',45,'fontsize',7);
    end
    
    Ri_struct(r_ind).time = trialtime(r_ind);
    Ri_struct(r_ind).mode = mode{r_ind};
    Ri_struct(r_ind).Ri = Ri(r_ind);
    Ri_struct(r_ind).V_mh = V_mh(r_ind);
    Ri_struct(r_ind).name = name{r_ind};
end
ylims = get(ax,'ylim');
set(ax,'ylim',[-1 ylims(2)])

% Is there a relationship for a Ri vs holding Potential?
ax = subplot(3,1,3,'parent',fig);
plot(ax,Ri(Ri>0),V_mh(Ri>0),'.k');

axis(ax,'tight')
xlim(ax,[0,3])
xlabel(ax,'R_i (G\Omega)');
ylabel(ax,'Holding V_m (mV)');

varargout = {trial};

%
%     data = load(dfile); data = data.data;
