% All Cells recorded in VT30609/ArcLight line
'131203_F1_C1';
'131203_F1_C2';
'131203_F2_C1';

'131211_F1_C1'; % Rogue Cell (al PN)
'131211_F1_C2'; % 
'131211_F2_C1'; % First cell that looked good, not great calibration

'131212_F1_C1';  % Not Green

'131217_F1_C1';  
'131217_F2_C1';
'131217_F2_C2';

'140114_F1_C1';
'140114_F2_C1';

'140115_F1_C1';
'140115_F1_C2';
'140115_F2_C1';

'140117_F2_C1';

'140121_F1_C1';
'140121_F2_C1';

'140122_F1_C1';
'140122_F2_C1';
'140122_F2_C2';

% MakeOutTime change

'140128_F1_C1';

'140131_F1_C1';
'140131_F3_C1';

% New Internal

'140205_F1_C1';

'140206_F1_C1';
'140206_F3_C1';

'140207_F1_C2';

%% Rejected cells
% What protocols
% What does the cell look like?
% How much motion?
% Should it be thrown out?
cnt = 0;

cnt = cnt+1;
reject_cells(cnt).name = '131203_F1_C1';
reject_cells(cnt).reason = 'No images, lost cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F1_C1\Sweep_131217_F1_C1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '131203_F1_C2';
reject_cells(cnt).reason = 'No Images! Not imaging break in';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131203_F2_C1';
reject_cells(cnt).reason = 'Not imaging break-in, no responses';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131211_F1_C1';
reject_cells(cnt).reason = 'Rogue Cell (al PN)';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131211_F1_C2';
reject_cells(cnt).reason = 'No voltage clamp steps (no calibration). Cell Moved during CurrentPlateau';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_2.mat';
reject_cells(cnt).evidencecalls = 'fluorescence(trial,trial.params)';

cnt = cnt+1;
reject_cells(cnt).name = '131212_F1_C1';
reject_cells(cnt).reason = 'Not a green cell';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131217_F1_C2';
reject_cells(cnt).reason = 'Single bad sweep';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F2_C1\Sweep_Raw_131217_F2_C1_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '131217_F2_C2';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F2_C2\Sweep_Raw_131217_F2_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140114_F1_C1';
reject_cells(cnt).reason = 'Break in in I=0 Mode, and blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140114\140114_F1_C1\Sweep_Raw_140114_F1_C1_4.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140114_F2_C1';
reject_cells(cnt).reason = 'Wrong Cell, image not zoomed in';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140114\140114_F2_C1\Sweep_Raw_140114_F2_C1_1.mat';


cnt = cnt+1;
reject_cells(cnt).name = '140115_F1_C1';
reject_cells(cnt).reason = 'Current Clamp Breakin, but only went to 5mV from 10, not inside cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F1_C1\Sweep_Raw_140115_F1_C1_2.mat';


cnt = cnt+1;
reject_cells(cnt).name = '140115_F1_C2';
reject_cells(cnt).reason = 'Couldn''t break in, weird voltage values';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F1_C2\Sweep_Raw_140115_F1_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140115_F2_C1';
reject_cells(cnt).reason = 'Good Motion example! Not good access, ran out of saline, no cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F2_C1\CurrentPlateau_Raw_140115_F2_C1_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140121_F1_C1';
reject_cells(cnt).reason = 'Blew up the cell while patching';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F1_C1\Sweep_Raw_140121_F1_C1_2.mat';


cnt = cnt+1;
analysis_cell(cnt).name = '140122_F2_C1';
analysis_cell(cnt).comment = {'Moving a lot! Not a clear deliniation of the cell'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\Sweep_Raw_140122_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_12.mat';...
    };
analysis_cell(cnt).evidencecalls = {...
    };


cnt = cnt+1;
reject_cells(cnt).name = '140122_F2_C2';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C2\Sweep_Raw_140122_F2_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140128_F1_C1';
reject_cells(cnt).reason = 'Cell was up against some others, not clearly isolated';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_5.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140131_F1_C1';
reject_cells(cnt).reason = 'Blew up the cell, couldn''t patch it';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '140206_F2_C1';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F2_C1\Sweep_Raw_140206_F2_C1_2.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140206_F3_C1';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F3_C1\Sweep_Raw_140206_F3_C1_2.mat';



%% Cells to Analyze
cnt = 0;

cnt = cnt+1;
analysis_cell(cnt).name = '140117_F2_C1';
analysis_cell(cnt).comment = {'Bright, isolated','Prepoints on Voltage Plateau too few to get good dFoverF relationship'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
analysis_cell(cnt).evidencecalls = {...
    'fluorescence(trial,trial.params)';...
    'DFoverFoverDV(trial,trial.params)';...
    };

cnt = cnt+1;
analysis_cell(cnt).name = '140121_F2_C1';
analysis_cell(cnt).comment = {'Banner Cell, sound responsive, spiking, just great!'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
analysis_cell(cnt).evidencecalls = {...
    'fluorescence(trial,trial.params)';...
    'DFoverFoverDV(trial,trial.params)';...
    };

cnt = cnt+1;
analysis_cell(cnt).name = '140122_F1_C1';
analysis_cell(cnt).comment = {'Moving, not a typical auditory Neuron, slight decrease in fluorescence?'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F1_C1\Sweep_Raw_140122_F1_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F1_C1\VoltagePlateau_Raw_140122_F1_C1_3.mat';...
    };
analysis_cell(cnt).evidencecalls = {...
    };


cnt = cnt+1;
analysis_cell(cnt).name = '140131_F3_C1';
analysis_cell(cnt).comment = {'Moving.  Nice bright cell, not sound responsive, otherwise classic B1'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };
analysis_cell(cnt).evidencecalls = {...
    };


% New Internal

cnt = cnt+1;
analysis_cell(cnt).name = '140205_F1_C1';
analysis_cell(cnt).comment = {'Not a B1 cell, some spikes, smaller DF/F / DV'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140205\140205_F1_C1\Sweep_Raw_140205_F1_C1_3.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140205\140205_F1_C1\VoltagePlateau_Raw_140205_F1_C1_2.mat';...
    };
analysis_cell(cnt).evidencecalls = {...
    };


cnt = cnt+1;
analysis_cell(cnt).name = '140206_F1_C1';
analysis_cell(cnt).comment = {'Movement, Not sound responsive.  Good looking cell'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\PiezoSine_Raw_140206_F1_C1_26.mat';...
    };
analysis_cell(cnt).evidencecalls = {...
    };



cnt = cnt+1;
analysis_cell(cnt).name = '140207_F1_C2';
analysis_cell(cnt).comment = {'Moving a lot!  Should be able to fix, Not sound responsive. Cell is pressed against others'};
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\VoltagePlateau_Raw_140207_F1_C2_5.mat';...
    };
analysis_cell(cnt).evidencecalls = {...
    };

%% Motion minimization
% These cells are used to test the image correlation methods
cnt = 0;

cnt = cnt+1;
moving_cell(cnt).name = '140131_F3_C1';
moving_cell(cnt).comment = {'Moving.  Nice bright cell, not sound responsive, otherwise classic B1'};
moving_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };
moving_cell(cnt).evidencecalls = {...
    };


cnt = cnt+1;
moving_cell(cnt).name = '140206_F1_C1';
moving_cell(cnt).comment = {'Movement, Not sound responsive.  Good looking cell'};
moving_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\PiezoSine_Raw_140206_F1_C1_26.mat';...
    };
moving_cell(cnt).evidencecalls = {...
    };


cnt = cnt+1;
moving_cell(cnt).name = '140207_F1_C2';
moving_cell(cnt).comment = {'Cell is pressed against others. Moving a lot!  Should be able to fix, Not sound responsive.'};
moving_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\VoltagePlateau_Raw_140207_F1_C2_5.mat';...
    };
moving_cell(cnt).evidencecalls = {...
    };


for c_ind = 3:cnt
    for t_ind = 1:length(moving_cell(c_ind).exampletrials)
        trial = load(moving_cell(c_ind).exampletrials{t_ind});
        [protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(trial.name);

        afterCorrectionFig = figure;
        set(afterCorrectionFig,'name',[moving_cell(c_ind).name ' - ' protocol '_' trialnum]);
        I = roiFluoTrace(trial,trial.params,'NewROI','Yes','dFoFfig',afterCorrectionFig,'MotionCorrection',true,'ShowMovies',true);
        
    end
end
        


%%
trial = load('C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_2.mat')

%% Current Plateau cells
cnt = 0;

cnt = cnt+1;
curInj_cells(cnt).name = '131211_F1_C2';
curInj_cells(cnt).reason = 'Current Plateau, not voltage plateau';
curInj_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\Sweep_Raw_131211_F1_C2_1.mat';

cnt = cnt+1;
curInj_cells(cnt).name = '131211_F2_C1';
curInj_cells(cnt).reason = 'Current Plateau, not voltage plateau';
curInj_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\Sweep_Raw_131211_F2_C1_1.mat';

%% Current Clamp Break-in Cells

cnt = 0;

cnt = cnt+1;
iClampBreakin_cells(cnt).name = '131217_F1_C1';
iClampBreakin_cells(cnt).reason = 'Broke-in in Current Clamp';
iClampBreakin_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F1_C1\Sweep_Raw_131217_F1_C1_1.mat';



%% HTML Markup Example
% This is a table:
%
% <html>
% <table border=1><tr><td>one</td><td>two</td></tr>
% <tr><td>three</td><td>four</td></tr></table>
% </html>
%
disp('<html><table><tr><td>1</td><td>2</td></tr></table></html>')

%% Changes in Flourescence at Break-in.

cnt = 0;

cnt = cnt+1;
analyze_cells(cnt).name = '140206_F1_C1';
analyze_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';

analyze_cells(cnt).name = '131211_F1_C2';
analyze_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\Sweep_Raw_131211_F1_C2_1.mat';


%%
% One thing that is wierd is that fluorescnece changes in responses to
% current injection are not as large as those in response to voltage
% changes, though the changes in voltage should be enough drive some change




%%
% Analyze a cell further if it has
% * V-Clamp break in,
% * Voltage plateau

% Separate further those cells that have sound responses

cnt = cnt+1;
auditory_cell(cnt).name = '140117_F2_C1';
auditory_cell(cnt).comment = {'Bright, isolated','Prepoints on Voltage Plateau too few to get good dFoverF relationship'};
auditory_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
auditory_cell(cnt).evidencecalls = {...
    'fluorescence(trial,trial.params)';...
    'DFoverFoverDV(trial,trial.params)';...
    };

cnt = cnt+1;
auditory_cell(cnt).name = '140121_F2_C1';
auditory_cell(cnt).comment = {'Banner Cell, sound responsive, spiking, just great!'};
auditory_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
auditory_cell(cnt).evidencecalls = {...
    'fluorescence(trial,trial.params)';...
    'DFoverFoverDV(trial,trial.params)';...
    };

cnt = cnt+1;
auditory_cell(cnt).name = '140122_F2_C1';
auditory_cell(cnt).comment = {'Moving a lot! Sound responsive, step responsive, not a big change in fluorescence, either the decline or the breakin'};
auditory_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\Sweep_Raw_140122_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_12.mat';...
    };
auditory_cell(cnt).evidencecalls = {...
    };

