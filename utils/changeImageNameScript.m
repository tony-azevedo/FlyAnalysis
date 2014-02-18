% changeImageNameScript
pwd
% make sure you're in the right folder and that the image names are
% incorrect.

%%
[realname, remain] = strtok(fliplr(pwd),'\');
realname = fliplr(realname);

[realname, remain] = strtok(realname,'_');
realname


%%
imnames = dir('*_Image_*');
offname = imnames(1).name;
[offname,remain] = strtok(offname,'_');
offname

%%
for i_ind = 1:length(imnames)
    newname = [realname,imnames(i_ind).name(regexp(imnames(i_ind).name,offname,'end')+1:end)];
    disp(newname)
    movefile(imnames(i_ind).name,newname);
end