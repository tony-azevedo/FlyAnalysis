
%% Exporting PiezoSineMatrix info on cells 
% close all
% if save_log
%     for c_ind = 1:length(analysis_cell)
%         if ~isempty(analysis_cell(c_ind).PiezoSineTrial)
%             close all
%             trial = load(analysis_cell(c_ind).PiezoSineTrial);
%             obj.trial = trial;
%             
%             [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
%                 extractRawIdentifiers(trial.name);
%             
%             prtclData = load(dfile);
%             obj.prtclData = prtclData.data;
%             obj.prtclTrialNums = obj.currentTrialNum;
%             
%             f = PiezoSineMatrix([],obj,'');
%             p = panel.recover(f);
%             
%             % genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
%             % if ~isdir(genotypedir), mkdir(genotypedir); end
%             if isfield(obj.trial.params,'trialBlock'); b = num2str(obj.trial.params.trialBlock); else b = 'NaN';end
%             fn = fullfile(savedir,'Matrices',[id, ...
%                 dateID '_', ...
%                 flynum '_', ...
%                 cellnum '_', ...
%                 b '_',...
%                 'PiezoSineMatrix', ...
%                 '.pdf']);
%             p.fontname = 'Arial';
%             p.export(fn, '-rp','-l');
%         end
%     end
% end


%% Exporting PiezoSineOsciRespVsFreq info on cells with X-functions
close all
clear transfer freqs dsplcmnts f       
cnt = 0;
for c_ind = 1:length(analysis_cell)
if ~isempty(analysis_cell(c_ind).PiezoSineTrial)
trial = load(analysis_cell(c_ind).PiezoSineTrial);
obj.trial = trial;

[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

cnt = cnt+1;
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

if exist('f','var') && ishandle(f), close(f),end

% hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
[transfer{cnt},freqs{cnt},dsplcmnts{cnt}] = PiezoSineDepolRespVsFreq([],obj,'');
f = findobj(0,'tag','PiezoSineDepolRespVsFreq');
if save_log
    p = panel.recover(f);
    if isfield(obj.trial.params,'trialBlock'), tb = num2str(obj.trial.params.trialBlock);
    else tb = 'NaN';
    end
    fn = fullfile(savedir,[id dateID '_' flynum '_' cellnum '_' tb '_',...
        'PiezoSineDepolRespVsFreq.pdf']);
    p.fontname = 'Arial';
    p.export(fn, '-rp','-l','-a1.4');
end
end
end

% Count the number of displacements, etc
all_dsplcmnts = [];
for d_ind = 1:length(dsplcmnts) 
    all_dsplcmnts = [all_dsplcmnts,round(dsplcmnts{d_ind}*100)/100];
end
all_dsplcmnts = sort(unique(all_dsplcmnts));
all_dsplcmnts = [0.15 .5 1.5];

all_freqs = [];
for d_ind = 1:length(freqs) 
    all_freqs = [all_freqs,round(freqs{d_ind}*100)/100];
end
all_freqs = sort(unique(all_freqs));

% Plotting transfer from all cells
f = figure;
set(f,'position',[7         226        1903         752])
pnl = panel(f);
pnl.pack('v',{2/6  2/6 2/6})  % response panel, stimulus panel
pnl.margin = [20 20 10 10];
pnl(1).marginbottom = 2;
pnl(2).marginbottom = 2;

pnl(1).pack('h',length(all_dsplcmnts));
pnl(2).pack('h',length(all_dsplcmnts));

ylims = [0 -Inf];
for d_ind = 1:length(all_dsplcmnts)
    dspltranf = nan(length(transfer),length(all_freqs));
    ax1 = pnl(1,d_ind).select(); hold(ax1,'on')
    ax2 = pnl(2,d_ind).select(); hold(ax2,'on')
    for c_ind = 1:length(transfer)
        dspl = dsplcmnts{c_ind};
        [~,d_i] = min(abs(dspl - all_dsplcmnts(d_ind)));
        if isempty(d_i)
            continue
        end
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
        dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(:,d_i)))';
        
        plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i))),...
            'parent',ax1,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85])
        plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i)))/max(real(abs(transfer{c_ind}(:,d_i)))),...
            'parent',ax2,'linestyle','-','color',0*[.85 .85 .85],...
            'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85])
    end
    %plot(all_freqs(~isnan(dspltranf(3,:))),nanmean(dspltranf(:,~isnan(dspltranf(3,:))),1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    plot(ax1,all_freqs,nanmean(dspltranf,1),...
        'marker','o','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'color',[0 1/length(all_dsplcmnts) 0]*d_ind);

    set(ax1,'xscale','log');
    set(ax2,'xscale','log');
    
    ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
end
for d_ind = 1:length(all_dsplcmnts)
    set(pnl(1,d_ind).axis,'ylim',ylims);
    set(pnl(2,d_ind).axis,'ylim',[0 1.1]);
    set(pnl(1,d_ind).axis,'xlim',[10 1000]);
    set(pnl(2,d_ind).axis,'xlim',[10 1000]);
    pnl(1,d_ind).title([num2str(all_dsplcmnts(d_ind)) ' V'])
end

% phases (all the same?)
pnl(3).pack('h',length(all_dsplcmnts));
ylims = [0 -Inf];
for d_ind = 1:length(all_dsplcmnts)
    dsplphase = nan(length(transfer),length(all_freqs));
    ax = pnl(3,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(transfer)
        dspl = dsplcmnts{c_ind};
        [~,d_i] = min(abs(dspl - all_dsplcmnts(d_ind)));
        if isempty(d_i)
            continue
        end
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
        dsplphase(c_ind,af_i) = angle(transfer{c_ind}(:,d_i))';
        
        
    end
    for row_ind = 1:size(dsplphase,1);
        dsplphase(row_ind,:) = unwrap(dsplphase(row_ind,:));
    end
    %dsplphase = dsplphase/(2*pi)*360;
    plot(all_freqs,dsplphase,...
        'parent',ax,'linestyle','-','color',0*[.85 .85 .85],...
        'marker','.','markerfacecolor',0*[.85 .85 .85],'markeredgecolor',0*[.85 .85 .85],...
        'tag',sprintf('%.2f',dsplcmnts{c_ind}(d_ind)))
    plot(all_freqs,nanmean(dsplphase,1),...
        'parent',ax,'linestyle','none','color',[.85 .85 .85],...
        'marker','o','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind)

    set(ax,'xscale','log');
    ylims = [min(ylims(1),min(dsplphase(:))) max(ylims(2),max(dsplphase(:)))];
end
rotUp = ceil(ylims(2)/pi);
rotDn = floor(ylims(1)/pi);
tx = rotDn:rotUp; for txi = 1:length(tx);txc{txi} = [num2str(tx(txi)) '\pi']; end
for d_ind = 1:length(all_dsplcmnts)
    set(pnl(3,d_ind).select(),'YTick',[rotDn*pi:pi:rotUp*pi])    
    set(pnl(3,d_ind).select(),'yticklabel',txc);
end

pnl(1,1).ylabel('|F(f)| (mV)'),pnl(3,1).xlabel('f (Hz)')
pnl(2,1).ylabel('normalized'),pnl(3,2).xlabel('f (Hz)')
pnl(3,1).ylabel('phase'),pnl(3,3).xlabel('f (Hz)')
fn = fullfile(savedir,[id 'PiezoSineDepolRespVsFreq.pdf']);
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1.4');
saveas(f, regexprep(fn,'.pdf',''), 'fig')

for d_ind = 1:length(all_dsplcmnts)
    set(pnl(3,d_ind).select(),'YTick',[rotDn*pi:pi:rotUp*pi])    
    set(pnl(3,d_ind).select(),'yticklabel',txc);
end


% Compare CurrentStepFam and CurrentChirp
close all
c_indv = [];
for c_ind = 1:length(analysis_cell)
    if ~isempty(analysis_cell(c_ind).CurrentChirpTrial) || ~isempty(analysis_cell(c_ind).CurrentStepTrial)
        c_indv(end+1) = c_ind;
    end
end

if ~isempty(c_indv)
f = figure;
set(f,'position',[482     9   854   988],'color',[1 1 1])
pnl = panel(f);
pnl.pack(length(c_indv),3)  % response panel, stimulus panel
pnl.margin = [20 20 10 10];
pnl.de.margin = [10 10 10 10];
pnl.de.fontsize = 7;

for c_ind = 1:length(c_indv) 
    if ~isempty(analysis_cell(c_indv(c_ind)).CurrentStepTrial)
        trial = load(analysis_cell(c_indv(c_ind)).CurrentStepTrial);
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        prtclData = load(dfile);
        obj.prtclData = prtclData.data;
        obj.prtclTrialNums = obj.currentTrialNum;
                        
        PF_CurrentStepFam(pnl(c_ind,1).select(),obj,'');
        pnl(c_ind,1).ylabel('mV');

        PF_CurrentStepIV(pnl(c_ind,2).select(),obj,'');
        pnl(c_ind,2).title(regexprep(analysis_cell(c_indv(c_ind)).name,'_','\\_'));
        pnl(c_ind,2).ylabel('mV');
    end
    drawnow
    if ~isempty(analysis_cell(c_indv(c_ind)).CurrentChirpTrial)
        trial = load(analysis_cell(c_indv(c_ind)).CurrentChirpTrial);
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        prtclData = load(dfile);
        obj.prtclData = prtclData.data;
        obj.prtclTrialNums = obj.currentTrialNum;
                        
        pnl(c_ind,3).pack('v',{2/3 1/3});
        pnl(c_ind,3).de.margin = [10 2 10 2];

        PF_CurrentChirpZAPFam([pnl(c_ind,3,1).select(),pnl(c_ind,3,2).select()],obj,'');
        set(pnl(c_ind,3,1).select(),'XTick',[]);
        pnl(c_ind,3,1).ylabel('|Z(f)| (mV/pA)');
        pnl(c_ind,3,2).ylabel('\phi');
    end
    drawnow
end

pnl(c_ind,1).xlabel('s');
pnl(c_ind,2).xlabel('pA');
try pnl(c_ind,3,2).xlabel('(Hz)');
catch
    pnl(c_ind-1,3,2).xlabel('(Hz)');
end

    fn = fullfile(savedir,[id '_IntrinsicProperties.pdf']);
    pnl.fontname = 'Arial';
    figure(f)
    eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
    
    %pnl.export(fn, '-rp','-a1.4');
    %saveas(f, regexprep(fn,'.pdf',''), 'fig')
end

% %% Plot f2/f2 ratio for PiezoSine
% 
% close all
% c_indv = [];
% for c_ind = 1:length(analysis_cell)
%     if ~isempty(analysis_cell(c_ind).PiezoSineTrial)
%         c_indv(end+1) = c_ind;
%     end
% end
% 
% f = figure;
% set(f,'position',[517 9   968   988],'color',[1 1 1])
% pnl = panel(f);
% pnl.pack(ceil(length(c_indv)/3),3)
% pnl.margin = [20 20 10 10];
% %pnl(1).marginbottom = 2;
% %pnl(2).marginbottom = 2;
% 
% cnt = 0;
% for c_ind = 1:length(c_indv)
%     cnt = cnt+1;
%     x = ceil(cnt/3);
%     y = mod(cnt,3); if y ==0,y=3;end
%     pnl(x,y).pack('v',{1/3 1/3 1/3})
%     pnl(x,y).de.marginbottom = 2;
%     pnl(x,y).de.margintop = 2;
%     axF1 = pnl(x,y,1).select(); hold on
%     axF2 = pnl(x,y,2).select(); hold on
%     axRa = pnl(x,y,3).select(); hold on
%     set([axF1,axF2],'xtick',[],'xcolor',[1 1 1]);
%     set([axF1,axF2,axRa],'xscale','log');
%     pnl(x,y,1).title(regexprep(analysis_cell(c_indv(c_ind)).name,'_','\\_'));
%     drawnow
%     
%     trial = load(analysis_cell(c_indv(c_ind)).PiezoSineTrial);
%     obj.trial = trial;
%     
%     [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
%         extractRawIdentifiers(trial.name);
%     
%     prtclData = load(dfile);
%     obj.prtclData = prtclData.data;
%     obj.prtclTrialNums = obj.currentTrialNum;
%         
%     % hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
%     [Ratio,F1,F2,freqs,displ] = PF_PiezoSineF2_2_F1([],obj,'','plot',0);
%     
%     for d_ind = 1:length(displ)
%         plot(axF1,freqs,F1(:,d_ind),...
%             'color',[0 d_ind/length(displ) 0],...
%             'displayname',[num2str(displ(d_ind)) 'V']);
%         plot(axF2,freqs,F2(:,d_ind),...
%             'color',[0 d_ind/length(displ) 0],...
%             'displayname',[num2str(displ(d_ind)) 'V']);
%         plot(axRa,freqs,Ratio(:,d_ind),...
%             'linestyle','none',...
%             'marker','o',...
%             'markersize',1.5,...
%             'markerfacecolor',[0 d_ind/length(displ) 0],...
%             'markeredgecolor',[0 d_ind/length(displ) 0],...
%             'displayname',[num2str(displ(d_ind)) 'V']);
%     end
%     set([axF1,axF2,axRa],'xlim',[10 1000]);
%     drawnow
% end
% 
% 
% 
% if save_log
%     fn = fullfile(savedir,[id 'F1vsF2components.pdf']);
%     pnl.fontname = 'Arial';
%     pnl.fontsize = 7;
%     figure(f)
%     eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);
% end
% 
% %% Others
% % %% Resting membrane potential
% % close all
% % vm_rest = nan(size(analysis_cell));
% % for c_ind = 1:length(analysis_cell)
% %     if isempty(analysis_cell(c_ind).baselinetrial{1}), continue,end
% %     trial = load(analysis_cell(c_ind).baselinetrial{1});
% %     obj.trial = trial;
% %     
% %     [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %         extractRawIdentifiers(trial.name);
% %     
% %     t = makeInTime(obj.trial.params);
% %     if t(1)<0;
% %         vm_rest(c_ind) = mean(obj.trial.voltage(t<0));
% %     else
% %         vm_rest(c_ind) = mean(obj.trial.voltage(t<1));
% %     end
% % end
% % f = figure;
% % pnl = panel(f);
% % pnl.pack(1)  % response panel, stimulus panel
% % pnl.margin = [16 12 2 12];
% % ax = pnl(1).select(); hold(ax,'on')
% % colors = get(ax,'colorOrder');
% % colors = [colors; (2/3)*colors];
% % 
% % for c_ind = 1:length(analysis_cell)
% %     plot(c_ind,vm_rest(c_ind),...
% %         'parent',ax,'linestyle','none','color',colors(c_ind,:),...
% %         'marker','o','markerfacecolor',colors(c_ind,:),...
% %         'markeredgecolor',colors(c_ind,:))
% % end
% % set(ax,'ylim',[ -60 -22])
% % pnl(1).ylabel('Resting V_m (mV)')
% % 
% % fn = fullfile(savedir,'LF_Vm_rest.pdf');
% % pnl.fontname = 'Arial';
% % pnl.export(fn, '-rp','-l','-a1');
% % saveas(f, regexprep(fn,'.pdf',''), 'fig')
% % 
% % %% Spontaneous oscillations
% % 
% % close all
% % 
% % fig = figure;
% % pnl = panel(fig);
% % pnl.pack('v',{1/3 2/3})  % response panel, stimulus panel
% % pnl.margin = [16 12 2 10];
% % ax = pnl(1).select(); hold(ax,'on');
% % 
% % colors = get(ax,'colorOrder');
% % colors = [colors; (2/3)*colors];
% % 
% % % plot the FFT of spontaneous oscilations
% % % get the peak
% % peak = nan(size(analysis_cell));
% % spontFreq = peak;
% % 
% % for c_ind = 1:length(analysis_cell)
% %     if isempty(analysis_cell(c_ind).baselinetrial{1}), continue,end
% %     trial = load(analysis_cell(c_ind).baselinetrial{1});
% %     obj.trial = trial;
% %     
% %     [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %         extractRawIdentifiers(trial.name);
% %     
% %     t = makeInTime(obj.trial.params);
% %     if ~isempty(strfind(obj.currentPrtcl,'Sweep'))
% %         t_ind = ~isnan(t);
% %     elseif ~isempty(strfind(obj.currentPrtcl,'PiezoChirp'))
% %         t_ind = t>(t(end)-3);
% %     else
% %         t_ind = t>(t(end)-trial.params.postDurInSec);
% %     end
% %     x = t(t_ind);
% %     y = obj.trial.voltage(t_ind);
% %     
% %     % section for averaging
% %     dT = .5;
% %     dX = sum(x<x(1)+dT);
% %     x_mat = reshape(x,dX,[]);
% %     y_mat = reshape(y,dX,[]);
% %     
% %     f_ = trial.params.sampratein/dX*[0:dX/2]; f_ = [f_, fliplr(f_(2:end-1))];
% % 
% %     Y_mat = fft(y_mat,[],1);    
% %     Y_mat = real(conj(Y_mat).*Y_mat);
% %     %figure; loglog(f,Y_mat), pause, close(gcf);
% % 
% %     mean_Y_mat = mean(Y_mat,2);
% %     ax = pnl(1).select(); hold(ax,'on');
% %     plot(f_,mean_Y_mat,...
% %         'parent',ax,'linestyle','-','color',colors(c_ind,:),...
% %         'marker','none','markerfacecolor',colors(c_ind,:),...
% %         'markeredgecolor',colors(c_ind,:))
% %     
% %     [peak(c_ind),f_ind] = max(mean_Y_mat(f_>10&f_<1000));
% %     spontFreq(c_ind) = f_(f_ind+(sum(f_<=10)+1)/2);
% %     
% %     plot(spontFreq(c_ind),peak(c_ind),...
% %         'parent',ax,'linestyle','none','color',colors(c_ind,:),...
% %         'marker','o','markerfacecolor','none',...
% %         'markeredgecolor',colors(c_ind,:))
% % end
% % 
% % set(ax,'xscale','log','yscale','log')
% % set(ax,'xlim',[10 1000])
% % pnl(1).ylabel('Power (mV^2/Hz^2)')
% % pnl(1).xlabel('Frequency (Hz)')
% % 
% % %% Plot the spontaneous oscillations versus the peak freqency sensitivity
% % 
% % clear transfer freqs dsplcmnts 
% % selectFreq = nan(size(spontFreq));
% % log_switch = nan(size(spontFreq));
% % for c_ind = 1:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('PiezoChirpZAP',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% %             [~,~,transfer,f_sampled] = PiezoChirpZAP([],obj,'','plot',0);
% %             [trpk,f_ind] = max(transfer(f_sampled > 25 ... %min(trial.params.freqStart,trial.params.freqEnd) ...
% %                                     & f_sampled < max(trial.params.freqStart,trial.params.freqEnd)));
% %             selectFreq(c_ind) = f_sampled(f_ind+sum(f_sampled <= 25));
% %             log_switch(c_ind) = 1;
% %             break
% % 
% %         elseif ~isempty(strfind('PiezoSineOsciRespVsFreq',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% %             
% %             [transfer,freqs,dsplcmnts] = PiezoSineOsciRespVsFreq([],obj,'','plot',0);
% %             tr = real(abs(transfer));
% %             [trpk,inds] = max(tr,[],1);
% %             
% %             selectFreq(c_ind) = mean(freqs(inds));
% %             log_switch(c_ind) = 0;
% %         end
% %     end
% % end
% % log_switch(isnan(log_switch)) = 0;
% % ax = pnl(2).select(); hold(ax,'on');
% % 
% % colors = get(ax,'colorOrder');
% % colors = [colors; (2/3)*colors];
% % for c_ind = 1:length(analysis_cell)
% %     l = plot(spontFreq(c_ind), selectFreq(c_ind),'parent',ax, ...
% %         'linestyle','none','color',[0 0 0],...
% %         'marker','o','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0]);
% %     if log_switch(c_ind)
% %     set(l,...
% %         'markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85])
% %     
% %     end
% % end
% % set(ax,'xscale','log','yscale','log')
% % set(ax,'xlim',[10 1000],'ylim',[10 300])
% % l_chirp = findobj(ax,'markerfacecolor',[.85 .85 .85]);
% % l_sine = findobj(ax,'markerfacecolor',[0 0 0]);
% % if ~isempty(l_chirp) && ~ isempty(l_sine)
% %     legend([l_chirp(1),l_sine(1)],{'chirp','sine'});
% % elseif ~isempty(l_chirp)
% %     legend(l_chirp(1),{'chirp'});
% % elseif ~isempty(l_sine)
% %     legend(l_sine(1),{'sine'});
% % end
% % pnl(2).ylabel('Preferred Freq (Hz)')
% % pnl(2).xlabel('Spontaneous Freq (Hz)')
% % 
% % figure(fig)
% % fn = fullfile(savedir,'LF_SelectivityVsSpontaneous.pdf');
% % pnl.fontname = 'Arial';
% % pnl.export(fn, '-rp','-l','-a1');
% 
% 
% % 
% % %% Exporting PiezoSineMatrix info on cells 
% % close all
% % for c_ind = 4%:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('PiezoSineMatrix',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% %             
% %             
% %             f = PiezoSineMatrix([],obj,'');
% %             if save
% %             p = panel.recover(f);
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             fn = fullfile(genotypedir,['BPS_', ... 
% %                 dateID '_', ...
% %                 flynum '_', ... 
% %                 cellnum '_', ... 
% %                 num2str(obj.trial.params.trialBlock) '_',...
% %                 'PiezoSineMatrix', ...
% %                 '.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-l');
% % 
% %             f2 = findobj(0,'tag','PiezoSineMatrixStimuli');
% %             f2 = f2(1);
% %             p = panel.recover(f2);
% %             p.fontname = 'Arial';
% %             fn = regexprep(fn,'PiezoSineMatrix','PiezoSineMat_Stim');
% %             p.export(fn, '-rp','-l');
% %             end
% %         end
% %     end
% % end
% % 
% % %% Exporting PiezoSineOsciRespVsFreq info on cells with X-functions
% % close all
% % clear transfer freqs dsplcmnts        
% % cnt = 0;
% % for c_ind = 1:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('PiezoSineOsciRespVsFreq',obj.currentPrtcl))
% %             cnt = cnt+1;
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             if exist('f','var') && ishandle(f), close(f),end
% %             
% %             hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
% %             [transfer{cnt},freqs{cnt},dsplcmnts{cnt}] = PiezoSineOsciRespVsFreq([],obj,'');
% %             f = findobj(0,'tag','PiezoSineOsciRespVsFreq');
% %             if save
% %             p = panel.recover(f);
% %             fn = fullfile(genotypedir,['BP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'PiezoSineOsciRespVsFreq.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-l','-a1.4');
% %             end
% %         end
% %     end
% % end
% % 
% % % Count the number of displacements, etc
% % all_dsplcmnts = [];
% % for d_ind = 1:length(dsplcmnts) 
% %     all_dsplcmnts = [all_dsplcmnts,dsplcmnts{d_ind}];
% % end
% % all_dsplcmnts = sort(unique(all_dsplcmnts));
% % 
% % all_freqs = [];
% % for d_ind = 1:length(freqs) 
% %     all_freqs = [all_freqs,round(freqs{d_ind}*100)/100];
% % end
% % all_freqs = sort(unique(all_freqs));
% % 
% % % Plotting transfer from all cells
% % f = figure;
% % pnl = panel(f);
% % pnl.pack('v',{2/3  1/3})  % response panel, stimulus panel
% % pnl.margin = [13 10 2 10];
% % pnl(1).marginbottom = 2;
% % pnl(2).marginleft = 12;
% % 
% % pnl(1).pack('h',length(all_dsplcmnts));
% % 
% % ylims = [0 -Inf];
% % for d_ind = 1:length(all_dsplcmnts)
% %     dspltranf = nan(length(transfer),length(all_freqs));
% %     ax = pnl(1,d_ind).select(); hold(ax,'on')
% %     for c_ind = 1:length(transfer)
% %         dspl = dsplcmnts{c_ind};
% %         d_i = find(round(dspl*10)/10 == all_dsplcmnts(d_ind));
% %         [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
% %         dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(:,d_i)))';
% %         
% %         plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i))),...
% %             'parent',ax,'linestyle','-','color',[.85 .85 .85],...
% %             'marker','.','markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85],...
% %             'tag',sprintf('%.2f',dsplcmnts{c_ind}(d_ind)))
% %     end
% %     plot(all_freqs(~isnan(dspltranf(2,:))),nanmean(dspltranf(:,~isnan(dspltranf(2,:))),1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
% %     % plot(all_freqs,nanmean(dspltranf,1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
% %     
% %     set(ax,'xscale','log');
% %     
% %     ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
% % end
% % for d_ind = 1:length(all_dsplcmnts)
% %     set(pnl(1,d_ind).axis,'ylim',ylims);
% % end
% % 
% % %phases (all the same?)
% % pnl(2).pack('h',length(all_dsplcmnts));
% % for d_ind = 1:length(all_dsplcmnts)
% %     dsplphase = nan(length(transfer),length(all_freqs));
% %     ax = pnl(2,d_ind).select(); hold(ax,'on')
% %     for c_ind = 1:length(transfer)
% %         
% %         dspl = dsplcmnts{c_ind};
% %         d_i = find(round(dspl*10)/10 == all_dsplcmnts(d_ind));
% %         [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
% %         dsplphase(c_ind,af_i) = angle(transfer{c_ind}(:,d_i))';
% %         
% %         % for col_ind = 1:size(dsplphase,2);
% %             %         dsplphase(:,col_ind) = clusterPhases(dsplphase(:,col_ind));
% %         % end
% %         plot(freqs{c_ind},dsplphase(c_ind,af_i),...
% %         'parent',ax,'linestyle','-','color',[.85 .85 .85],...
% %         'marker','.','markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85],...
% %         'tag',sprintf('%.2f',dsplcmnts{c_ind}(d_ind)))
% %     end
% %     %dsplphase = dsplphase/(2*pi)*360;
% %     plot(all_freqs,nanmean(dsplphase,1),...
% %         'parent',ax,'linestyle','none','color',[.85 .85 .85],...
% %         'marker','.','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
% %         'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind)
% % 
% %     set(ax,'xscale','log');
% %     set(ax,'yticklabel',{'-\pi','0','\pi'});
% %     set(ax,'YTick',[-pi,0, pi])
% % end
% % fn = fullfile(savedir,'BPS_PiezoSineOsciRespVsFreq.pdf');
% % pnl.fontname = 'Arial';
% % pnl.export(fn, '-rp','-l','-a1.4');
% % saveas(f, regexprep(fn,'.pdf',''), 'fig')
% % 
% % for d_ind = 1:length(all_dsplcmnts)
% %      set(pnl(2,d_ind).select(),'YTick',[-pi,0, pi])
% % end
% % 
% % %% Exporting PiezoStepMatrix info on cells 
% % close all
% % for c_ind = 9:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('PiezoStepMatrix',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             f = PiezoStepMatrix([],obj,'');
% %             if save
% %             p = panel.recover(f);
% %             fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'PiezoStepMatrix.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-a1');
% %             
% %             f2 = findobj(0,'tag','PiezoStepMatrixStimuli');
% %             f2 = f2(1);
% %             p = panel.recover(f2);
% %             p.fontname = 'Arial';
% %             fn = regexprep(fn,'PiezoStepMatrix','PiezoStepMat_Stim');
% %             p.export(fn, '-rp','-l');
% % 
% %             end
% %         end
% %     end
% % end
% % 
% % %% Exporting PiezChirpMatrix info on cells
% % close all
% % for c_ind = 9:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('PiezoChirpMatrix',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             f = PiezoChirpMatrix([],obj,'');
% %             if save
% %             p = panel.recover(f);
% %             fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'PiezoChirpMatrix.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-a1');
% %             
% %             f2 = findobj(0,'tag','PiezoChirpMatrixStimuli');
% %             f2 = f2(1);
% %             p = panel.recover(f2);
% %             p.fontname = 'Arial';
% %             fn = regexprep(fn,'PiezoChirpMatrix','PiezoChirpMat_Stim');
% %             p.export(fn, '-rp','-l');
% % 
% %             end
% %         end
% %     end
% % end
% % 
% % %% Exporting PiezoChirpZAP info on cells 
% % close all
% % for c_ind = 9:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('PiezoChirpZAP',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             if exist('f','var') && ishandle(f), close(f),end
% %             PiezoChirpZAP([],obj,'');
% %             f = findobj(0,'tag','PiezoChirpZAP');
% %             if save
% %             p = panel.recover(f);
% %             fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'PiezoChirpZAP.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-l','-a1.4');
% %             end
% %         end
% %     end
% % end
% % 
% % %% Exporting CurrentStepFamMatrix info on cells
% % close all
% % for c_ind = 9:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('CurrentStepFamMatrix',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             f = CurrentStepFamMatrix([],obj,'');
% %             if save
% %             p = panel.recover(f);
% %             fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'CurrentStepFamMatrix.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-a1');
% %             end
% %         end
% %     end
% % end
% % 
% % %% Exporting CurrentChirpMatrix info on cells 
% % close all
% % for c_ind = 9:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('CurrentChirpMatrix',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             f = CurrentChirpMatrix([],obj,'');
% %             if save
% %             p = panel.recover(f);
% %             fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'CurrentChirpMatrix.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-a1');
% %             
% %             f2 = findobj(0,'tag','CurrentChirpMatrixStimuli');
% %             f2 = f2(1);
% %             p = panel.recover(f2);
% %             p.fontname = 'Arial';
% %             fn = regexprep(fn,'CurrentChirpMatrix','CurrentChirpMat_stim');
% %             p.export(fn, '-rp','-l');
% % 
% %             end
% %         end
% %     end
% % end
% % 
% % %% Exporting CurrentChirpZAP info on cells
% % close all
% % for c_ind = 9:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('CurrentChirpZAP',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             if exist('f','var') && ishandle(f), close(f),end
% %             CurrentChirpZAP([],obj,'');
% %             f = findobj(0,'tag','CurrentChirpZAP');
% %             if save
% %             p = panel.recover(f);
% %             fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'CurrentChirpZAP.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-l','-a1.4');
% %             end
% %         end
% %     end
% % end
% % 
% % %% Exporting CurrentSineMatrix info on cells
% % close all
% % for c_ind = 9:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('CurrentSineMatrix',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             f = CurrentSineMatrix([],obj,'');
% %             if save
% %             p = panel.recover(f(1));
% %             fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'CurrentSineMatrix.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-a1');
% %             end
% %         end
% %     end
% % end
% % 
% % %% Exporting CurrentSineVvsFreq info on cells 
% % close all
% % for c_ind = 9:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('CurrentSineVvsFreq',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% % 
% %             genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% %             if ~isdir(genotypedir), mkdir(genotypedir); end
% % 
% %             if exist('f','var') && ishandle(f), close(f),end
% %             
% %             CurrentSineVvsFreq([],obj,'');
% %             f = findobj(0,'tag','CurrentSineVvsFreq');
% % 
% %             if save
% %             p = panel.recover(f);
% %             fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
% %                 'CurrentSineVvsFreq.pdf']);
% %             p.fontname = 'Arial';
% %             p.export(fn, '-rp','-a1');
% %             end
% %         end
% %     end
% % end
% % 
% % %% Plot f2/f2 ratio for PiezoSine
% % 
% % %% Resting membrane potential
% % close all
% % vm_rest = nan(size(analysis_cell));
% % for c_ind = 1:length(analysis_cell)
% %     if isempty(analysis_cell(c_ind).baselinetrial{1}), continue,end
% %     trial = load(analysis_cell(c_ind).baselinetrial{1});
% %     obj.trial = trial;
% %     
% %     [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %         extractRawIdentifiers(trial.name);
% %     
% %     t = makeInTime(obj.trial.params);
% %     if t(1)<0;
% %         vm_rest(c_ind) = mean(obj.trial.voltage(t<0));
% %     else
% %         vm_rest(c_ind) = mean(obj.trial.voltage(t<1));
% %     end
% % end
% % f = figure;
% % pnl = panel(f);
% % pnl.pack(1)  % response panel, stimulus panel
% % pnl.margin = [16 12 2 12];
% % ax = pnl(1).select(); hold(ax,'on')
% % colors = get(ax,'colorOrder');
% % colors = [colors; (2/3)*colors];
% % 
% % for c_ind = 1:length(analysis_cell)
% %     plot(c_ind,vm_rest(c_ind),...
% %         'parent',ax,'linestyle','none','color',colors(c_ind,:),...
% %         'marker','.','markerfacecolor',colors(c_ind,:),...
% %         'markeredgecolor',colors(c_ind,:))
% % end
% % set(ax,'ylim',[ -60 -22])
% % pnl(1).ylabel('Resting V_m (mV)')
% % 
% % fn = fullfile(savedir,'BPS_Vm_rest.pdf');
% % pnl.fontname = 'Arial';
% % pnl.export(fn, '-rp','-l','-a1');
% % saveas(f, regexprep(fn,'.pdf',''), 'fig')
% % 
% % %% Spontaneous oscillations
% % 
% % close all
% % 
% % fig = figure;
% % pnl = panel(fig);
% % pnl.pack('v',{1/3 2/3})  % response panel, stimulus panel
% % pnl.margin = [16 12 2 10];
% % ax = pnl(1).select(); hold(ax,'on');
% % 
% % colors = get(ax,'colorOrder');
% % colors = [colors; (2/3)*colors];
% % 
% % % plot the FFT of spontaneous oscilations
% % % get the peak
% % peak = nan(size(analysis_cell));
% % spontFreq = peak;
% % 
% % for c_ind = 1:length(analysis_cell)
% %     if isempty(analysis_cell(c_ind).baselinetrial{1}), continue,end
% %     trial = load(analysis_cell(c_ind).baselinetrial{1});
% %     obj.trial = trial;
% %     
% %     [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %         extractRawIdentifiers(trial.name);
% %     
% %     t = makeInTime(obj.trial.params);
% %     if ~isempty(strfind(obj.currentPrtcl,'Sweep'))
% %         t_ind = ~isnan(t);
% %     elseif ~isempty(strfind(obj.currentPrtcl,'PiezoChirp'))
% %         t_ind = t>(t(end)-3);
% %     else
% %         t_ind = t>(t(end)-trial.params.postDurInSec);
% %     end
% %     x = t(t_ind);
% %     y = obj.trial.voltage(t_ind);
% %     
% %     % section for averaging
% %     dT = .5;
% %     dX = sum(x<x(1)+dT);
% %     x_mat = reshape(x,dX,[]);
% %     y_mat = reshape(y,dX,[]);
% %     
% %     f_ = trial.params.sampratein/dX*[0:dX/2]; f_ = [f_, fliplr(f_(2:end-1))];
% % 
% %     Y_mat = fft(y_mat,[],1);    
% %     Y_mat = real(conj(Y_mat).*Y_mat);
% %     %figure; loglog(f,Y_mat), pause, close(gcf);
% % 
% %     mean_Y_mat = mean(Y_mat,2);
% %     ax = pnl(1).select(); hold(ax,'on');
% %     plot(f_,mean_Y_mat,...
% %         'parent',ax,'linestyle','-','color',colors(c_ind,:),...
% %         'marker','none','markerfacecolor',colors(c_ind,:),...
% %         'markeredgecolor',colors(c_ind,:))
% %     
% %     [peak(c_ind),f_ind] = max(mean_Y_mat(f_>10&f_<1000));
% %     spontFreq(c_ind) = f_(f_ind+(sum(f_<=10)+1)/2);
% %     
% %     plot(spontFreq(c_ind),peak(c_ind),...
% %         'parent',ax,'linestyle','none','color',colors(c_ind,:),...
% %         'marker','o','markerfacecolor','none',...
% %         'markeredgecolor',colors(c_ind,:))
% % end
% % 
% % set(ax,'xscale','log','yscale','log')
% % set(ax,'xlim',[10 1000])
% % pnl(1).ylabel('Power (mV^2/Hz^2)')
% % pnl(1).xlabel('Frequency (Hz)')
% % 
% % %% Plot the spontaneous oscillations versus the peak freqency sensitivity
% % 
% % clear transfer freqs dsplcmnts 
% % selectFreq = nan(size(spontFreq));
% % log_switch = nan(size(spontFreq));
% % for c_ind = 1:length(analysis_cell)
% %     for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
% %         trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% %         obj.trial = trial;
% %         
% %         [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
% %             extractRawIdentifiers(trial.name);
% %         
% %         if ~isempty(strfind('PiezoChirpZAP',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% %             [~,~,transfer,f_sampled] = PiezoChirpZAP([],obj,'','plot',0);
% %             [trpk,f_ind] = max(transfer(f_sampled > 25 ... %min(trial.params.freqStart,trial.params.freqEnd) ...
% %                                     & f_sampled < max(trial.params.freqStart,trial.params.freqEnd)));
% %             selectFreq(c_ind) = f_sampled(f_ind+sum(f_sampled <= 25));
% %             log_switch(c_ind) = 1;
% %             break
% % 
% %         elseif ~isempty(strfind('PiezoSineOsciRespVsFreq',obj.currentPrtcl))
% %             prtclData = load(dfile);
% %             obj.prtclData = prtclData.data;
% %             obj.prtclTrialNums = obj.currentTrialNum;
% %             
% %             [transfer,freqs,dsplcmnts] = PiezoSineOsciRespVsFreq([],obj,'','plot',0);
% %             tr = real(abs(transfer));
% %             [trpk,inds] = max(tr,[],1);
% %             
% %             selectFreq(c_ind) = mean(freqs(inds));
% %             log_switch(c_ind) = 0;
% %         end
% %     end
% % end
% % log_switch(isnan(log_switch)) = 0;
% % ax = pnl(2).select(); hold(ax,'on');
% % 
% % colors = get(ax,'colorOrder');
% % colors = [colors; (2/3)*colors];
% % for c_ind = 1:length(analysis_cell)
% %     l = plot(spontFreq(c_ind), selectFreq(c_ind),'parent',ax, ...
% %         'linestyle','none','color',[0 0 0],...
% %         'marker','o','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0]);
% %     if log_switch(c_ind)
% %     set(l,...
% %         'markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85])
% %     
% %     end
% % end
% % set(ax,'xscale','log','yscale','log')
% % set(ax,'xlim',[10 1000],'ylim',[10 300])
% % l_chirp = findobj(ax,'markerfacecolor',[.85 .85 .85]);
% % l_sine = findobj(ax,'markerfacecolor',[0 0 0]);
% % 
% % legend([l_chirp(1),l_sine(1)],{'chirp','sine'});
% % pnl(2).ylabel('Preferred Freq (Hz)')
% % pnl(2).xlabel('Spontaneous Freq (Hz)')
% % 
% % figure(fig)
% % fn = fullfile(savedir,'BPS_SelectivityVsSpontaneous.pdf');
% % pnl.fontname = 'Arial';
% % pnl.export(fn, '-rp','-l','-a1');
% % 

