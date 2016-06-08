%% Record_Figure2 - take from the different types and agreggate here
close all

Scripts = {
    'Record_FS_HighFreqDepolB1s'
    'Record_FS_BandPassHiB1s'
    'Record_FS_BandPassLowB1s'
    'Record_FS_LowPassB1s'
    };

Cells = {

% A2

% BPH
%'131014_F3_C1'      % sine only

% BPM
'151205_F1_C1'      % sine only 
'151208_F1_C1'      % sine only
'151208_F2_C1'      % pulses! more so in (-) direction
'151209_F1_C3'      % pulses in (-) direction but not (+)
'151209_F2_C1'      % pulses in (+) direction but not (-)
'151209_F2_C2'      % sine only

% BPL
'151106_F1_C3'      % pulses
'151209_F1_C1'      % not clear
'151209_F1_C2'      % pulses
'151209_F2_C3'      % pulses, (+) asymmetric
'151211_F2_C1'      % size, asymetric 
'151211_F3_C1'      % pulses! 
}

% Script_FrequencySelectivity

% Plotting transfer from all cells at all displacements
fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[.2 .4 19, 11])

fig_S = figure;
fig_S.Units = 'inches';
set(fig_S,'color',[1 1 1],'position',[.2 .4 19, 11])

pnl = panel(fig);
pnl.margin = [16 10 4 4];
pnl.pack('v',length(Cells)+1)  

pnl_S = panel(fig_S);
pnl_S.margin = [16 10 4 4];
pnl_S.pack('v',length(Cells)+1)  


ac = Cells{1};
for s = 1:length(Scripts)
    eval(Scripts{s});
    if ~isempty(find(strcmp(analysis_cells,ac)))
        ac = analysis_cell(find(strcmp(analysis_cells,ac)));
        break
    end
end

trial = load(ac.PiezoLongCourtshipSong);

%pnl(length(Cells)+1).pack('v',2);

plot(makeInTime(trial.params),trial.sgsmonitor,'b','parent',pnl(length(Cells)+1).select());
set(pnl(length(Cells)+1).select(),'xcolor',[1 1 1],'xtick',[])
axis(pnl(length(Cells)+1).select(),'tight');

f = df:df:600;

[S,F,T,P] = spectrogram(trial.sgsmonitor-mean(trial.sgsmonitor),2048,1024,f,trial.params.sampratein);
h = pcolor(pnl_S(length(Cells)+1).select(),T,F,abs(S));
set(h,'EdgeColor','none');

set(pnl_S(length(Cells)+1).select(),'ylim',[0 300])
drawnow


%%
for c_ind = 1:length(Cells)
    ac = Cells{c_ind};
    for s = 1:length(Scripts)
        eval(Scripts{s});
        if ~isempty(find(strcmp(analysis_cells,ac)))
            ac = analysis_cell(find(strcmp(analysis_cells,ac)));
            break
        end
    end
%     if ~isstruct(ac)
%         clear analysis_cell
%         analysis_cell.PiezoBWCourtshipSong = ...
%             'C:\Users\tony\Raw_Data\131014\131014_F3_C1\PiezoBWCourtshipSong_Raw_131014_F3_C1_1.mat';
%         analysis_cell.PiezoCourtshipSong = ...
%             'C:\Users\tony\Raw_Data\131014\131014_F3_C1\PiezoCourtshipSong_Raw_131014_F3_C1_1.mat';
%         analysis_cell.name = ac;
%         ac = analysis_cell;
%     end
    trial = load(ac.PiezoLongCourtshipSong);
    h = getShowFuncInputsFromTrial(trial);
    
    trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);
    y = zeros(length(trial.sgsmonitor),length(trials));
    for t_ind = 1:length(trials)
        trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(t_ind))));
        y(:,t_ind) = trial.voltage;
    end
        
    t = makeInTime(trial.params);
    y_ = mean(y,2);
    
    plot(makeInTime(trial.params),y_,'k','parent',pnl(c_ind).select(),'tag',ac.name);
    set(pnl(c_ind).select(),'xcolor',[1 1 1],'xtick',[])
    
    axis(pnl(c_ind).select(),'tight');
    
    df = 600/256;
    f = df:df:600;
    
    [S,F,T,P] = spectrogram(y_-mean(y_(t>.07)),2048,1024,f,trial.params.sampratein);
    h = pcolor(pnl_S(c_ind).select(),T,F,abs(S));
    set(h,'EdgeColor','none');

    set(pnl_S(c_ind).select(),'ylim',[0 300],'xcolor',[1 1 1],'xtick',[]);

    drawnow
end

%% Clean up
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure3/';
savePDF(fig,savedir,[],'FigureS3_CourtshipSongV')
savePDF(fig_S,savedir,[],'FigureS3_CourtshipSongSG')
