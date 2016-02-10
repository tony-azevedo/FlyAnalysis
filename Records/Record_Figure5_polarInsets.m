%% Figure 5 supplemental stuff
close all

%% Polar plots for all the cells by genotype (fru vt offtarget)
% Record_Figure5
figure5 = figure;
Record_VoltageClampInputCurrents

figure5.Units = 'inches';
set(figure5,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneAndHalfColumn'),10])
pnl = panel(figure5);

figurerows = [1 5 5 5 5 7 7];
figurerows = num2cell(figurerows/sum(figurerows));

pnl.pack('v',figurerows);
pnl.margin = [16 16 4 4];

r = 6;
pnl(r).pack('h',3)  
pnl(r).marginbottom = 4;  
pnl(r).marginleft = 4;  

types = {
    'a2_cell'
    'fru_cell'
    'vt_cell'
    'offtarget_cell'
    };
clear pnl_hs
mag = 0;

for t_ind = 2:4
    clear transfer freqs dsplcmnts f 
    eval(['analysis_cell = ' types{t_ind} ';']);
    eval(['analysis_cells = ' types{t_ind} 's;']);
    
    trial = load(analysis_cell(1).PiezoSineTrial);
    h = getShowFuncInputsFromTrial(trial);
    
    fn = fullfile('C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\TransferFunctions',[types{t_ind}(1:regexp(types{t_ind},'_')) 'Xfunctions.mat']);
    if exist(fn,'file')==2
        s = load(fn);
    else
        if t_ind==1
        funchandle = @PF_PiezoSineDepolRespVsFreq_Current;
        else
        funchandle = @PF_PiezoSineOsciRespVsFreq;
        end
        for c_ind = 1:length(analysis_cell)
            trial = load(analysis_cell(c_ind).PiezoSineTrial);
            h = getShowFuncInputsFromTrial(trial);
            fprintf(1,'PF_PiezoSineOsciRVF: %s\n',analysis_cell(c_ind).name);
            
            [f,transfer{c_ind},freqs{c_ind},dsplcmnts{c_ind}] = feval(funchandle,[],h,analysis_cell(c_ind).genotype);
            savePDF(f,'C:\Users\tony\Dropbox\RAnalysis_Data\Record_VoltageClampInputCurrents\TransferFunctions',[],[types{t_ind}(1:regexp(types{t_ind},'_')) 'Xfunctions_' analysis_cell(c_ind).name]);
        end
        s.name = analysis_cells;
        s.transfer = transfer;
        s.freqs = freqs;
        s.dsplcmnts = dsplcmnts;
        save(fn,'-struct','s')
    end

    name = s.name;
    transfer = s.transfer;
    freqs = s.freqs;
    dsplcmnts = s.dsplcmnts;
    
    tranf_ax = pnl(r,t_ind-1).select();
    pnl_hs(1,t_ind-1) = pnl(r,t_ind-1).select();
    hold(tranf_ax,'on');
    
    displacements = dsplcmnts{1};
    
    show_freq = h.trial.params.freqs(6);
    show_dsplc = h.trial.params.displacements(3);
    for c_ind = 1:length(transfer)
        d_i = find(dsplcmnts{c_ind} == show_dsplc);
        f_i = find(freqs{c_ind} == show_freq);
        dspltranf = transfer{c_ind}(f_i,d_i);
        mag = max([mag abs(dspltranf)]);
        dot = plot(dspltranf,...
            'parent',tranf_ax,'linestyle','none','color',0*[.85 .85 .85],...
            'marker','o','markerfacecolor',0*[.85 .85 .85],'markeredgecolor','none',...
            'displayname',name{c_ind},'tag',types{t_ind},'userdata',dspl(d_i));
%     set(dot,'Marker','o','MarkerEdgeColor','none','MarkerFaceColor',clrs(max_idx,:),...
%         'displayname',analysis_cell(max_idx).name)
    end
    eval(['exname = ' types{t_ind}(1:regexp(types{t_ind},'_')-1) 'example.name']);

    set(findobj(tranf_ax,'type','line','-regexp','displayname',exname),'MarkerFaceColor',[1 0 0])
    %legend('toggle')
    
    
    set(tranf_ax,'box','off','TickDir','out')
    axis(tranf_ax,'equal')
end
for t_ind = 1:length(pnl_hs)
    % draw some polar radii
    xy = [0 0; -1 1];
    th = pi/6;
    rot = [cos(th) -sin(th); sin(th) cos(th)];
    for th_ = 0:5
        line(1.1*mag*xy(1,:),1.1*mag*xy(2,:),'parent',pnl_hs(t_ind),'color',[ 1 1 1]*.9);
        xy = rot*xy;
    end
    axis(pnl_hs(t_ind),'equal')
end
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(figure5,savedir,[],'Figure5phases')



