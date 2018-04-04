function spikeThresholdUpdateGUI(disttreshfig,norm_detectedSpikeCandidates,spikeWaveforms)
global squiggles
global spikes

squiggles = norm_detectedSpikeCandidates;
spikes = spikeWaveforms;

% set(suspect_ls(suspect),'color',[0 0 0])
ax_hist = findobj(disttreshfig,'Tag','hist');
ax_detect = findobj(disttreshfig,'Tag','detect');

ax_hist.ButtonDownFcn = @updateSpikeThreshold;
ax_detect.ButtonDownFcn = @runDetectionWithNewTemplate;

updateSpikeThreshold(ax_hist,[])
end

function updateSpikeThreshold(hObject,eventdata)
global vars 
global squiggles
global spikes

disttreshfig = get(hObject,'parent');
if ~isempty(eventdata) && hObject==eventdata.Source
    vars.Distance_threshold = hObject.CurrentPoint(1);
end
    
ax_main = findobj(disttreshfig,'Tag','main');
ax_hist = findobj(disttreshfig,'Tag','hist');
ax_detect = findobj(disttreshfig,'Tag','detect');
ax_detect_patch = findobj(disttreshfig,'Tag','detect_patch');

title(ax_main,'When done, close window')

ax_fltrd_suspect = findobj(disttreshfig,'Tag','fltrd_suspect');
ax_unfltrd_suspect = findobj(disttreshfig,'Tag' ,'unfltrd_suspect');
ax_fltrd_notsuspect = findobj(disttreshfig,'Tag','fltrd_notsuspect');
ax_unfltrd_notsuspect = findobj(disttreshfig,'Tag','unfltrd_notsuspect');

suspect_ls = findobj(ax_detect,'Tag','squiggles'); suspect_ls = flipud(suspect_ls);
suspect_dots = findobj(ax_main,'Tag','dots'); suspect_dots = flipud(suspect_dots);
suspectUF_ls = findobj(ax_detect_patch,'Tag','spikes'); suspectUF_ls = flipud(suspectUF_ls);

thresh_l = findobj(ax_hist,'tag','threshold');
thresh_l.XData = vars.Distance_threshold*[1 1];

threshidx = findobj(ax_hist,'tag','distance_hist'); threshidx = threshidx.UserData; threshidx = threshidx(:)';
suspect = threshidx<vars.Distance_threshold;

set(suspect_ls(suspect),'color',[0 0 0])
set(suspect_ls(~suspect),'color',[1 0 0])
set(suspect_dots(suspect),'color',[0 0 0],'linewidth',.5)
set(suspect_dots(~suspect),'color',[1 0 0],'linewidth',2)
set(suspectUF_ls(suspect),'color',[0 0 0])
set(suspectUF_ls(~suspect),'color',[1 0 0])

meanspike = findobj(ax_detect_patch,'color',[0 .7 1]);
meansquiggle = findobj(ax_detect,'color',[0 .7 1]);

cla(ax_fltrd_suspect)
if any(suspect)
    plot(ax_fltrd_suspect,meansquiggle.XData,squiggles(:,suspect),'tag','squiggles_suspect','color',[0 0 0]);
    % ax_fltrd_suspect.YLim = ax_detect.YLim;
    % hold(ax_fltrd_suspect,'on');
    text(ax_fltrd_suspect,...
        ax_fltrd_suspect.XLim(1)+0.05*diff(ax_fltrd_suspect.XLim),...
        ax_fltrd_suspect.YLim(2)-0.05*diff(ax_fltrd_suspect.YLim),...
        sprintf('%d Spikes',sum(suspect)),'color',[.1 .4 .8]);
    %hold(ax_fltrd_suspect,'off');
end

cla(ax_unfltrd_suspect)
if any(suspect)
    plot(ax_unfltrd_suspect,meanspike.XData,spikes(:,suspect),'tag','spikes_suspect','color',[0 0 0]);
    ax_unfltrd_suspect.YLim = ax_detect_patch.YLim;
end

cla(ax_fltrd_notsuspect)
if any(~suspect)
    plot(ax_fltrd_notsuspect,meansquiggle.XData,squiggles(:,~suspect),'tag','squiggles_notsuspect','color',[1 0 0]);
end
ax_fltrd_notsuspect.YLim = ax_detect.YLim;

cla(ax_unfltrd_notsuspect)
if any(~suspect)
    plot(ax_unfltrd_notsuspect,meanspike.XData,spikes(:,~suspect),'tag','spikes_notsuspect','color',[1 0 0]);
end
ax_unfltrd_notsuspect.YLim = ax_detect_patch.YLim;

meanspike.YData = smooth(mean(spikes(:,suspect),2));
spikeWaveform_ = smooth(diff(meanspike.YData));
spikeWaveform_ = smooth(diff(spikeWaveform_));
spikediffdiff = findobj(ax_detect_patch,'color',[0 .8 .4]);
spikediffdiff.YData = spikeWaveform_/max(spikeWaveform_)*max(meanspike.YData);

meansquiggle = findobj(ax_detect,'tag','potential_template');
if any(suspect)
    meansquiggle.YData = mean(squiggles(:,suspect),2);
else
    meansquiggle.YData = mean(squiggles,2);
end

end

function runDetectionWithNewTemplate(hObject,eventdata)
global vars 

disttreshfig = get(hObject,'parent');

ax_main = findobj(disttreshfig,'Tag','main');
ax_filtered = findobj(disttreshfig,'Tag','filtered');
ax_hist = findobj(disttreshfig,'Tag','hist');
ax_detect = findobj(disttreshfig,'Tag','detect');
ax_detect_patch = findobj(disttreshfig,'Tag','detect_patch');

suspect_ls = findobj(ax_detect,'Tag','squiggles'); suspect_ls = flipud(suspect_ls);
suspect_dots = findobj(ax_main,'Tag','dots'); suspect_dots = flipud(suspect_dots);
suspectUF_ls = findobj(ax_detect_patch,'Tag','spikes'); suspectUF_ls = flipud(suspectUF_ls);
all_filtered_data = findobj(ax_filtered,'Tag','filtered_data'); all_filtered_data = all_filtered_data.YData;

if length(suspect_dots)==1
    spike_locs = get(suspect_dots,'XData')-get(suspect_dots(1),'userdata');
else
    spike_locs = cell2mat(get(suspect_dots,'XData'))-get(suspect_dots(1),'userdata');
end
spike_locs = unique(spike_locs);
targetSpikeDist = zeros(size(spike_locs));

meansquiggle = findobj(ax_detect,'tag','potential_template');
initsquiggle = findobj(ax_detect,'tag','initial_template');
spikeTemplate = meansquiggle.YData;
initsquiggle.YData = spikeTemplate;

norm_spikeTemplate = (spikeTemplate-min(spikeTemplate))/(max(spikeTemplate)-min(spikeTemplate));

%window = (max(spike_locs(i)-floor(spike_params.spikeTemplateWidth/2),0)+1: min(spike_locs(i)+floor(spike_params.spikeTemplateWidth/2),length(all_filtered_data)))
% Should have gotten rid of spikes near the beginning or end of the data
window = -floor(vars.spikeTemplateWidth/2): floor(vars.spikeTemplateWidth/2);

for i=1:length(spike_locs)
    
    if min(spike_locs(i)+vars.spikeTemplateWidth/2,length(all_filtered_data)) - max(spike_locs(i)-vars.spikeTemplateWidth/2,0)< vars.spikeTemplateWidth
        continue
    else
        curSpikeTarget = all_filtered_data(spike_locs(i)+window);
        norm_curSpikeTarget = (curSpikeTarget-min(curSpikeTarget))/(max(curSpikeTarget)-min(curSpikeTarget));
        [targetSpikeDist(i), ~,~] = dtw_WarpingDistance(norm_curSpikeTarget, norm_spikeTemplate);
    end
end

hist = findobj(ax_hist,'Tag','distance_hist');
hist.XData = sort(targetSpikeDist);
hist.UserData = targetSpikeDist;

vars.spikeTemplate = spikeTemplate;
vars.locs = spike_locs;

updateSpikeThreshold(ax_hist,eventdata)
end
