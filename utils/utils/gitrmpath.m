%% .svn folder removal script
pathstr = path;
if strcmp(computer('arch'),'win32') || strcmp(computer('arch'),'win64')
    colons = strfind(pathstr,';');
    colons = [0,colons,length(colons)+1];
else
    colons = strfind(pathstr,':');
    colons = [0,colons,length(colons)+1];
end

svnfolders = strfind(pathstr,'.git');

rmstr = cell(length(svnfolders),1);
svncount = 0;
for i = 2:length(colons)
    if strfind(pathstr(colons(i-1)+1:colons(i)-1),'.git')
        svncount = svncount+1;
        rmstr{svncount} = pathstr(colons(i-1)+1:colons(i)-1);
    end
end
fprintf(1,'Removing %g git folders from the path..........',svncount);
rmpath(rmstr{:});
savepath
path
clear colons rmstr svncount pathstr svnfolders