%% ----------------------- Get Node

node = gui.getSelectedEpochTreeNodes();
node = node{1};
fprintf('Node: %s\n',leafIdentifier(node));


%% ------------------------ Get Epoch Data

node = gui.getSelectedEpochTreeNodes();
node = node{1};
edata = riekesuite.getResponseVector(node.epochList.firstValue,'Amp. 1');
if size(edata,1)>size(edata,2)
    edata = edata';
end
etime = makeTime(node.epochList.firstValue);
edata = basetimeSubtract(edata,etime);


%% ----------------------- Get GUI Node Data

node = gui.getSelectedEpochTreeNodes();
node = node{1};
edata = riekesuite.getResponseMatrix(node.epochList,'Amp. 1');
if size(edata,1)>size(edata,2)
    edata = edata';
end
etime = makeTime(node.epochList.firstValue);
edata = basetimeSubtract(edata,etime);


%% ----------------------- treeGUI

gui = epochTreeGUI(tree)


%% ----------------------- Epoch Classification Removal Node

epochClassificationRemovalNode = gui.getSelectedEpochTreeNodes();
epochClassificationRemovalNode = epochClassificationRemovalNode{1};
fprintf(1,'Epoch Classification Removal Node : %s\n', leafIdentifier(epochClassificationRemovalNode));


%% ----------------------- Get Data Storing Node

datastoringnode = gui.getSelectedEpochTreeNodes();
datastoringnode = datastoringnode{1};
fprintf('Data Storing Node: %s\n',leafIdentifier(datastoringnode));


%% ----------------------- Load List
clear, startup
 
loader = edu.washington.rieke.Analysis.getEntityLoader();
treeFactory = edu.washington.rieke.Analysis.getEpochTreeFactory();
 
%  EXPERIMENTS: Choose one of these first
 
[expName,exptparams,analysis] = chooseExperiment();
exptparams.redo = 1;
 
% PATHS
genotype = expName(1:strfind(expName,'_')-1);
if isempty(strfind(expName,'_')), genotype = expName; end;
 
root = sprintf('~/Analysis/Ovation-index/%s/%s',genotype,expName);
eval(sprintf('cd %s',root))
 
exportroot = pwd; exportroot = [exportroot(1:strfind(exportroot,'tony')+4) sprintf('Exports/%s',genotype)];
if isfield(exptparams,'tissue') && strcmp(exptparams.tissue,'retina')
    datapath = pwd; datapath = [datapath(1:strfind(datapath,'tony')+4) 'slice_rig_raw_data'];
else
    datapath = pwd; datapath = [datapath(1:strfind(datapath,'tony')+4) 'raw_data'];
end
 
ovExportStr = sprintf('%s/%s%s_%s.mat',exportroot,expName,exptparams.tag,analysis);
fprintf(1,'Ovation Export last modified: \n');
disp(dir(ovExportStr));
 
% LOAD LIST
fprintf(1,'Creating Epoch List: \n');
tic
list = loader.loadEpochList(ovExportStr, datapath);
list = list.sortedBy('protocolSettings.acquirino:epochNumber');
toc


%% ----------------------- Results

r = node.custom.get('results')


%% ----------------------- Node Tags

node = gui.getSelectedEpochTreeNodes();
node = node{1};
fprintf('\nTags for Node: %s\n',leafIdentifier(node));

keys = epochListKeywords(node);

ind = false(node.epochList.length,1);
for k = 1:length(keys)
    for e = 1:node.epochList.length
        ind(e) = node.epochList.valueByIndex(e).keywords.contains(keys{k});
    end
    fprintf('%s: %d\n',keys{k},sum(ind));
end

