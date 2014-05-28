%% Record of Cell Attached Recordings:
% 17 B1 Cell attached recordings
% 3 Big Spikers
analysis_cells_cell = {
    '130925_F1_C1'  %?
    '130925_F2_C1'  %?
    '130925_F3_C1'  %?

    '131002_F1_C2'
    '131002_F1_C1'
    '131001_F1_C1'
    
    '131022_F1_C1' %- Big Spiker
    '131112_F1_C1' %- BS
    '131112_F1_C2'

    '131112_F3_C1' %- BS
    '131112_F3_C2' %-
    '131022_F4_C1' %-

    '131022_F2_C1' %-
    '131121_F1_C1'
    '131121_F1_C2'
 
    '131121_F1_C3'
    '131121_F1_C4'
    '131121_F1_C7'

    '131121_F1_C8'
    '131121_F2_C1'
    };

% Cell-attached recording of the rogue cell in VT30609 that is near the nerve:
analysis_cells_cell = {
    '130626_F1_C1' %- at least according to notes_
    '131121_F2_C5' %- spiker!  hmm 'C:\Users\Anthony Azevedo\Raw_Data\131121\131121_F2_C5\Sweep_Raw_131121_F2_C5_7.mat';
    '130729_F2_C1' % mystery spiker  
    };

% Cell-Attached GH298-Gal4
analysis_cells_cell = {
    '130930_F1_C1'
    '130930_F1_C2'
    '130625_F1_C1'
    };

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_CellAttachedB1';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

%%
trials = {
'C:\Users\Anthony Azevedo\Raw_Data\130930\130930_F1_C1\Sweep_Raw_130930_F1_C1_1.mat',... % GH298
'C:\Users\Anthony Azevedo\Raw_Data\130930\130930_F1_C2\Sweep_Raw_130930_F1_C2_4.mat',... % GH298
'C:\Users\Anthony Azevedo\Raw_Data\Archive\25-Jun-2013\25-Jun-2013_F1_C1\Sweep_Raw_25-Jun-2013_F1_C1_1.mat'; % GH298

'C:\Users\Anthony Azevedo\Raw_Data\130925\130925_F1_C1\Sweep_Raw_130925_F1_C1_5.mat',... % GH86
'C:\Users\Anthony Azevedo\Raw_Data\130925\130925_F2_C1\Sweep_Raw_130925_F2_C1_3.mat',... % GH86
'C:\Users\Anthony Azevedo\Raw_Data\130925\130925_F3_C1\Sweep_Raw_130925_F3_C1_4.mat'; % GH86

'C:\Users\Anthony Azevedo\Raw_Data\131002\131002_F1_C2\Sweep_Raw_131002_F1_C2_4.mat',... % GH86
'C:\Users\Anthony Azevedo\Raw_Data\131002\131002_F1_C1\Sweep_Raw_131002_F1_C1_6.mat',... % GH86
'C:\Users\Anthony Azevedo\Raw_Data\131001\131001_F1_C1\Sweep_Raw_131001_F1_C1_4.mat'; % GH86

'C:\Users\Anthony Azevedo\Raw_Data\131022\131022_F1_C1\Sweep_Raw_131022_F1_C1_2.mat',... % BS
'C:\Users\Anthony Azevedo\Raw_Data\131112\131112_F1_C1\Sweep_Raw_131112_F1_C1_3.mat',... % BS
'C:\Users\Anthony Azevedo\Raw_Data\131112\131112_F1_C2\Sweep_Raw_131112_F1_C2_3.mat'; % GH86

'C:\Users\Anthony Azevedo\Raw_Data\131112\131112_F3_C1\Sweep_Raw_131112_F3_C1_3.mat',... % BS
'C:\Users\Anthony Azevedo\Raw_Data\131112\131112_F3_C2\Sweep_Raw_131112_F3_C2_2.mat',... % GH86
'C:\Users\Anthony Azevedo\Raw_Data\131022\131022_F4_C1\Sweep_Raw_131022_F4_C1_1.mat'; % GH86

'C:\Users\Anthony Azevedo\Raw_Data\131022\131022_F2_C1\Sweep_Raw_131022_F2_C1_2.mat',...% GH86
'C:\Users\Anthony Azevedo\Raw_Data\131121\131121_F1_C1\Sweep_Raw_131121_F1_C1_1.mat',... % VT30609
'C:\Users\Anthony Azevedo\Raw_Data\131121\131121_F1_C2\Sweep_Raw_131121_F1_C2_1.mat'; % VT30609

'C:\Users\Anthony Azevedo\Raw_Data\131121\131121_F1_C3\Sweep_Raw_131121_F1_C3_2.mat',... % VT30609
'C:\Users\Anthony Azevedo\Raw_Data\131121\131121_F1_C4\Sweep_Raw_131121_F1_C4_3.mat',... % VT30609
'C:\Users\Anthony Azevedo\Raw_Data\131121\131121_F1_C7\Sweep_Raw_131121_F1_C7_1.mat'; % VT30609

'C:\Users\Anthony Azevedo\Raw_Data\131121\131121_F1_C8\Sweep_Raw_131121_F1_C8_1.mat',... % VT30609
'C:\Users\Anthony Azevedo\Raw_Data\131121\131121_F2_C5\Sweep_Raw_131121_F2_C5_5.mat',... % Rogue Cell % VT30609
'C:\Users\Anthony Azevedo\Raw_Data\130729\130729_F2_C1\Sweep_Raw_130729_F2_C1_1.mat'; % crazy weird cell % GH86
}

%%
f = figure;
set(f,'color',[1 1 1])
dim = size(trials);
p = panel(f);
p.pack(dim(1),dim(2));
p.margin = [12 10 2 10];
p.de.margin = 2;

% could try scaling every thing by baseline sd
for y = 1:dim(1)
    for x = 1:dim(2)
        trial = load(trials{y,x});
        t = makeInTime(trial.params);
        c = trial.current(1:length(t));
        ax = p(y,x).select();
        
        c = (c - mean(c(t<1)))/(std(c(t<1)));
        line(t,c,'parent',ax,...
            'color',[0 0 0],...
            'Displayname',getFlyGenotype(trial.name));
        if x>1
            set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
        end
        if y<dim(1)
            set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        end
        set(ax,'ylim',[-20 10])
        set(ax,'xlim',[.25 .75])
        
        if x == 3 && y== 8
            set(ax,'ylim',[-10 5])
        end
        if x == 2 && y== 8
            set(ax,'ylim',[-10 5])
        end
    end
end


%%
fn = fullfile(savedir,'CellAttachedPanel.pdf');
p.export(fn, '-rp','-a1.4','-l');
