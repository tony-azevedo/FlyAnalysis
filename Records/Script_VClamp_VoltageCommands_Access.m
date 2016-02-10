% Access resistance
% comparestims = {'VoltageRamp_m100_p20',...
%     'VoltageRamp_m70_p20','VoltageRamp_m70_p20_1s',...
%     'VoltageRamp_m60_p40', 'VoltageRamp_m60_p40_1s', 'VoltageRamp_m60_p40_h_1s',
%     'VoltageRamp_m50_p12_h_0_5s};

yyddmm = ac.name(1:6);
trial = load([fullfile('C:\Users\tony\Raw_Data\',yyddmm,ac.name) '\VoltageStep_Raw_' ac.name '_1.mat']);  
h = getShowFuncInputsFromTrial(trial);

% trial = load(ac.trials.VoltageCommand);
% h = getShowFuncInputsFromTrial(trial);
cd(h.dir);

[trial,fig,Ri_struct,access] = CellInputResistance(trial);

if ~isdir(fullfile(savedir,'access'))
    mkdir(fullfile(savedir,'access'))
end

fn = fullfile(savedir,'access',[ac.name,'_access.pdf']);
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

set(fig,'paperpositionMode','auto');
saveas(fig,fullfile(savedir,'access',[ac.name,'_access']),'fig');
