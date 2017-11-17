

%% Simple GUI
function threshold_sliderGUI(data, unfiltered_data, piezo, locs, len, thresholds, sd_threshold)
global Slider;
global vars;%Define this to be global so subfunction can see slider
global peak_threshold;
% Make a large figure.
close all;
fig = figure('position',[100 100 1200 800], 'NumberTitle', 'off', 'color', 'w');
set(fig,'toolbar','figure');
% Just some descriptive text.
uicontrol('Style', 'text', 'String', {'Spike threshold','(sds)'}, 'Position', [150 20 90 30]);

vars.data = data;
vars.unfiltered_data = unfiltered_data;
vars.locs  = locs;
vars.len = len;
vars.thresholds = thresholds;
vars.piezo = piezo;

if isempty(sd_threshold)
start_value = round(length(thresholds)/2);
else
start_value = round(sd_threshold);
end

plot_unfilt = 2+2*(vars.unfiltered_data(1:vars.len)'-mean(vars.unfiltered_data(1:vars.len)))/max(abs(vars.unfiltered_data(1:vars.len)));
plot_filt = vars.data(1:vars.len);
plot_spikes_all = vars.locs(start_value).spikes;
plot_spikes = plot_spikes_all(plot_spikes_all<len);
plot_piezo = (piezo(1:vars.len)-mean(piezo))/max(piezo)-2;
length(plot_filt);
% plot(plot_spikes, plot_filt(plot_spikes),'ro');hold on;
plot(plot_unfilt, 'b');hold on;
plot(plot_filt,'k');
plot(plot_piezo,'r');
plot(plot_spikes, plot_filt(plot_spikes),'ro');

ylim([min(plot_piezo)-0.1 max(plot_unfilt)]);

Slider = uicontrol('Style','slider','Min',1,'Max',length(thresholds),...
                'SliderStep',[1 1]./(length(thresholds)-1),'Value',start_value,...
                'Position',[250 20 200 30], 'Callback', @Threshold_GUI);
                peak_threshold = get(Slider,'Value');
           
end
   
% % A button to run the sims.
% Button = uicontrol('Style', 'pushbutton', 'String', 'Run',...
% 'Position', [530 50 100 30],'Callback', {@PlotGUI, vars});

%% Called by GUI to do the plotting
% hObject is the button and eventdata is unused.
function Threshold_GUI(hObject,eventdata)
global Slider;
global vars;
global peak_threshold;

% Gets the value of the peak_thresholdeter from the slider.
xx = get(gca,'XLim'); 
yy = get(gca,'YLim');
peak_threshold = get(Slider,'Value');
% Puts the value of the peak_thresholdeter on the GUI.
uicontrol('Style', 'text', 'String', num2str(vars.thresholds(round(peak_threshold))),'Position', [460 20 60 20]);
plot_unfilt = 2+2*(vars.unfiltered_data(1:vars.len)-mean(vars.unfiltered_data(1:vars.len)))/max(abs(vars.unfiltered_data(1:vars.len)));
plot_filt = vars.data(1:vars.len);
plot_spikes_all = vars.locs(round(peak_threshold)).spikes;
plot_spikes = plot_spikes_all(plot_spikes_all<vars.len);
plot_piezo = (vars.piezo(1:vars.len)-mean(vars.piezo))/max(vars.piezo)-1;
length(plot_filt);

hold off;
plot(plot_unfilt, 'b');hold on;
plot(plot_filt,'k');
plot(plot_piezo,'r');
plot(plot_spikes, plot_filt(plot_spikes),'ro');
xlim(xx);ylim(yy);hold off;
end
 