%% Record of Low Frequency Responsive Cells
clear all

savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_VoltageClampCurrentIsolation';
if ~isdir(savedir)
    mkdir(savedir)
end
id = 'CI_';

%

analysis_cells = {...
% '150617_F2_C1'
% '150704_F1_C1'
% '150706_F1_C1'
% '150709_F1_C2'
% '150715_F0_C1'

'150718_F1_C1'
'150720_F1_C2'
'150721_F2_C1'
'150722_F1_C2'
% '150723_F1_C1'

% '150730_F3_C1'
% '150826_F1_C1'
% '150826_F2_C1'
'150827_F2_C1'
% '150902_F1_C1'

% '150903_F1_C1'
% '150903_F2_C1'
% '150903_F3_C1'
% '150911_F1_C1'
% '150912_F1_C1'

'150912_F2_C1'  
'150913_F2_C1'  
'150922_F2_C1'  
'150923_F1_C1'  
'150926_F1_C1'  

'151001_F1_C1'  % For realz
'151001_F2_C1'  % For realz
'151002_F2_C1'  % For realz

'151005_F1_C1'  % controls
'151005_F2_C1'  % controls
'151006_F3_C1'  % controls
'151006_F3_C2'  % controls

'151007_F1_C1'
'151007_F3_C1'
'151007_F4_C1'
'151009_F1_C1'

'151015_F3_C1' % bph

% '150727_F0_C0' % Model cell at the end
% '150928_F0_C1'  
};

analysis_cells_comment = {...
%     'Testing and analysis design';                  % 130911_F2_C1
%     'Testing and analysis design, and drugs, 4AP->Cs->TTX->Cd';                  % 130911_F2_C1
%     'Testing and analysis design, and drugs, TTX->4AP->Cs->Cd';                  % 130911_F2_C1
%     'Testing and analysis design, and drugs, TTX->4AP->TEA->CsCd';                  % 130911_F2_C1
%     'Model cell';                  % 130911_F2_C1
    
    'BPH. Think this could be publishable'
    'BPH. some weird stuff with TEA, I think'
    'BPL. ZD7288 did some weird stuff, but does take out Ih'
    'BPH. ZD does take out Ih'
%     'BPL. But was a BPH. Also used Cs internal'
    
%     'BPL. 0 Ca causes problems, lost it during TEA';
%     'BPL. Fairly nice cell, not great access';
%     'BPL. Blew this one up, unfortunately';
    'BPL. combined 4AP and TEA';
%     'BPL. MLA block. Starting to think about how to block this strange persistent K current.'
    
%     'BPL. Charybdotoxin attempts.'
%     'BPH. Charybdotoxin attempts.'
%     'BPL. Charybdotoxin attempts.'
%     'BPL. What happens when blocking para with RNAi?'
%     'BPL. What happens when blocking para with RNAi? Older fly, clear Na currents, perhaps too old?'

    'BPL. What happens when blocking para with RNAi? Younger fly, seems like there is not much left?'
    'BPH. Beautiful Cell in Fru Gal4, done the way it should be'
    'BPH. Beautiful Cell in Fru Gal4, now need to switch the order of the drugs'
    'BPL. Recovery of Na channels is somewhat slow. Also, this is simply a control cell to check for drift'
    'BPL. Need to see the impact of series resistance compensation'

    'BPL.'
    'BPL.'
    'BPL.'

    'BPH. control, no drugs, just looking at the effect of drift'
    'BPL. control, no drugs, just looking at the effect of drift'
    'BPL. control, no drugs, just looking at the effect of drift'
    'BPH. control, no drugs, just looking at the effect of drift'
    
    'LP. crapped out after TEA'
    'LP. Should be good enough for gvt work'
    'LP. Made it through TTX'
    'LP. '

    'para RNAi FruGal4 BPH'
    
%     'Model cell';                  % 130911_F2_C1
%     'Model cell. Series Resistance investigation';                  % 130911_F2_C1

    };

analysis_cells_genotype = {...
% 'pJFRC7/+;63A03-Gal4/+'
% '10XUAS-mCD8:GFP/+;FruGal4/+'
% '10XUAS-mCD8:GFP/+;FruGal4/+'
% '10XUAS-mCD8:GFP/+;FruGal4/+'
% 'model cell'

'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
'10XUAS-mCD8:GFP/+;FruGal4/+'
% '10XUAS-mCD8:GFP/+;FruGal4/+'

% '10XUAS-mCD8:GFP;FruGal4'
% '10XUAS-mCD8:GFP;FruGal4'
% '10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
% '10XUAS-mCD8:GFP;FruGal4'

% '10XUAS-mCD8:GFP;FruGal4'
% '10XUAS-mCD8:GFP;FruGal4'
% '10XUAS-mCD8:GFP;FruGal4'
% 'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'
% 'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'

'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'

'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'

'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'
'10XUAS-mCD8:GFP;FruGal4'

'20XUAS-mCD8:GFP;VT27938-Gal4'
'20XUAS-mCD8:GFP;VT27938-Gal4'
'20XUAS-mCD8:GFP;VT27938-Gal4'
'20XUAS-mCD8:GFP;VT27938-Gal4'

'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'

% 'modelcell';                  % 130911_F2_C1
% 'modelcell';                  % 130911_F2_C1

};

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%
Script_VClamp_Cells
cnt = find(strcmp(analysis_cells,'151015_F3_C1')); % 150722_F1_C2
ac = analysis_cell(cnt);
Script_VClamp_VoltageCommandSetup
%Script_VClamp_VoltageCommands
% for ac_ind = 8:length(analysis_cell)
%     ac = analysis_cell(ac_ind);
%     Script_VClamp_VoltageCommandSetup
%     Script_VClamp_VoltageCommands
% end
