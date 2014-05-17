function varargout = CurrentSineMatrix(fig,handles,savetag)
% see also AverageLikeSines

[prot,datestr,fly,cellnum,~,~] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'amp','freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

clear f
cnt = 1;
if isfield(handles.trial.params,'mode_1')
    multi = 1;
else
    multi = 0;
end

for bt = blocktrials;
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    if ~multi
        f(cnt) = CurrentSineAverage([],handles,savetag);
    elseif multi
        f(cnt) = CurrentSineAverageSingleTrode([],handles,savetag,'trode','1');
    end
    cnt = cnt+1;
end
f = unique(f);
f = sort(f);
if ~isfield(handles.prtclData(bt),'amps');
    handles.prtclData(bt).amps = handles.prtclData(bt).amp;
end
f = reshape(f,length(handles.prtclData(bt).amps),length(handles.prtclData(bt).freqs));
f = f';
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end

h = layout_sub(f,...
    sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
    'close');

varargout{1} = h;
%varargout{2} = p;

% varargout{1} = layout(f,...
%     sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
%     'close');

if multi
    clear f
    cnt = 1;
    for bt = blocktrials;
        handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
        f(cnt) = CurrentSineAverageSingleTrode([],handles,savetag,'trode','2');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    if ~isfield(handles.prtclData(bt),'amps');
        handles.prtclData(bt).amps = handles.prtclData(bt).amp;
    end
    f = reshape(f,length(handles.prtclData(bt).amps),length(handles.prtclData(bt).freqs));
    f = f';
    tags = getTrialTags(blocktrials,handles.prtclData);
    
    b = nan;
    if isfield(handles.trial.params, 'trialBlock')
        b = handles.trial.params.trialBlock;
    end
    h = layout_sub(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
    varargout{1} = [varargout{1},h];
    %     varargout{4} = p;

end


function varargout = layout_sub(f,name,varargin)
dim = size(f);

h = figure;
set(h,'color',[1 1 1])
p = panel(h);
p.pack('v',{dim(1)/(dim(1)+1)  1/(dim(1)+1)})  % response panel, stimulus panel
p.margin = [13 10 2 10];
p(1).marginbottom = 2;
p(2).marginleft = 12;

p(1).pack(dim(1),dim(2))
p(1).de.margin = 2;

ylims = [Inf, -Inf];
for y = 1:dim(1)
    for x = 1:dim(2)
        p(1,y,x).select();
        ax_to = gca;
        ax_from = findobj(f(y,x),'tag','response_ax');
        xlims = get(ax_from,'xlim');
        ylims_from = get(ax_from,'ylim');
        ylims = [min(ylims(1),ylims_from(1)),...
            max(ylims(2),ylims_from(2))];
        
        copyobj(get(ax_from,'children'),ax_to)
    end
end
set(p(1).de.axis,'xlim',xlims,'ylim',ylims)
set(p(1).de.axis,'xtick',[])
set(p(1).de.axis,'xcolor',[1 1 1])
p(1).ylabel('Response (mV)')
p(1).de.fontsize = 8;


p(2).pack(1,dim(2))
p(2).de.margin = 2;
ylims = [Inf, -Inf];
for x = 1:dim(2)
    p(2,1,x).select();
    ax_to = gca;
    ax_from = findobj(f(y,x),'tag','stimulus_ax');

    ylims_from = get(ax_from,'ylim');
    ylims = [min(ylims(1),ylims_from(1)),...
        max(ylims(2),ylims_from(2))];
    
    copyobj(get(ax_from,'children'),ax_to)

end
set(p(2).de.axis,'xlim',xlims,'ylim',ylims)
p(2).ylabel('Stimulus (pA)')
p(2).xlabel('Time (s)')
p(2).de.fontsize = 8;

p.title(name)
if nargin>2 && strcmp(varargin{1},'close')
    close(f(:)')
end

varargout{1} = h;
%varargout{2} = p;

% % if we set the properties on the root panel, they affect
% % all its children and grandchildren.
% p.fontname = 'Courier New';
% p.fontsize = 10;
% p.fontweight = 'normal'; % this is the default, anyway
% 
% % however, any child can override them, and the changes
% % affect just that child (and its descendants).
% p(2,2).fontsize = 14;
