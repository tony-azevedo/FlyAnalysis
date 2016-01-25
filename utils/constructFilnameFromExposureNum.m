function varargout = constructFilnameFromExposureNum(data,exposureNum)

imdir = regexprep(regexprep(regexprep(data.name,'_Raw_','_Images_'),'.mat',''),'Acquisition','Raw_Data');
d = ls(fullfile(imdir,'*_Image_*'));
jnk = d(1,:);
pattern = ['_Image_' '\d+' '_'];
ind = regexp(jnk,pattern,'end');
jnk = jnk(ind(1)+1:end);
pattern = '\.tif';
ind = regexp(jnk,pattern);
ndigits = ind-1;
numstem = repmat('0',ndigits,1)';

imFileStem = [imdir '\' data.params.protocol '_Image_*_'];

ens = num2str(exposureNum);
numstem(end-length(ens)+1:end) = ens;

d = dir([imFileStem numstem '*']);
if length(d)==0
    warning([imFileStem numstem '* is not a file stem.  Use changeImageNameScript'])
    varargout{1} = [];
    
else
    
    varargout{1} = fullfile(imdir,d(1).name);
    varargout{2} = imFileStem;
end
