%% Plot f2/f2 ratio for PiezoSine

close all
c_indv = [];
for c_ind = 1:length(analysis_cell)
    if ~isempty(analysis_cell(c_ind).PiezoSineTrial)
        c_indv(end+1) = c_ind;
    end
end

f = figure;
set(f,'position',[517 9   968   988],'color',[1 1 1])
pnl = panel(f);
pnl.pack(ceil(length(c_indv)/3),3)
pnl.margin = [20 20 10 10];
%pnl(1).marginbottom = 2;
%pnl(2).marginbottom = 2;

cnt = 0;
for c_ind = 1:length(c_indv)
    cnt = cnt+1;
    x = ceil(cnt/3);
    y = mod(cnt,3); if y ==0,y=3;end
    pnl(x,y).pack('v',{1/3 1/3 1/3})
    pnl(x,y).de.marginbottom = 2;
    pnl(x,y).de.margintop = 2;
    axF1 = pnl(x,y,1).select(); hold on
    axF2 = pnl(x,y,2).select(); hold on
    axRa = pnl(x,y,3).select(); hold on
    set([axF1,axF2],'xtick',[],'xcolor',[1 1 1]);
    set([axF1,axF2,axRa],'xscale','log');
    pnl(x,y,1).title(regexprep(analysis_cell(c_indv(c_ind)).name,'_','\\_'));
    drawnow
    
    trial = load(analysis_cell(c_indv(c_ind)).PiezoSineTrial);
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
        
    % hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
    [Ratio,F1,F2,freqs,displ] = PF_PiezoSineF2_2_F1([],obj,'','plot',0);
    
    for d_ind = 1:length(displ)
        plot(axF1,freqs,F1(:,d_ind),...
            'color',[0 d_ind/length(displ) 0],...
            'displayname',[num2str(displ(d_ind)) 'V']);
        plot(axF2,freqs,F2(:,d_ind),...
            'color',[0 d_ind/length(displ) 0],...
            'displayname',[num2str(displ(d_ind)) 'V']);
        plot(axRa,freqs,Ratio(:,d_ind),...
            'linestyle','none',...
            'marker','o',...
            'markersize',1.5,...
            'markerfacecolor',[0 d_ind/length(displ) 0],...
            'markeredgecolor',[0 d_ind/length(displ) 0],...
            'displayname',[num2str(displ(d_ind)) 'V']);
    end
    set([axF1,axF2,axRa],'xlim',[10 1000]);
    drawnow
end



if save_log
    fn = fullfile(savedir,[id 'F1vsF2components.pdf']);
    pnl.fontname = 'Arial';
    pnl.fontsize = 7;
    figure(f)
    eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
end
