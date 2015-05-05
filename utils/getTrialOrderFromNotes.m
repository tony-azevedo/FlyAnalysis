function [o, dn] = getTrialOrderFromNotes(trial)

[prot,dateID,~,~,~,~,~,~,notesfile] = ...
    extractRawIdentifiers(trial.name);

% notesfid = fopen(notesfile,'r');
notes = fileread(notesfile);

trln = regexp(notes,[prot ' trial ' num2str(trial.params.trial)]);
trln_begin = regexp(notes(trln:-1:1),'\n','once')-1;
trialinfo = notes(trln-trln_begin:trln+regexp(notes(trln:end),'\n','once')-1);
trialinfo = regexprep(trialinfo,'(?=\d)\s',',');

[tm_ind, tm_end] = regexp(trialinfo,'(\d*),','once');

o = str2double(trialinfo(tm_ind:tm_end-1));

[tm_ind, tm_end] = regexp(trialinfo,'(\d*):(\d*):(\d*)','once');

dn = trialinfo(tm_ind:tm_end);
[hh,remain] = strtok(dn,':');
[mm,remain] = strtok(remain,':');
ss = strtok(remain,':');

yy = ['20' dateID(1:2)];
MM = dateID(3:4);
DD = dateID(5:6);

dn = datenum([...
    str2double(yy)
    str2double(MM)
    str2double(DD)
    str2double(hh)
    str2double(mm)
    str2double(ss)
    ]');
