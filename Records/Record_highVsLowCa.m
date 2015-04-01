%% Record_highVsLowCa
'C:\Users\Anthony Azevedo\Raw_Data\150121\150121_F1_C1\CurrentChirp_Raw_150121_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\150121\150121_F1_C2\CurrentChirp_Raw_150121_F1_C2_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\150121\150121_F1_C2\CurrentChirp_Raw_150121_F1_C2_20.mat';


analysis_cells = {...
    '150121_F1_C1';
    '150121_F1_C2';
    '150123_F1_C1';
    '150123_F1_C1'; % this is actually the second cell, but I forgot to update the 
};

analysis_cells_comment = {...
''
};

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c);
    analysis_cell(c).genotype = 'GH86-Gal4_pJFRC7';
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%%
cnt = find(strcmp(analysis_cells,'150121_F1_C1'));

analysis_cell(cnt).CurrChirpUpLoCaTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150121\150121_F1_C1\CurrentChirp_Raw_150121_F1_C1_2.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoChirp_Raw_141209_F1_C1_17.mat'; % distal 'down'
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoLongCourtshipSong_Raw_141209_F1_C1_5.mat';
analysis_cell(cnt).SineTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoSine_Raw_141209_F1_C1_1.mat'; % distal 


%% Band pass low neuron

loCaChirpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150123\150123_F1_C1\CurrentChirp_Raw_150123_F1_C1_2.mat';
hiCaChirpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150123\150123_F1_C1\CurrentChirp_Raw_150123_F1_C1_14.mat';

% fig = figure(1);
% set(fig, 'color',[1 1 1]);

lopnl = figure; % uipanel('parent',fig,'position',[0 0 .5 1],'BorderType','none','Backgroundcolor',[1 1 1]);
set(lopnl, 'color',[1 1 1]);
hipnl = figure; %uipanel('parent',fig,'position',[.5 0 .5 1],'BorderType','none','Backgroundcolor',[1 1 1]);
set(hipnl, 'color',[1 1 1]);

fig = figure;
panl = panel(fig);
panl.pack('h',{1/2 1/2})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';


trial = load(loCaChirpTrial);

% Time
x = makeInTime(trial.params);

obj.trial = trial;

[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

[Z,f_Z,x,y,u] = CurrentChirpZAP(lopnl,obj,'','plot',1);

p1 = panel.recover(lopnl);

trial = load(hiCaChirpTrial);

% Time
x = makeInTime(trial.params);

obj.trial = trial;

[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

[Z,f_Z,x,y,u] = CurrentChirpZAP(hipnl,obj,'','plot',1);


