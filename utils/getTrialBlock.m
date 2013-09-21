function varargout = getTrialBlock(notes,currentPrtcl,trial)
% block beginning
trlnnum = regexp(notes,[currentPrtcl ' trial ' num2str(trial) ','],'end');
trln = notes(1:trlnnum);
comments = regexp(trln,['\t' currentPrtcl ' - '],'end');
comtxt = trln(comments(end):end);
if ~isempty(comtxt)
    bllnnum = regexp(comtxt,[currentPrtcl ' trial\s\d*,'],'end');
    blln = comtxt(1:bllnnum(1));
    cm1 = regexp(blln,'trial\s\d*,','start');
    cm2 = regexp(blln,'trial\s\d*,','end');
    starttrnm = str2double(blln(cm1(1)+6:cm2(1)-1));
end

% block end
trlnnum = regexp(notes,[currentPrtcl ' trial ' num2str(trial) ',']);
trln = notes(trlnnum:end);
comments = regexp(trln,'\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\n','end');
comtxt = trln(1:comments(1));
if ~isempty(comtxt)
    bllnnum = regexp(comtxt,[currentPrtcl ' trial '],'start');
    blln = comtxt(bllnnum(length(bllnnum)):end);
    newlnnum = regexp(blln,'\n');
    blln = blln(1:newlnnum(1));
    cm1 = regexp(blln,'\s\d*,','start');
    cm2 = regexp(blln,'\s\d*,','end');
    endtrnm = str2double(blln(cm1(1)+1:cm2(1)-1));
end

varargout = {starttrnm,endtrnm};