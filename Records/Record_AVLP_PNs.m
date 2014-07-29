%% All Cells

% These neurons are called AVLP-PNs (for now) because they invervate the
% area designated AVLP in 10.1016/j.neuron.2013.12.017.  Neurons with
% similar projections are defined in the MARCM catalog as inervating
% vlp,cvlp,ammc
all_cells = {'140110_F1_C1';
    
'140112_F1_C1';

'140212_F1_C1';
'140212_F1_C2';

'140214_F1_C1';

'140214_F2_C1';

'140218_F2_C2';
'140218_F3_C1';

'140218_F1_C1';
'140218_F1_C2';
'140218_F2_C1';
'140218_F2_C3';

'140219_F1_C1';
'140219_F3_C4';

'140219_F2_C1';
'140219_F3_C1';
'140219_F3_C1';
'140219_F3_C3';
'140219_F4_C1';
'140219_F4_C2';

};


%% Documenting Patching Difficulties.
% Cells that were sealed onto, but for which the patching failed.
patch_failure = {'140212_F1_C2';
    
'140214_F2_C1';

'140218_F1_C1';
'140218_F1_C2';
'140218_F2_C1';
'140218_F2_C3';

'140219_F2_C1';
'140219_F3_C1';
'140219_F3_C1';
'140219_F3_C3';
'140219_F4_C1';
'140219_F4_C2';

};

disp([length(patch_failure) ' cells']);

%% Recorded Cells
recorded_cells = {
    '140110_F1_C1'; %Include
    
    '140112_F1_C1'; %Exclude
    
    '140212_F1_C1'; % Include
    
    '140214_F1_C1'; % Ex
    
    '140218_F2_C2'; % Ex
    '140218_F3_C1'; % In
    
    '140219_F1_C1'; % Ex
    '140219_F3_C4'; % In
    };


%% Cells To Exclude:

cnt = 0;

cnt = cnt+1;
reject_cells(cnt).name = {
    '140112_F1_C1'};
reject_cells(cnt).reason = {
    'Unresponsive, 60 Hz';
    };
reject_cells(cnt).exampletrial = {
    'C:\Users\Anthony Azevedo\Raw_Data\140112\140112_F1_C1\PiezoSine_Raw_140112_F1_C1_31.mat';
    };

cnt = cnt+1;
reject_cells(cnt).name = {
    '140214_F1_C1'};
reject_cells(cnt).reason = {
    'Unresponsive, 60 Hz';
    };
reject_cells(cnt).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140214\140214_F1_C1\PiezoSine_Raw_140214_F1_C1_102.mat';
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));

cnt = cnt+1;
reject_cells(cnt).name = {
    '140218_F2_C2'};
reject_cells(cnt).reason = {
    'Unresponsive, 60 Hz';
    };
reject_cells(cnt).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140218\140218_F2_C2\PiezoSine_Raw_140218_F2_C2_6.mat';
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));

cnt = cnt+1;
reject_cells(cnt).name = {
    '140219_F1_C1'};
reject_cells(cnt).reason = {
    'Unresponsive, 60 Hz';
    };
reject_cells(cnt).exampletrial = {
    'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F1_C1\PiezoSine_Raw_140219_F1_C1_2.mat';
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));


%% Cells to Analyze:
cnt = 0;
clear analysis_cell
cnt = cnt+1;
analysis_cell(cnt).name = {
    '140110_F1_C1';
    };
analysis_cell(cnt).comment = {
    'High Frequency selective, hints of inhibition. Assymetric response to forward and back CourtS'
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoSine_Raw_140110_F1_C1_17.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoCourtshipSong_Raw_140110_F1_C1_2.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoBWCourtshipSong_Raw_140110_F1_C1_4.mat';
    };
analysis_cell(cnt).evidencecalls = {
    'PiezoSineMatrix'
    'PiezoSongAverage'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));


cnt = cnt+1;
analysis_cell(cnt).name = {
    '140212_F1_C1'
    };
analysis_cell(cnt).comment = {
    '140 Hz selective, maybe a little less. No Courtship'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140212\140212_F1_C1\PiezoSine_Raw_140212_F1_C1_49.mat';
    };
analysis_cell(cnt).evidencecalls = {...
    'PiezosineDepolTransFunc'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));


cnt = cnt+1;
analysis_cell(cnt).name = {
   '140214_F1_C1'};
analysis_cell(cnt).comment = {
    'Responsive to higher intensities across frequencies.  TTX'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140214\140214_F1_C1\PiezoSine_Raw_140214_F1_C1_102.mat';
    };
analysis_cell(cnt).evidencecalls = {...
    'PiezosineDepolTransFunc'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));



cnt = cnt+1;
analysis_cell(cnt).name = {
    '140218_F3_C1'
    };
analysis_cell(cnt).comment = {
    'Kind of responsive at high frequencies.'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140218\140218_F3_C1\PiezoSine_Raw_140218_F3_C1_1.mat';
    };
analysis_cell(cnt).evidencecalls = {...
    'PiezoSineMatrix'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));


cnt = cnt+1;
analysis_cell(cnt).name = {
    '140219_F3_C4'
    };
analysis_cell(cnt).comment = {
    '140 Hz, very selective, interesting PiezoChirp Response'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoCourtshipSong_Raw_140219_F3_C4_12.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoSine_Raw_140219_F3_C4_27.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoBWCourtshipSong_Raw_140219_F3_C4_3.mat';
    };
analysis_cell(cnt).evidencecalls = {...
    'PiezoSineMatrix'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_WEDPNs';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

%% Exporting PiezoSineMatrix info on cells 
close all
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;
            
            if exist('f','var') && ishandle(f), delete(f),end
            if exist('f2','var') && ishandle(f2), delete(f2),end

            f = PiezoSineMatrix([],obj,'to_layout');
            if save
            p = panel.recover(f);

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            fn = fullfile(genotypedir,['WPNs_', ... 
                dateID '_', ...
                flynum '_', ... 
                cellnum '_', ... 
                num2str(obj.trial.params.trialBlock) '_',...
                'PiezoSineMatrix', ...
                '.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l');

            f2 = findobj(0,'tag','PiezoSineMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'PiezoSineMatrix','PiezoSineMat_Stim');
            p.export(fn, '-rp','-l');
            end
        end
    end
end


%% Exporting PiezoSineDepolRespVsFreq info on cells 
close all
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineDepolRespVsFreq',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            if exist('f','var') && ishandle(f), close(f),end
            PiezoSineDepolRespVsFreq([],obj,'');
            f = findobj(0,'tag','PiezoSineDepolRespVsFreq');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['WPNs_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoSineDepolRespVsFreq.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l','-a1.4');
            end
        end
    end
end















