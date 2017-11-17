

%% Simple GUI
function spikeclickerGUI(data, unfiltered_data, locs, len, thresholds)
global Slider;
global vars;%Define this to be global so subfunction can see slider
global Param;
% Make a large figure.
close all;
fig = figure('position',[100 100 800 800], 'NumberTitle', 'off', 'color', 'w');
set(fig,'toolbar','figure');
% Just some descriptive text.
uicontrol('Style', 'text', 'String', {'Spike threshold','(sds)'}, 'Position', [150 20 90 30]);

vars.data = data;
vars.unfiltered_data = unfiltered_data;
vars.locs  = locs;
vars.len = len;
vars.thresholds = thresholds;

start_value = round(length(thresholds)/2);

plot_unfilt = 1+(vars.unfiltered_data(1:vars.len)'-mean(vars.unfiltered_data(1:vars.len)))/max(abs(vars.unfiltered_data(1:vars.len)));
plot_filt = vars.data(1:vars.len);
plot_spikes_all = vars.locs(start_value).spikes;
plot_spikes = plot_spikes_all(plot_spikes_all<len);
length(plot_filt);
% plot(plot_spikes, plot_filt(plot_spikes),'ro');hold on;
plot(plot_unfilt, 'b');hold on;
plot(plot_filt,'k');

Slider = uicontrol('Style','slider','Min',1,'Max',length(thresholds),...
                'SliderStep',[1 1]./(length(thresholds)-1),'Value',start_value,...
                'Position',[250 20 200 30], 'Callback', @PlotGUI);
            Param = get(Slider,'Value');
end
   
% % A button to run the sims.
% Button = uicontrol('Style', 'pushbutton', 'String', 'Run',...
% 'Position', [530 50 100 30],'Callback', {@PlotGUI, vars});

%% Called by GUI to do the plotting
% hObject is the button and eventdata is unused.
function PlotGUI(hObject,eventdata)
global Slider;
global vars;
global Param;

% Gets the value of the parameter from the slider.
Param = get(Slider,'Value')
% Puts the value of the parameter on the GUI.
uicontrol('Style', 'text', 'String', num2str(vars.thresholds(round(Param))),'Position', [460 20 60 20]);
plot_unfilt = 1+(vars.unfiltered_data(1:vars.len)-mean(vars.unfiltered_data(1:vars.len)))/max(abs(vars.unfiltered_data(1:vars.len)));
plot_filt = vars.data(1:vars.len);
plot_spikes_all = vars.locs(round(Param)).spikes;
plot_spikes = plot_spikes_all(plot_spikes_all<vars.len);
length(plot_filt);
xx = get(gca,'XLim'); 
yy = get(gca,'YLim');
hold off;
plot(plot_unfilt, 'b');hold on;
plot(plot_filt,'k');
plot(plot_spikes, plot_filt(plot_spikes),'ro');
xlim(xx);ylim(yy);hold off;
end
 