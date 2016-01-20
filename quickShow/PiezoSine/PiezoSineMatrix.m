function fig = PiezoSineMatrix(fig,h,savetag)
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
set(fig,'color',[1 1 1],'position',[680 165 1163 813],'name',[dateID '_' flynum '_' cellnum '_' mfilename])

p = panel(fig);
p.margin = [18 18 18 10];

freqs = h.trial.params.freqs;
fnum = length(freqs);
dspls = h.trial.params.displacements;
dnum = length(dspls);

p.pack('v',{fnum/(fnum+1)  1/(fnum+1)})  % response panel, stimulus panel

p(1).pack(fnum,dnum)
p(1).de.margin = 2;

p(2).pack(1,dnum)
p(2).de.margin = 2;


fig2 = figure;
set(fig2,'color',[1 1 1],'tag','PiezoSineMatrixStimuli')
p2 = panel(fig2);
p2.pack(fnum,dnum)  % response panel, stimulus panel
p2.margin = [12 10 2 10];
p2.fontname = 'Arial';
p2.de.margin = 2;

trialnummatrix = nan(fnum,dnum);
pnl_hs = trialnummatrix;
pnl2_hs = trialnummatrix;

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
        drawnow;

        h.trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(r,c))));
        averagefig = PiezoSineAverage([],h,savetag);
        
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
        
        sax_from = findobj(averagefig,'tag','stimulus_ax');
        copyobj(get(sax_from,'children'),p2(r,c).select())
        set(p2(r,c).select(),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from);
        pnl2_hs(r,c) = p2(r,c).select();

        if r == 1
            sax_from = findobj(averagefig,'tag','stimulus_ax');
            slims_from = get(sax_from,'ylim');
            slims = [min(slims(1),slims_from(1)),...
                max(slims(2),slims_from(2))];
            
            copyobj(get(sax_from,'children'),p(2,r,c).select())
            set(p(2,r,c).select(),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',slims_from);
        end
        close(averagefig)
    end
end
tic
set(pnl_hs(:),'ylim',ylims)
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
p(1).ylabel(['Response (' ylabe ')']);
p(1).de.fontsize = 8;
toc

tic
set(p(2).de.axis,'ylim',slims,'xtickmode','auto','xcolor',[0 0 0])
set(p(2,1,1).select(),'ytickmode','auto','ycolor',[0 0 0])
p(2).ylabel('Stimulus (V)')
p(2).xlabel('Time (s)')
p(2).de.fontsize = 8;
toc

tic
set(pnl2_hs(:),'ylim',slims)
set(pnl2_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
p2.ylabel(['Stimulus (V)']);
p2.de.fontsize = 8;
toc

tags = getTrialTags(blocktrials,h.prtclData);
b = nan;
if isfield(h.trial.params, 'trialBlock')
    b = h.trial.params.trialBlock;
end

name = sprintf('%s Block %d: {%s}', [h.currentPrtcl '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:}));
p.title(name);

