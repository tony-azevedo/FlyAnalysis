
% Useful code snippets and scratch
error('Code not meant to be run')
%%
fig = figure(1);
ax(1) = axes('position',[0.04,0.04,0.66,0.92],'parent',fig);
title(ax1,sprintf('%s_%s',regexprep(groupstr,'_','\\_'),grouptrialstr));
orient(fig,'landscape'); print(fig,'-depsc',get(fig,'fileName')); close all
ax1 = subplot(3,1,[1 2],'parent',plotcanvas);

%%
line(x,y,'parent',ax,'DisplayName',dspn,...
    'color',[1 1 1]*0,...
    'linestyle',ls,...
    'marker',m,...
    'markerfacecolor',[1 1 1]*0,...
    'markeredgecolor',[1 1 1]*0,...
    'markersize',ms ...
    )

%%
trials = zeros(length(data));
for t = 1:length(trials)
    trials(t) = data(t).trial;
end

%%
text(e+1,min(ylims)+diff(ylims)*.05,sprintf('%g',e),'parent',ax(1));
%%

xlabel(ax(2),'V\_m');
ylabel(ax(2),'freq');

%% time
stim_time = ((1:data(group(1)).nsampout) - data(group(1)).stimonsamp)/data(group(1)).samprateout;
data_time = (1:data(group(1)).nsampin)/data(group(1)).sampratein - data(group(1)).stimonsamp/data(group(1)).samprateout;


%% scratch

a = dir('WCwaveform*');
if isempty(a)
    disp('No WCwaveform file')
elseif length(a)>1
    disp('Which WCwaveform file do you mean?')
else
    load(a.name)
end
clear a

%% frequency axis
f = samprate/length(x)*[0:length(x)/2]; f = [f, fliplr(f(2:end-1))];
f = trial.params.sampratein/length(v)*[0:length(v)/2]; f = [f, fliplr(f(2:end-1))];

%% Preferences
 addpref('ControlOutput','Position',[0.6000   75.6154   69.6000    5.5385])
 
 % simple thresholding
 
%% guistuff
guidata(hObject,handles)
handles = guidata(hObject);


%% get all the protocols run on a cell
protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

%% make an options entry
if nargin>1
    optionstr = varargin{1};
    if strcmp(optionstr(1),'-')
        for c = 1:length(optionstr(2:end))
            switch optionstr(c)
                case 'q'
                    quiet = true;
            end
        end
    end
    varargin = varargin{2:end};
end

%% Saving trials!  not bad
save(regexprep(data.name,'Acquisition','Raw_Data'), '-struct', 'data');
save(data.name, '-struct', 'data');
save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

%% Mex building
mex -LC:\Users\Anthony' Azevedo'\code\flySound\Multiclamp_SDK\3rd' Party Support'\AxMultiClampMsg\ -lAxMultiClampMsg GetMode.cpp

%% Panel stuff
if x>1
    set(ax_to,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
end

%% Parser
p = inputParser;
p.PartialMatching = 0;
p.addParameter('NewROI','Yes',@ischar);
p.addParameter('dFoFfig',[],@isnumeric);
p.addParameter('MotionCorrection',true,@islogical);
p.addParameter('ShowMovies',false,@islogical);
p.addParameter('MovieLocation','',@ischar);

parse(p,varargin{:});

%% Panel 
figure(fig);
set(fig,'color',[1 1 1])
panl = panel(fig);

panl.pack('v',{1/3 2/3})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).margintop = 8;

panl(1).pack('h',{1/3 2/3})
%p(1).de.margin = 2;

vertdivisions = [2 1 4 4]; vertdivisions = num2cell(vertdivisions/sum(vertdivisions));

[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(data.name);
    
panl.title([protocol '\_' dateID '\_' flynum '\_' cellnum '\_' trialnum])

[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(data.name);

panl.title([protocol '\_' dateID '\_' flynum '\_' cellnum '\_' trialnum '\_' mfilename])
set(h,'name',[dateID '_' flynum '_' cellnum '_' protocol '_' trialnum '_' mfilename])


%% colors

ax = subplot(1,1,1); hold on
colors = get(gca,'ColorOrder');
colors = [colors; (2/3)*colors];

%% figure names
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end
[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(data.name);
name = sprintf('%s Block %d: {%s}', [protocol '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:}));

%% legend stuff
legend(pnl(1,1).select(),'toggle');
l = findobj(fig,'Tag','legend');
set(l,'location','NorthWest','interpreter','none','box','off');

%% Changing order of lines
uistack(findobj(pnl(1).select(),'linewidth',2),'top');

%% setting xlims across panels
ylims = [Inf -Inf];

ylims(1) = min([ylims(1) min(current_diff(x>i &x<f))]);
ylims(2) = max([ylims(2) max(current_diff(x>i &x<f))]);

ylims = [...
    min([ylims(1) min(get(pnl1,'ylim'))]),...
    max([ylims(2) max(get(pnl1,'ylim'))])];

%% exposure times
t = makeInTime(trial.params);
trial.exposure_time = t(trial.exposure);
    
%% extract elements from a cell array
b = [a,{'r'}];

%% decide which input vector to use
switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   

%% Right hand axis
yyaxis right
ax.YLim = [-20 140];
ylabel('FR (Hz)');