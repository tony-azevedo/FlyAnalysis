%% Simple GUI for spike detection. Last updated 05_17_2017 by JCT
function filter_sliderGUI(unfiltered_data, spikeTemplateWidth)
global hp_filter_Slider;global lp_filter_Slider;global threshold_Slider; global diff_Slider; %Define these to be global so subfunction can see sliders and button
global vars;
global patchax
global filtax

vars.unfiltered_data = unfiltered_data;
thresh_pos = 840;
lp_pos = 420;
hp_pos = 20;

vars.filtered_data = filterDataWithSpikes(vars);

if ~isfield(vars,'peak_threshold');vars.peak_threshold = 5;end %%initial threshold for finding peaks
[locks, ~] = peakfinder(vars.filtered_data,mean(vars.filtered_data)+vars.peak_threshold *std(vars.filtered_data));%% slightly different algorithm;  [peakLoc] = peakfinder(x0,sel,thresh) returns the indicies of local maxima that are at least sel above surrounding vars.filtered_data and larger (smaller) than thresh if you are finding maxima (minima).
loccs = locks((locks> spikeTemplateWidth)); %%to prevent strange happenings, make sure that spikes do not occur right at the edges
vars.locs = loccs(loccs < (length(vars.filtered_data)-spikeTemplateWidth));

% Make a figure
fig = figure('position',[100 100 1200 900], 'NumberTitle', 'off', 'color', 'w');

patchax = axes(fig,'units','normalized','position',[0.1300 0.8500 0.7750 0.1]);
plot(patchax,(1:vars.len),unfiltered_data(1:vars.len),'color',[0.8500    0.3250    0.0980]);
ticks = raster(patchax,vars.locs,max(unfiltered_data(1:vars.len))+.02*diff([max(unfiltered_data(1:vars.len)),min(unfiltered_data(1:vars.len))]));
set(ticks,'tag','ticks');
title(patchax,'select filter params and threshold, then close window');  

filtax = axes(fig,'units','normalized','position',[0.1300 0.1100 0.7750 0.7150]);
set(fig,'toolbar','figure');
% Just some descriptive text.

uicontrol('Parent', fig,'Style', 'text', 'String', {'hp cutoff','(hz)'}, 'Position', [hp_pos 20 90 30]);
uicontrol('Parent', fig,'Style', 'text', 'String', {'lp cutoff','(hz)'}, 'Position', [lp_pos 20 90 30]);
uicontrol('Parent', fig,'Style', 'text', 'String', {'peakthreshold','(au)'}, 'Position', [thresh_pos 20 90 30]);
uicontrol('Parent', fig,'Style', 'text', 'String', {'derivative (0-2)'}, 'Position', [hp_pos 140 90 20]);

% plot_unfilt = 2+2*(vars.unfiltered_data(1:vars.len)'-mean(vars.unfiltered_data(1:vars.len)))/max(abs(vars.unfiltered_data(1:vars.len)));
plot_filt = (vars.filtered_data(1:vars.len)-mean(vars.filtered_data))/max(vars.filtered_data);
plot_spikes = vars.locs(vars.locs<vars.len);
plot_thresh = (vars.peak_threshold *std(vars.filtered_data)-mean(vars.filtered_data))/max(vars.filtered_data);

hold(filtax,'off');
axes(filtax);
plot(filtax,plot_spikes, plot_filt(plot_spikes),'ro');hold on;
plot(filtax,plot_filt,'k');hold on;
plot(filtax,[1 vars.len],max(plot_filt)-[plot_thresh plot_thresh],'--','color',[.8 .8 .8]);%% uncomment to plot piezo signal or another channel

% ylim(filtax,[-1 1]);

hp_filter_Slider = uicontrol('Parent', fig,'Style','slider','Min',0.5,'Max',1000,...
                'SliderStep',[0.001 0.1],'Value',vars.hp_cutoff,...
                'Position',[hp_pos+100 20 200 30], 'Callback', @filter_GUI);
                vars.hp_cutoff = get(hp_filter_Slider,'Value');
                
lp_filter_Slider = uicontrol('Parent', fig,'Style','slider','Min',0.11,'Max',1000,...
                'SliderStep',[0.001 0.1],'Value',vars.lp_cutoff,...
                'Position',[lp_pos+100 20 200 30], 'Callback', @filter_GUI);
                 vars.lp_cutoff = get(lp_filter_Slider,'Value');
   
threshold_Slider = uicontrol('Parent', fig,'Style','slider','Min',1,'Max',20,...
                'SliderStep',[0.002 0.2],'Value',vars.peak_threshold,...
                'Position',[thresh_pos+100 20 200 30], 'Callback', @filter_GUI);
                 vars.peak_threshold = get(threshold_Slider,'Value');
        
                 %% a slider to select first or second derivative
diff_Slider = uicontrol('Parent', fig,'Style','slider','Min',0,'Max',2,...
                'SliderStep',[0.5 0.5],'Value',round(vars.diff),...
                'Position',[hp_pos+20 100 50 30], 'Callback', @filter_GUI);
                 vars.diff = round(get(diff_Slider,'Value'));
                    
                 
 % Puts the value of the peak_thresholdeter on the GUI.
uicontrol('Parent', fig,'Tag','HP_cutoff','Style', 'text', 'String', num2str(vars.hp_cutoff),'Position', [hp_pos+300 20 60 20]);
uicontrol('Parent', fig,'Tag','LP_cutoff','Style', 'text', 'String', num2str(vars.lp_cutoff),'Position', [lp_pos+300 20 60 20]);
uicontrol('Parent', fig,'Tag','PEAK_threshold','Style', 'text', 'String', num2str(vars.peak_threshold),'Position', [thresh_pos+300 20 60 20]);
uicontrol('Parent', fig,'Tag','DIFF','Style', 'text', 'String', num2str(vars.diff),'Position', [hp_pos+15 75 60 20]);

% A button to reset the view
global Button;
Button = uicontrol('Style', 'pushbutton', 'String', 'Reset Axes',...
'Position', [hp_pos 250 100 30],'Callback', @filter_GUI);

filter_GUI
end
   


%% Called by GUI to do the plotting
% hObject is the button and eventdata is unused.
function filter_GUI(hObject,eventdata)
global hp_filter_Slider;global lp_filter_Slider;global threshold_Slider;global Button;global diff_Slider;%Define this to be global so subfunction can see slider
global vars;
global patchax
global filtax

% Gets the value of the peak_thresholdeter from the slider.
xx = get(filtax,'XLim'); 
yy = get(filtax,'YLim');
vars.hp_cutoff = get(hp_filter_Slider,'Value');
vars.lp_cutoff = get(lp_filter_Slider,'Value');
vars.peak_threshold = get(threshold_Slider,'Value');
vars.diff = round(get(diff_Slider,'Value'));

vars.filtered_data = filterDataWithSpikes(vars);

[locks, ~] = peakfinder(double(vars.filtered_data),mean(vars.filtered_data)+vars.peak_threshold*std(vars.filtered_data));%% slightly different algorithm;  [peakLoc] = peakfinder(x0,sel,thresh) returns the indicies of local maxima that are at least sel above surrounding vars.filtered_data and larger (smaller) than thresh if you are finding maxima (minima).
loccs = locks((locks> vars.spikeTemplateWidth)); %%to prevent strange happenings, make sure that spikes do not occur right at the edges
vars.locs = loccs(loccs < (length(vars.filtered_data)-vars.spikeTemplateWidth));

% Puts the value of the peak_thresholdeter on the GUI.
set(findobj('Tag','HP_cutoff','Style', 'text'),'String', num2str(vars.hp_cutoff))
set(findobj('Tag','LP_cutoff','Style', 'text'),'String', num2str(vars.lp_cutoff))
set(findobj('Tag','PEAK_threshold','Style', 'text'),'String', num2str(vars.peak_threshold))
set(findobj('Tag','DIFF','Style', 'text'),'String', num2str(vars.diff))

delete(findobj(patchax,'type','line','tag','ticks'));
ticks = raster(patchax,vars.locs,max(vars.unfiltered_data(1:vars.len))+.02*diff([max(vars.unfiltered_data(1:vars.len)),min(vars.unfiltered_data(1:vars.len))]));
set(ticks,'tag','ticks');

plot_filt = (vars.filtered_data(1:vars.len)-mean(vars.filtered_data))/max(vars.filtered_data);
% plot_filt = vars.filtered_data(1:vars.len);
plot_spikes = vars.locs(vars.locs<vars.len);
plot_thresh = (vars.peak_threshold *std(vars.filtered_data)-mean(vars.filtered_data))/max(vars.filtered_data);

hold(filtax,'off');
axes(filtax);
plot(filtax,plot_spikes, plot_filt(plot_spikes),'ro');hold on;
plot(filtax,plot_filt,'k');hold on;
plot(filtax,[1 vars.len],max(plot_filt)-[plot_thresh plot_thresh],'--','color',[.8 .8 .8]);%% uncomment to plot piezo signal or another channel
xlim(filtax,xx);ylim(filtax,yy);hold off;

% set(filtax,'ButtonDownFcn',@clickToPositionThresh);

button_state = get(Button,'Value');
if button_state == get(Button,'Max')
xlim(filtax,[1 length(vars.filtered_data)]);ylim(filtax,[min(plot_filt) max(plot_filt)]);hold off;
elseif button_state == get(Button,'Min')
xlim(filtax,xx);ylim(filtax,yy);hold off;
end

end
 
function clickToPositionThresh(hObject,eventdata)
global threshold_Slider
thresh = hObject.CurrentPoint(1,2);
threshold_Slider.Value = thresh;
filter_GUI(hObject,eventdata)
end