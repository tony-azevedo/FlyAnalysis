%% Figure 5 Cs and Para exposition of intrinsic properties

%% Voltage step and Current chirp data for all fru, vt, offtarget cells with Cs internal

close all
types = {
%     'a2_cell'
    'fru_cell'
    'vt_cell'
    'offtarget_cell'
    };

figure5 = figure;
Record_VoltageClampInputCurrents

figure5.Units = 'inches';
set(figure5,'color',[1 1 1],'position',[1 .4 getpref('FigureSizes','NeuronOneAndHalfColumn'),9.5])
pnl = panel(figure5);

figurerows = [2 1 3];
figurerows = num2cell(figurerows/sum(figurerows));
pnl.pack('v',figurerows);
pnl.margin = [16 16 4 4];

r = 1;
pnl(r).pack('h',3) 
pnl(r).marginbottom = 16;  
pnl(r).margintop = 16;  
pnl(r+1).pack('h',3) 
pnl(r+1).marginbottom = 10;  
pnl(r+2).pack('h',3) 
pnl(r+2).marginbottom = 10;  

ylims = [Inf, -Inf];

for t_ind = 1:3
    clear transfer freqs dsplcmnts f
    disp(types{t_ind})
    eval(['analysis_cell = ' types{t_ind} ';']);
    eval(['analysis_cells = ' types{t_ind} 's;']);
            
    pnl(r,t_ind).pack('v',{1/2 1/2});
    step_ax_d = pnl(r,t_ind,2).select();
    pnl(r,t_ind,2).margintop = 4;
    step_ax_u = pnl(r,t_ind,1).select();
    pnl(r,t_ind,1).marginbottom = 4;
    pnl(r,t_ind,1).title(types{t_ind}(1:regexp(types{t_ind},'_')-1))
    hold(step_ax_d,'on');
    hold(step_ax_u,'on');
    if t_ind ==1
        pnl(r,t_ind,1).ylabel('pA');
        pnl(r,t_ind,2).ylabel('pA');
        pnl(r,t_ind,2).xlabel('s');
        text(0.01,-100,'\DeltaV=15 mV','parent',step_ax_u);
        text(0.11,-100,'\DeltaV=-60 mV','parent',step_ax_d);
    end
    
    pnl(r+1,t_ind).pack('h',{1/2 1/2});
    iv_ax = pnl(r+1,t_ind,1).select();
    ramp_ax = pnl(r+1,t_ind,2).select();
    pnl(r+1,t_ind).marginbottom = 16;
    hold(iv_ax,'on');
    hold(ramp_ax,'on');
    if t_ind ==1
        pnl(r+1,t_ind,1).ylabel('\DeltaI pA');
        pnl(r+1,t_ind,1).xlabel('\DeltaV mV');
        text(-60,100,'Steps','parent',iv_ax);
        text(-60,100,'Ramps','parent',ramp_ax);
    end

    pnl(r+2,t_ind).pack('v',{1/7 3/7 3/7});
    chirp_ax = pnl(r+2,t_ind,1).select();
    pnl(r+2,t_ind,1).marginbottom = 10;
    pnl(r+2,t_ind,1).margintop = 16;
    z_ax = pnl(r+2,t_ind,2).select();
    pnl(r+2,t_ind,2).marginbottom = 4;
    th_ax = pnl(r+2,t_ind,3).select();
    pnl(r+2,t_ind,3).margintop = 4;
    hold(chirp_ax,'on');
    hold(z_ax,'on');
    hold(th_ax,'on');
    if t_ind ==1
        pnl(r+2,t_ind,1).ylabel('\DeltaV mV');
        pnl(r+2,t_ind,1).xlabel('s');
        pnl(r+2,t_ind,2).ylabel('|Z| mV');
        pnl(r+2,t_ind,3).ylabel('\Theta deg');
        pnl(r+2,t_ind,3).xlabel('Hz');
        text(100,2,'Current Chirp','parent',z_ax);
    end

    %clrs = parula(length(analysis_cell)+1);
    %clrs = clrs(1:end-1,:);
    clrs = distinguishable_colors(length(analysis_cell),{'w','k',[1 1 0],[1 1 1]*.75});

    for c_ind = 1:length(analysis_cell)
        disp(analysis_cell(c_ind).name)
        if ~isempty(analysis_cell(c_ind).VoltageStepTrial)
            trial = load(analysis_cell(c_ind).VoltageStepTrial);
            h = getShowFuncInputsFromTrial(trial);
            t = findLikeTrials('name',h.trial.name);
            
            x = makeInTime(h.trial.params);
            xwin = x>.1-.01 & x<=.1+0.03;
            
            y = nan(length(t),sum(xwin));
            for tr_ind = 1:length(t)
                trial = load(fullfile(h.dir,sprintf(h.trialStem,t(tr_ind))));
                y(tr_ind,:) = trial.current(xwin);
            end
            plot(step_ax_d,x(xwin),mean(y,1),...
                'displayname',[num2str(h.trial.params.step),' V' ],...
                'color',clrs(c_ind,:));
            
            trial = load(fullfile(h.dir,sprintf(h.trialStem,t(1)+diff(t(1:2))-1)));
            h = getShowFuncInputsFromTrial(trial);
            t = findLikeTrials('name',h.trial.name);
            xwin = x>-.01 & x<=0.03;
            
            y = nan(length(t),sum(xwin));
            for tr_ind = 1:length(t)
                trial = load(fullfile(h.dir,sprintf(h.trialStem,t(tr_ind))));
                y(tr_ind,:) = trial.current(xwin);
            end
            plot(step_ax_u,x(xwin),mean(y,1),...
                'displayname',[num2str(h.trial.params.step),' V' ],...
                'color',clrs(c_ind,:));
            
            [V,I,Base] = PF_VoltageStepIVRelationship_NoPlot(h,'');
            plot(iv_ax,V-Base,I,...
                'tag',analysis_cell(c_ind).name,...
                'displayname',[num2str(h.trial.params.step),' V' ],...
                'color',clrs(c_ind,:));
        end
        
        if ~isempty(analysis_cell(c_ind).VoltageCommandTrial)
            trial = load(analysis_cell(c_ind).VoltageCommandTrial);
            h = getShowFuncInputsFromTrial(trial);
            trials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData);

            [stimvec,x] = VoltageCommandStim(trial.params);
    
            current = zeros(size(x));
            voltage = zeros(size(x));
            
            for trial_ind = 1:length(trials);
                trial = load(fullfile(h.dir,sprintf(h.trialStem,trials(trial_ind))));
                current = current+trial.current;
                voltage = voltage+trial.voltage;
            end
            current = current/length(trials);
            d1 = getpref('FigureMaking','CurrentFilter');
            if d1.SampleRate ~= trial.params.sampratein
                d1 = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',trial.params.sampratein);
            end
            current = filtfilt(d1,current);

            voltage_in = voltage/length(trials);
            voltage_hold = mean(voltage_in(x>0-.05 &x<0));
            voltage = stimvec; %+voltage_hold;
            
            plot(ramp_ax,voltage(x>=0.5&x<1),current(x>=0.5&x<1),...
                'tag',analysis_cell(c_ind).name,...
                'displayname',analysis_cell(c_ind).name,...
                'color',clrs(c_ind,:));

        end

        if ~isempty(analysis_cell(c_ind).CurrentChirpTrial)
            trial = load(analysis_cell(c_ind).CurrentChirpTrial);
            h = getShowFuncInputsFromTrial(trial);
            
            [Z,f,x,y,u,f_,Z_mag,Z_phase] = Script_CurrentChirpZAPFam(h);
            
            plot(chirp_ax,x(x>=0&x<10),y(x>=0&x<10),...            
                'tag',analysis_cell(c_ind).name,...
                'displayname',[num2str(h.trial.params.amp),' V' ],...
                'color',clrs(c_ind,:));
            plot(z_ax,f_,Z_mag,...            
                'tag',analysis_cell(c_ind).name,...
                'displayname',[num2str(h.trial.params.amp),' V' ],...
                'color',clrs(c_ind,:));
            plot(th_ax,f_,Z_phase,...            
                'tag',analysis_cell(c_ind).name,...
                'displayname',[num2str(h.trial.params.amp),' V' ],...
                'color',clrs(c_ind,:));
        end

    end
    set(step_ax_d,'ylim',getpref('FigureMaking','Figure5VStepYlims'))
    set(step_ax_u,'ylim',getpref('FigureMaking','Figure5VStepYlims'))
    
    set(iv_ax,'ylim',getpref('FigureMaking','Figure5VStepYlims'))
    set(iv_ax,'xlim',[-62 17])
    set(ramp_ax,'ylim',getpref('FigureMaking','Figure5VStepYlims'))
    set(ramp_ax,'xlim',[-62 17])
    
    set(chirp_ax,'ylim',getpref('FigureMaking','Figure5IChirpYlims'))
    set(z_ax,'ylim',getpref('FigureMaking','Figure5IChirpZYlims'))
    set(th_ax,'ylim',[-180 60])
    figure(figure5)
    drawnow
end

savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure5/';
savePDF(figure5,savedir,[],'Figure5_CsPara_IntrinsicProperties')
