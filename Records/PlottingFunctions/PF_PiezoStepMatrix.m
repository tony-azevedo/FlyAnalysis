function newfig = PF_PiezoStepMatrix(fig,handles,savetag)
% see also AverageLikeSines

[~,dateID,flynum,cellnum] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

clear f
cnt = 1;
for bt = blocktrials;
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    disps(cnt) = handles.trial.params.displacement;
    f(cnt) = PiezoStepAverage([],handles,savetag);
    cnt = cnt+1;
end
f = unique(f);
[disps,order] = sort(disps);
f = f(order);
f = reshape(f,length(handles.prtclData(bt).displacements),[]);
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end
newfig = layout_sub(f,...
    sprintf('%s Block %d: {%s} - %s', [handles.currentPrtcl '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:}),savetag),...
    'close');

[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(handles.trial.name);
set(newfig,'name',[dateID '_' flynum '_' cellnum '_' protocol '_Block' num2str(b) '_' mfilename sprintf('_%s',tags{:})])


function varargout = layout_sub(f,name,varargin)
dim = size(f);

h = figure;
set(h,'color',[1 1 1],'position',[1048 259 560 659])
p = panel(h);
p.pack('v',{dim(1)/(dim(1)+1)  1/(dim(1)+1)})  % response panel, stimulus panel
p.margin = [18 18 2 18];
p.fontname = 'Arial';
p(1).marginbottom = 2;
p(2).margintop = 8;

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
        if x>1
            set(ax_to,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
        end
    end
end
set(p(1).de.axis,'xlim',xlims,'ylim',ylims)
set(p(1).de.axis,'xtick',[])
set(p(1).de.axis,'xcolor',[1 1 1])
%p(1).ylabel('Response (mV)')
p(1).de.fontsize = 8;


p(2).pack(1,dim(2))
p(2).de.margin = 2;
ylims = [Inf, -Inf];
for x = 1:dim(2)
    p(2,1,x).select();
    ax_to = gca;
    ax_from = findobj(f(round(dim(1)/2),x),'tag','stimulus_ax');

    ylims_from = get(ax_from,'ylim');
    ylims = [min(ylims(1),ylims_from(1)),...
        max(ylims(2),ylims_from(2))];
    
    copyobj(get(ax_from,'children'),ax_to)
    if x>1
        set(ax_to,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    end

end
set(p(2).de.axis,'xlim',xlims,'ylim',ylims)
p(2).ylabel('Stimulus (V)')
p(2).xlabel('Time (s)')
p(2).de.fontsize = 8;

p.title(name)


h2 = figure;
set(h2,'color',[1 1 1],'tag','PiezoStepMatrixStimuli')
p = panel(h2);
p.pack('v',{dim(1)/(dim(1)+1)  1/(dim(1)+1)})  % response panel, stimulus panel
p.margin = [12 10 2 10];
p.fontname = 'Arial';
p(1).marginbottom = 2;
p(2).margintop = 8;

p(1).pack(dim(1),dim(2))
p(1).de.margin = 2;

ylims = [Inf, -Inf];
for y = 1:dim(1)
    for x = 1:dim(2)
        p(1,y,x).select();
        ax_to = gca;
        ax_from = findobj(f(y,x),'tag','stimulus_ax');
        xlims = get(ax_from,'xlim');
        ylims_from = get(ax_from,'ylim');
        ylims = [min(ylims(1),ylims_from(1)),...
            max(ylims(2),ylims_from(2))];
        
        copyobj(get(ax_from,'children'),ax_to)
        if x>1
            set(ax_to,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
        end
    end
end
set(p(1).de.axis,'xlim',xlims,'ylim',ylims)
set(p(1).de.axis,'xtick',[])
set(p(1).de.axis,'xcolor',[1 1 1])
p(1).ylabel('Stimulus (V)')
p(1).de.fontsize = 8;

p.title([name '_ Stimuli'])


if nargin>2 && strcmp(varargin{1},'close')
    close(f(:))
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
