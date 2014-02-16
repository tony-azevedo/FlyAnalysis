% append stimulus trace: This is to make up for the lack of foresite on
% storing the stimulus trace on 5/25/13.
load('C:\Users\Anthony Azevedo\Acquisition\27-May-2013\27-May-2013_F1_C1\PiezoStep_27-May-2013_F1_C1.mat')
load('C:\Users\Anthony Azevedo\Acquisition\27-May-2013\27-May-2013_F1_C1\PiezoChirp_27-May-2013_F1_C1.mat')
trial = regexp(name,'_'); trial = str2num(name(trial(end)+1:end));
label = regexp(name,'\'); label = name(label(end)+1:end);
label = regexprep(label,'_','.');
D = ['C:\Users\Anthony Azevedo\Acquisition\',olddata(1).date,'\',...
    olddata(1).date,'_F',olddata(1).flynumber,'_C',olddata(1).cellnumber];

trialstogo = nan(size(olddata));
for d = 1:length(olddata)
    trialstogo(d) = olddata(d).trial;
end
load('trialscompleted');
oldcompleted = completed;

for d = 1:length(olddata)
    if ...
            olddata(d).freqstart == data(trial).freqstart && ...
            olddata(d).freqstop == data(trial).freqstop && ...
            olddata(d).ramptime == data(trial).ramptime && ...
            olddata(d).displacement == data(trial).displacement && ...
            olddata(d).postDurInSec == data(trial).postDurInSec && ...
            olddata(d).preDurInSec == data(trial).preDurInSec && ...
            olddata(d).stimDurInSec == data(trial).stimDurInSec
        
        oldname = [D,'\',olddata(d).protocolName,'_Raw_', ...
            olddata(d).date,'_F',olddata(d).flynumber,'_C',olddata(d).cellnumber,'_', ...
            num2str(olddata(d).trial)];
        
        load(oldname)
        save(name,'current','voltage','name','sgsmonitor');
        completed = [completed olddata(d).trial];            
    end
end
completed = unique(completed);

[~,~,tgind]  = intersect(completed,trialstogo);
tg = true(size(trialstogo));
tg(tgind) = false;
fprintf('To Go: %d of %d \n',sum(tg), length(olddata));
disp(trialstogo(tg))

[~,~,tgind]  = intersect(oldcompleted,completed);
tg = true(size(completed));
tg(tgind) = false;
disp(completed(tg))

save('trialscompleted','completed')
