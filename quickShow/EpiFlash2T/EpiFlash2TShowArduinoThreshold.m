function varargout = EpiFlash2TShowArduinoThreshold(fig,handles,savetag,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('closefig',1,@isnumeric);
parse(p,varargin{:});

if isempty(fig) && p.Results.closefig 
    fig = figure(69); clf
elseif isempty(fig) || ~ishghandle(fig) 
    fig = figure(69+trials(1)); clf
else
    delete(fig.Children)
end

trial = handles.trial;

panl = panel(fig);
panl.pack('v',{1/5 3/5 1/5})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;


ax = panl(2).select();
%title(ax,[handles.currentPrtcl ' - ' num2str(handles.trial.params.stimDurInSec) ' s duration'])

box(ax,'off');
set(ax,'TickDir','out');
set(ax,'tag','unlink');

% Check if this trial has a probe vector
if isfield(trial,'forceProbeStuff')
    t = makeInTime(trial.params);
    h2 = postHocExposure(trial,length(trial.forceProbeStuff.CoM));
    frame_times = t(h2.exposure);
    
    plot(ax,frame_times,trial.forceProbeStuff.CoM(1:length(frame_times)),'color',[0 .2 0],'tag','ProbeTrace'), hold(ax,'on');

    ax.XLim = [t(1) t(end)];
    
    if isfield(trial,'arduino_output')
        ardo = plot(ax,t,trial.arduino_output*max(trial.forceProbeStuff.CoM-trial.forceProbeStuff.CoM(1))+trial.forceProbeStuff.CoM(1),'color',[1 .5 0],'tag','ProbeTrace');
    end
    if isfield(trial.forceProbeStuff,'ArduinoThresh')
        plot(ax,[t(1) t(end)],[1 1]*trial.forceProbeStuff.ArduinoThresh,'color',[.5 .1 .5],'tag','arduinothresh');
    end
    if isfield(trial.forceProbeStuff,'ProbeLimits')
        ax.YLim = trial.forceProbeStuff.ProbeLimits;
        ardo.YData = trial.arduino_output*...
            (trial.forceProbeStuff.ProbeLimits(2) - trial.forceProbeStuff.Neutral) + ...
            trial.forceProbeStuff.Neutral;
    end

else 
    beep
    if isfield(trial,'excluded') && trial.excluded
        fprintf(' * Bad movie: %s\n',trial.name)
    else
        butt = questdlg('Track Probe?','Track probe', 'Cancel');
        switch butt
            case 'Yes'            
                [trial,response] = probeLineROI(trial);
                trial = smoothOutBrightPixels(trial);
                if strcmp(response,'Cancel')
                    return
                end
            case 'No'
                h.probetrace_button.Value = 0;
                guidata(probebutt,h)
                return
            case 'Cancel'
                h.probetrace_button.Value = 0;
                guidata(probebutt,h)
                return
        end
    end
end

