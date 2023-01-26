%% Load trials
trial = load('D:\Data\230120\230120_F2_C1\LEDArduinoFlashControl_Raw_230120_F2_C1_39.mat');
trial % display the trial structure

%% Set up the figure

fig = figure;
panl = panel(fig); % panel is a useful package, available on MATLAB file exchange https://www.mathworks.com/matlabcentral/fileexchange/20003-panel?s_tid=srchtitle
panl.fontname = 'Arial';

panl.pack('v',{1/4 3/4})  % response panel, stimulus panel
panl(1).marginbottom = 16;
            
axProbe = panl(2).select();
ylabel(axProbe,'Probe (um)'); 
box(axProbe,'off'); set(axProbe,'TickDir','out','tag','quickshow_inax2');
xlabel(axProbe,'Time (s)');

axLED = panl(1).select(); axLED.XTick = {}; axLED.XColor = [1 1 1];
box(axLED,'off'); set(axLED,'TickDir','out','tag','quickshow_inax');

panl.marginleft = 18;
panl.margintop = 10;

[prot,d,fly,cell,trialname] = extractRawIdentifiers(trial.name);
title(axLED,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialname]));

%% Plot data

x = makeInTime(trial.params); % found in FlySound/Utils

if ~isfield(trial,'arduino_output')
    fprintf('Need to run continuous data extraction routine\n')
    return
end

% plot the LED
try line(x,trial.arduino_output,'parent',axLED,'color',[.8 0 0],'tag',savetag);
catch
    % Handles a bug in the continuous extraction routine. Currently working
    % on fixing this. TA 20230126
    warning('makeTime makes a different vector length than data')
    line(x(1:length(trial.arduino_output)),trial.arduino_output,'parent',axLED,'color',[.8 0 0],'tag','');
end

ylabel(axLED,'LED on'); %xlim([0 max(t)]);
axis(axLED,'tight');

% Plot the location of the probe target. This is not relevant to ChR
% stimulation of feco neurons, but here for example 
patch('XData',[x(1) x(end) x(end) x(1)], 'YData',trial.target_location(1)*[1 1 1 1] + trial.target_location(2)*[0 0 1 1],'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'parent',axProbe)

% plot the probe position
try line(x,trial.probe_position,'parent',axProbe,'color',[1 .2 .2],'tag',savetag);
catch
    % Handles a bug in the continuous extraction routine. Currently working
    % on fixing this. TA 20230126
    warning('makeTime makes a different vector length than data')
    line(x(1:length(trial.probe_position)),trial.probe_position,'parent',axProbe,'color',[1 .2 .2],'tag','');
end
axis(axProbe,'tight');
axProbe.YLim = [100 900];


