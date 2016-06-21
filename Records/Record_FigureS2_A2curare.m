%% Plot only relevant displacements 0.015 0.05 0.15 0.5 V
close all
% Plotting transfer from all cells at all displacements
fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 2 getpref('FigureSizes','NeuronTwoColumn'), getpref('FigureSizes','NeuronOneColumn')])

pnl = panel(fig);
pnl.margin = [16 16 10 10];

trials = {
'C:\Users\tony\Raw_Data\151030\151030_F1_C1\PiezoSine_Raw_151030_F1_C1_31.mat', 'C:\Users\tony\Raw_Data\151030\151030_F1_C1\PiezoSine_Raw_151030_F1_C1_427.mat';
'C:\Users\tony\Raw_Data\151215\151215_F3_C1\PiezoSine_Raw_151215_F3_C1_219.mat', 'C:\Users\tony\Raw_Data\151215\151215_F3_C1\PiezoSine_Raw_151215_F3_C1_360.mat';
'C:\Users\tony\Raw_Data\151216\151216_F2_C3\PiezoStep_Raw_151216_F2_C3_1.mat', 'C:\Users\tony\Raw_Data\151216\151216_F2_C3\PiezoStep_Raw_151216_F2_C3_73.mat';
'C:\Users\tony\Raw_Data\151216\151216_F3_C2\PiezoSine_Raw_151216_F3_C2_31.mat', 'C:\Users\tony\Raw_Data\151216\151216_F3_C2\PiezoSine_Raw_151216_F3_C2_255.mat';
'C:\Users\tony\Raw_Data\151215\151215_F2_C1\PiezoSine_Raw_151215_F2_C1_31.mat', 'C:\Users\tony\Raw_Data\151215\151215_F2_C1\PiezoSine_Raw_151215_F2_C1_310.mat';
}
trials = trials';

%'C:\Users\tony\Raw_Data\151217\151217_F1_C3\PiezoSine_Raw_151217_F1_C3_7.mat';
%'C:\Users\tony\Raw_Data\151217\151217_F2_C1\PiezoSine_Raw_151217_F2_C1_7.mat';

pnl.pack('h',size(trials,2))  
pnl_hs = nan(3,size(trials,2));
for panl = 1:size(trials,2);
    pnl(panl).pack('v',{4/9 4/9 1/9});
    for dr_idx = 1:2
        pnl_hs(dr_idx,panl) = pnl(panl,dr_idx).select();
        
        trial = load(trials{dr_idx,panl});
        h = getShowFuncInputsFromTrial(trial);
        [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
        name = [dateID '_' flynum '_' cellnum '_' trialnum ': ' ];

        if strcmp(h.currentPrtcl,'PiezoSine');
            f = PF_PiezoSineAverage([],h,'');
            fax = findobj(f,'tag','response_ax');
            fl = findobj(fax,'type','line','color',[.7 0 0]);
            tl = copyobj(fl,pnl_hs(dr_idx,panl));
            set(tl,'color',[0 0 0]);
            title(pnl_hs(dr_idx,panl),[name num2str(trial.params.displacement) 'V ' num2str(floor(trial.params.freq)) 'Hz']);
            if strcmp(trial.params.mode,'VClamp')
                ylabel(pnl_hs(dr_idx,panl),'pA');
            else
                ylabel(pnl_hs(dr_idx,panl),'mV');
            end
            set(pnl_hs(dr_idx,panl),'xtick',[],'xcolor',[1 1 1]);
            
            if dr_idx==1
                x = makeInTime(h.trial.params);
                stim = PiezoSineStim(h.trial.params);
                sax = pnl(panl,3).select();
                plot(sax,x,stim,'b');
                pnl_hs(3,panl) = sax;
                set(pnl_hs(3,panl),'box','off')
            end
        end
        if strcmp(h.currentPrtcl,'PiezoStep');
            f = PF_PiezoStepAverage([],h,'');
            fax = findobj(f,'tag','response_ax');
            fl = findobj(fax,'type','line','color',[.7 0 0]);
            tl = copyobj(fl,pnl_hs(dr_idx,panl));
            set(tl,'color',[0 0 0]);
            title(pnl_hs(dr_idx,panl),[name num2str(trial.params.displacement) 'V ']);
            if strcmp(trial.params.mode,'VClamp')
                ylabel(pnl_hs(dr_idx,panl),'pA');
            else
                ylabel(pnl_hs(dr_idx,panl),'mV');
            end
            set(pnl_hs(dr_idx,panl),'xtick',[],'xcolor',[1 1 1]);

            if dr_idx==1
                x = makeInTime(h.trial.params);
                stim = PiezoStepStim(h.trial.params);
                sax = pnl(panl,3).select();
                plot(sax,x,stim,'b');
                pnl_hs(3,panl) = sax;
                set(pnl_hs(3,panl),'box','off')
                xlabel(pnl_hs(3,panl),'time (s)')
            end
        end
        close(f);
    end
    set(pnl_hs(:,panl),'xlim',[-.1 0.39]);
end

%% clean up
savedir = 'C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure5_Electical_chemical_synapses';
savePDF(fig,savedir,[],'Figure5_A2Curare')


