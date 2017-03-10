analysis_grid = {...

% before video or anything else
'160629_F1_C1'      '81A07-Gal4/20XUAS-mCD8:GFP'        'spikes Big. Is this really a 81A07?'
'160630_F1_C1'      '81A07-Gal4/20XUAS-mCD8:GFP'        'according to notes this was clearly a flexor, no video'
'160630_F2_C1'      '81A07-Gal4/20XUAS-mCD8:GFP'        'Flat lining cell. Im not seeing the spikes I saw in 160629_F1_C1...'
'160719_F2_C1'      '22H10-Gal4/20XUAS-mCD8:GFP'        'Flat lining, i.e. saturating voltage response'

% Early Days
'160722_F3_C1'      '22H10-Gal4/20XUAS-mCD8:GFP'        'Green cell? some spikes'

'160823_F1_C1'      '81A04-Gal4/20XUAS-mCD8:GFP'        'Nothing much going on'

'160721_F3_C2'      '81A07-Gal4/20XUAS-mCD8:GFP'        'Sag/Flat lining. Clearly a flexor, not great video though'
'160824_F1_C1'      '81A07-Gal4/20XUAS-mCD8:GFP'        'Hmm, bizarre spiking cell.'
'160824_F3_C2'      '81A07-Gal4/20XUAS-mCD8:GFP'        'responses in the cell are large, fly was moving its leg. 4 mV response in membrane depolarization'
'160906_F1_C2'      '81A07-Gal4/20XUAS-mCD8:GFP'        'Nothing'

'160906_F1_C2'      '81A07-Gal4/20XUAS-mCD8:GFP'        'Nothing'

% Useful, according to leg mn.

% tirm
'160908_F1_C1'      '81A04-Gal4/20XUAS-mCD8:GFP'        'Some activity following Epiflash, no fill, very depolarized'
'160908_F2_C1'      '81A04-Gal4/20XUAS-mCD8:GFP'        'activity during leg movement, no fill, ~-31 mV'
'160909_F1_C1'      '81A04-Gal4/20XUAS-mCD8:GFP'        'activity epi, no fill, -44.5 with sudden depolarization'
'161101_F1_C1'      '35C09-Gal4/20XUAS-mCD8:GFP'        'activity epi, no fill, -44.5 with sudden depolarization'

%tidm
'160913_F1_C1'      '81A07-Gal4/20XUAS-mCD8:GFP'        'Banner cell. caffeine, manipulator movements, fill'

%tilm
'170104_F2_C1'      '16H01-Gal4/20XUAS-mCD8:GFP'        'No spikes, but depolarizations'

%ltm1?
'160915_F1_C1'      '91A02-Gal4/20XUAS-mCD8:GFP'        'Hmm. Shit is happening here, but no video. Not convincing'
'160915_F3_C1'      '91A02-Gal4/20XUAS-mCD8:GFP'        'Maybe. No spikes, still!'
'160916_F1_C1'      '91A02-Gal4/20XUAS-mCD8:GFP'        'Maybe some activity, but nothing to confirm'

'160922_F1_C1'      '22H10-Gal4/20XUAS-mCD8:GFP'        'Stray spikes! where did these come from?'

'161014_F1_C1'      '47F09-Gal4/20XUAS-mCD8:GFP'        'No spikes, no movement' %'Stray spikes! where did these come from?'

% tadm - certainly looks like one, but it's not clear.
'161011_F1_C1'      '76E09-Gal4/20XUAS-mCD8:GFP'        'Very bright line! Maybe. No spikes, still!'
'170202_F2_C1'      '76E09-Gal4/20XUAS-mCD8:GFP'        'Spikes for sure!, still!'

% talm
'170207_F1_C1'      '76E09-Gal4/20XUAS-mCD8:GFP'        'Movement, beautiful responses'


% Something to do with tadm ?
'161221_F1_C1'      '56F06-Gal4/20XUAS-mCD8:GFP'        'Great cell! Green, spiking, good recording, clear movement related activity.'
% ??
'161214_F1_C1'      '52D06-Gal4/20XUAS-mCD8:GFP'        'Great cell! Green, spiking, good recording, eventually crapped out, no video'

% ltm2 ?
'161109_F1_C1'      '63A03-Gal4/20XUAS-mCD8:GFP'        'Nothing, no leg movement either'

% Unknown but useful
'161123_F2_C2'      '16H01-Gal4/20XUAS-mCD8:GFP'        'John was watching, good recording, apparently, but no spiking, no leg movement'

% EMG
'161116_F1_C2'
}

clear analysis_cell analysis_cells
% analysis_grid = cesiumPara_grid
for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1}; 
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1}; 
end
genotypes = analysis_grid(:,2);
[genotype_set,~,genotype_idx] = unique(genotypes);


%% pJFRC7;VT30609-Gal4
cnt = find(strcmp(analysis_cells,''));
if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageSine = ...
        '';
    analysis_cell(cnt).trials.Sweep = ...
        '';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA'};
    
    analysis_cell(cnt).trials.CurrentChirp = ...
        '';
    analysis_cell(cnt).trials.VoltageStep = ...
        '';
    analysis_cell(cnt).trials.VoltageStep_Drugs = {
        '';
        };
    analysis_cell(cnt).VSdrugs = ...
        '';
end
