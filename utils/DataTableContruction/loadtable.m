function T = loadtable(s)
% util function to correct the file path for tables
ddir = getpref('FlyAnalysis','Datadir');

T = load(s); 
T = T.T;

if ~contains(T.Properties.Description,ddir)
    odparts = split(T.Properties.Description,filesep);
    ndparts = split(ddir,filesep);
    for d = 1:length(ndparts)
        odparts{d} = ndparts{d};
    end
    newname = join(odparts,filesep);

    fprintf('Updating table filename\nFrom\n %s\n to\n %s\n',T.Properties.Description,newname{1})
    T.Properties.Description = newname{1};

    if ~isempty(T.Properties.UserData) && isfield(T.Properties.UserData,'Dir')
        fprintf('Updating trialStem from\n %s\n to\n %s\n',T.Properties.UserData.Dir,fileparts(newname))
        T.Properties.UserData.Dir = fileparts(newname);
    end
    save(T.Properties.Description,'T')
end
