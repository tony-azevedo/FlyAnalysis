if ~exist('savedir','var')
    error('Create a ''savedir'' variable')
end

figs = dir(fullfile(savedir,'Figure_*.pdf'));
numext = length(figs)+1;

nameguess = [get(gcf,'name') '.pdf'];
set(gcf,'color',[1 1 1]);

[FileName,PathName,FilterIndex] = uiputfile('*.*',...
    'File Path',...
    [savedir nameguess]);
FileName = regexprep(FileName,' ','_')
if ~FileName
    eval(sprintf('export_fig C:\\Users\\Anthony'' Azevedo''\\Desktop\\Weekly_Record\\Figure_%d -pdf -transparent',numext));
else
    eval(['export_fig ' regexprep(fullfile(PathName,FileName),'\sAzevedo',''' Azevedo''')]);
end
