function [fig] = plotChunkOfTrials(T,varargin)
% f = plotChunkOfTrials(T,title)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('Long','No',@(x)any(ismember({'Yes','yes','No','no'},x)));
p.addParameter('Spikes','No',@(x)any(ismember({'Yes','yes','No','no'},x)));
p.addParameter('Align2LEDOff','No',@(x)any(ismember({'Yes','yes','No','no'},x)));
p.addParameter('Title','',@ischar);
p.addParameter('FPLims',[],@isnumeric);

parse(p,varargin{:});


if isempty(T)
    fprintf('No trials\n')
    fig = [];
    return
end
Dir = T.Properties.UserData.Dir;
trialStem = T.Properties.UserData.trialStem;

fig = figure;
fig.Position = [500   320   960   600];
panl = panel(fig);
panl.pack('v',{1/7 3/7 3/7})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl(1).margintop = 2;
panl(2).margintop = 10;
panl(3).margintop = 10;
panl.marginbottom = 12;

diax = panl(1).select();
posax = panl(2).select();
aiax = panl(3).select();
linkaxes([aiax,posax,diax],'x')

diax.NextPlot = 'add';                
diax.XAxis.Visible = 'off';
posax.NextPlot = 'add';
posax.XAxis.Visible = 'off';
aiax.NextPlot = 'add';

for r = 1:size(T,1)
    T_row = T(r,:);    
    trial = load(fullfile(Dir,sprintf(trialStem,T_row.trial)));
    
    % Short or long
    switch p.Results.Long
        case {'No','no'}
            x = makeInTime(trial.params);
            ao = trial.arduino_output;
            fp = trial.probe_position;
        case {'Yes','yes'}
            x = cat(1,makeInTime(trial.params),makeInterTime(trial));
            ao = cat(2,trial.arduino_output,trial.intertrial.arduino_output);
            fp = cat(2,trial.probe_position,trial.intertrial.probe_position);
    end        
    
    % Align to off
    switch p.Results.Align2LEDOff
        case {'No','no'}
            plot(diax,x,ao);
            pr = plot(posax,x,-fp,'tag',num2str(T_row.trial));
        case {'Yes','yes'}
            plot(diax,x-T_row.arduino_duration,ao);
            pr = plot(posax,x-T_row.arduino_duration,-fp,'tag',num2str(T_row.trial));
    end        

    % Spikes or voltage
    switch p.Results.Spikes
        case {'No','no'}
            
            % Short or Long
            switch p.Results.Long
                case {'No','no'}
                    y = trial.voltage_1;
                    plot(aiax,x,y,'tag',num2str(T_row.trial));
                case {'Yes','yes'}
                    y = cat(2,trial.voltage_1,trial.intertrial.voltage_1);
            end
            
            % Align to off
            plot(aiax,x,y,'tag',num2str(T_row.trial));
            switch p.Results.Align2LEDOff
                case {'No','no'}
                    plot(aiax,x,y,'tag',num2str(T_row.trial));
                case {'Yes','yes'}
                    plot(aiax,x-T_row.arduino_duration,y,'tag',num2str(T_row.trial));
            end
            
        % Spikes 
        case {'Yes','yes'}
            % Short or Long
            switch p.Results.Long
                
                % Align to off
                case {'No','no'}
                    x = makeInTime(trial.params);
                    switch p.Results.Align2LEDOff
                        case {'No','no'}
                            raster(aiax,x(trial.spikes(trial.spikes<length(x))),-r+[-.48 .48],'tag','Spikes','UserData',T_row.trial);
                        case {'Yes','yes'}
                            raster(aiax,x(trial.spikes(trial.spikes<length(x)))-T_row.arduino_duration,-r+[-.48 .48],'tag','Spikes','UserData',T_row.trial);
                    end
                case {'Yes','yes'}
                    x = cat(1,makeInTime(trial.params),makeInterTime(trial));
                    switch p.Results.Align2LEDOff
                        case {'No','no'}
                            raster(aiax,x(trial.spikes),-r+[-.48 .48],'tag','Spikes','UserData',T_row.trial);
                            raster(aiax,x(trial.intertrial.spikes(~isnan(trial.intertrial.spikes))),-r+[-.48 .48],'tag','Spikes','UserData',T_row.trial);
                        case {'Yes','yes'}
                            raster(aiax,x(trial.spikes)-T_row.arduino_duration,-r+[-.48 .48],'tag','Spikes','UserData',T_row.trial);
                            raster(aiax,x(trial.intertrial.spikes(~isnan(trial.intertrial.spikes)))-T_row.arduino_duration,-r+[-.48 .48],'tag','Spikes','UserData',T_row.trial);
                    end
            end
            ticks = findobj(aiax,'tag','Spikes','UserData',T_row.trial);
            set(ticks,'linewidth',.5,'color',pr.Color);
    end
    
end

axis(aiax,'tight');
xlims = aiax.XLim;

if all(T.hiforce) || all(~T.hiforce)
    %all(T.target1==T.target1(1)) && all(T.target2==T.target2(1))

    ptch = patch('XData',[xlims(1) xlims(end) xlims(end) xlims(1)], ...
        'YData',-(T.target1(end)*[1 1 1 1] + diff([T.target1(end) T.target2(end)])*[0 0 1 1]),...
        'FaceColor',[1 1 1]*.9,'EdgeColor','none','parent',posax,'Tag','target');
    posax.Children = circshift(posax.Children,-1);
    
    if ~T.hiforce(1)
        trgclr = [.7 0 .7];
    else
        trgclr = [1 .8 1];
    end
    rectangle(posax,'Position',[xlims(1) -T.target2(end) .05 diff([T.target1(end) T.target2(end)])],'FaceColor',trgclr,'EdgeColor','none','LineWidth',2)

    if all(T.blueToggle)
        ptch = findobj(posax,'Tag','target');
        ptch.FaceColor = [.9 .9 1];
    end
    
end


title(diax,p.Results.Title);
ylabel(diax,'LED state')
ylabel(posax,'Probe position (flipped)')
xlabel(aiax,'Time (s)')
switch p.Results.Spikes
    case {'No','no'}
        ylabel(aiax,'V_m (mV)')
    case {'Yes','yes'}
        ylabel(aiax,'Trial idx')
end

if ~isempty(p.Results.FPLims)
    posax.YLim = -[fplims(2),fplims(1)];
end
