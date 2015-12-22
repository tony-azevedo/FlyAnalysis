function [fig,pnl_hs] = PF_PiezoSineMatrix(averagefig,h,savetag)
% see also AverageLikeSines

[protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(h.trial.name);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'displacement','freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

fig = figure;
set(fig,'color',[1 1 1],'position',[680 165 1163 813])

p = panel(fig);

freqs = h.trial.params.freqs;
fnum = length(freqs);
dspls = h.trial.params.displacements;
dnum = length(dspls);

p.pack('v',{fnum/(fnum+1)  1/(fnum+1)})  % response panel, stimulus panel

p.margin = [18 10 2 10];
p.fontname = 'Arial';
p(1).marginbottom = 2;
p(2).margintop = 8;

p(1).pack(fnum,dnum)
p(1).de.margin = 2;

p(2).pack(1,dnum)
p(2).de.margin = 2;

trialnummatrix = nan(fnum,dnum);
pnl_hs = trialnummatrix;

for bt = blocktrials;
    %h.trial = load(fullfile(h.dir,sprintf(h.trialStem,bt)));

    params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
    
    r = find(freqs == params.params.freq);
    c = find(dspls == params.params.displacement);
    
    trialnummatrix(r,c) = bt; 
end

ylims = [Inf, -Inf];
slims = [Inf, -Inf];
for r = 1:size(trialnummatrix,1)
    for c = 1:size(trialnummatrix,2)
        h.trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(r,c))));
        averagefig = PiezoSineCycle([],h,savetag);
        
        ax_from = findobj(averagefig,'tag','response_ax');

        ylabe = get(get(ax_from,'ylabel'),'string');
        delete(get(ax_from,'xlabel'));
        delete(get(ax_from,'ylabel'));
        delete(get(ax_from,'zlabel'));
        delete(get(ax_from,'title'));

        ylims_from = get(ax_from,'ylim');
        xlims_from = get(ax_from,'xlim');
        ylims = [min(ylims(1),ylims_from(1)),...
            max(ylims(2),ylims_from(2))];

        pnl_hs(r,c) = p(1,r,c).select();
        copyobj(get(ax_from,'children'),pnl_hs(r,c)); 

        set(pnl_hs(r,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
        if r == 1
            sax_from = findobj(averagefig,'tag','stimulus_ax');
            slims_from = get(sax_from,'ylim');
            slims = [min(slims(1),slims_from(1)),...
                max(slims(2),slims_from(2))];
            
            copyobj(get(sax_from,'children'),p(2,r,c).select())
            set(p(2,r,c).select(),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',slims_from);
        end
        % drawnow;
        close(averagefig)
    end
end
set(pnl_hs(:),'ylim',ylims)
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
p(1).ylabel(['Response (' ylabe ')']);
p(1).de.fontsize = 8;

set(p(2).de.axis,'ylim',slims,'xtickmode','auto','xcolor',[0 0 0])
set(p(2,1,1).select(),'ytickmode','auto','ycolor',[0 0 0])
p(2).ylabel('Stimulus (V)')
p(2).xlabel('Time (s)')
p(2).de.fontsize = 8;

tags = getTrialTags(blocktrials,h.prtclData);
b = nan;
if isfield(h.trial.params, 'trialBlock')
    b = h.trial.params.trialBlock;
end

name = sprintf('%s Block %d: {%s} - %s', [h.currentPrtcl '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:}),savetag);
p.title(name);
set(fig,'name',name);

figure(fig);

