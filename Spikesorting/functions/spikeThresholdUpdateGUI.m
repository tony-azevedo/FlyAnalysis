function spikeThresholdUpdateGUI(disttreshfig,norm_detectedSpikeCandidates,spikeWaveforms)
global squiggles
global spikes
clear GLOBAL goodspikeamp

squiggles = norm_detectedSpikeCandidates;
spikes = spikeWaveforms;

ax_main = findobj(disttreshfig,'Tag','main');
ax_hist = findobj(disttreshfig,'Tag','hist');
ax_detect = findobj(disttreshfig,'Tag','detect');

distthresh_l = findobj(ax_hist,'tag','dist_threshold');
ampthresh_l = findobj(ax_hist,'tag','amp_threshold');
distthresh_l.Color = [0 1 1];

ax_hist.ButtonDownFcn = @updateSpikeThreshold;
ax_detect.ButtonDownFcn = @runDetectionWithNewTemplate;

title(ax_main,'When done, hit a button')

title(ax_hist,'Click to change distance threshold (X-axis)');
updateSpikeThreshold(ax_hist,[])

while ~waitforbuttonpress;end

distthresh_l.Color = [1 0 0];
ampthresh_l.Color = [0 1 1];

ax_hist.ButtonDownFcn = @updateAmpThreshold;
ax_detect.ButtonDownFcn = [];

title(ax_hist,'Click to change amplitude threshold (Y-axis)');
title(ax_detect,'');

updateAmpThreshold(ax_hist,[])
while ~waitforbuttonpress;end

end

function updateSpikeThreshold(hObject,eventdata)
global vars 

if ~isempty(eventdata) && hObject==eventdata.Source
    vars.Distance_threshold = hObject.CurrentPoint(1);
end

updatePanels(hObject,[])
end

function updateAmpThreshold(hObject,eventdata)
global vars 
global goodspikeamp
if isempty(goodspikeamp)
    error('No goodspikeamp');
end

if ~isempty(eventdata) && hObject==eventdata.Source
    vars.Amplitude_threshold = hObject.CurrentPoint(1,2)/goodspikeamp;
end

updatePanels(hObject,[])
end


function updatePanels(hObject,~)

global vars 
global squiggles
global spikes
global goodspikeamp

disttreshfig = get(hObject,'parent');

ax_main = findobj(disttreshfig,'Tag','main');
ax_hist = findobj(disttreshfig,'Tag','hist');
ax_detect = findobj(disttreshfig,'Tag','detect');
ax_detect_patch = findobj(disttreshfig,'Tag','detect_patch');

ax_fltrd_suspect = findobj(disttreshfig,'Tag','fltrd_suspect');
ax_unfltrd_suspect = findobj(disttreshfig,'Tag' ,'unfltrd_suspect');
ax_fltrd_notsuspect = findobj(disttreshfig,'Tag','fltrd_notsuspect');
ax_unfltrd_notsuspect = findobj(disttreshfig,'Tag','unfltrd_notsuspect');

suspectUF_avel = findobj(ax_detect_patch,'tag','goodspike','linewidth',2);
if isempty(goodspikeamp)
    goodspikeamp = suspectUF_avel.UserData;
end

distthresh_l = findobj(ax_hist,'tag','dist_threshold');
distthresh_l.XData = vars.Distance_threshold*[1 1];
ampthresh_l = findobj(ax_hist,'tag','amp_threshold');
ampthresh_l.YData = vars.Amplitude_threshold*goodspikeamp*[1 1];

threshidx = findobj(ax_hist,'tag','distance_hist'); threshidx = threshidx.UserData; %threshidx = threshidx(:)';

%%
suspect = threshidx(:,1)<vars.Distance_threshold & threshidx(:,2) > vars.Amplitude_threshold*goodspikeamp;
targetSpikeDist = threshidx(:,1);
spikeAmplitude = threshidx(:,2);

weird = targetSpikeDist<vars.Distance_threshold & ...
    targetSpikeDist>quantile(targetSpikeDist(targetSpikeDist<vars.Distance_threshold),0.85) &...
    spikeAmplitude > goodspikeamp*vars.Amplitude_threshold;
good = targetSpikeDist<quantile(targetSpikeDist(targetSpikeDist<vars.Distance_threshold),0.2) &...
    spikeAmplitude > goodspikeamp*vars.Amplitude_threshold;
weirdbad = (targetSpikeDist>vars.Distance_threshold & ...
    targetSpikeDist<2*quantile(targetSpikeDist(targetSpikeDist<vars.Distance_threshold),0.85)) | ...
    (spikeAmplitude <= goodspikeamp*vars.Amplitude_threshold & ...
    spikeAmplitude > 0);
bad = targetSpikeDist>vars.Distance_threshold &...
    spikeAmplitude < goodspikeamp*vars.Amplitude_threshold;

%% Redraw the criteria based on new thresholds

hist_dots_out = findobj(hObject,'tag','distance_hist_out');
hist_dots_in = findobj(hObject,'tag','distance_hist');

selectcriteria = hist_dots_in.UserData;
sDs = selectcriteria(:,1);
amps = selectcriteria(:,2);

delete(hist_dots_out);
delete(hist_dots_in);

hist_dots_out = plot(ax_hist,sDs(~suspect),amps(~suspect),...
    '.','color',[0.9290 0.6940 0.1250],'markersize',10,'tag','distance_hist_out'); 
hold(ax_hist,'on');
hist_dots_in = plot(ax_hist,sDs(suspect),amps(suspect),...
    '.','color',[.0 .45 .74],'markersize',10,'tag','distance_hist'); 
hist_dots_in.UserData = selectcriteria;
uistack([hist_dots_out hist_dots_in],'bottom')

xlims = ampthresh_l.XData+[-1 1]*.1*diff(ampthresh_l.XData);
xlims = [xlims(1) max([xlims(2) distthresh_l.XData(2)*1.1])];
ylims = distthresh_l.YData+[-1 1]*.1*diff(distthresh_l.YData);
ylims = [min([ylims(1), ampthresh_l.YData(1)-0.1*diff([ampthresh_l.YData(1) max(distthresh_l.YData)])]) ylims(2)];
xlim(ax_hist,xlims);
ylim(ax_hist,ylims);

%%

suspect_ticks = findobj(ax_main,'Tag','ticks'); suspect_ticks = flipud(suspect_ticks);

set(suspect_ticks(suspect),'color',[0 0 0],'linewidth',1)
set(suspect_ticks(~suspect),'color',[1 0 0],'linewidth',.5)

meanspike = findobj(ax_detect_patch,'tag','goodspike');
meansquiggle = findobj(ax_detect,'tag','potential_template');

goodsquiggles = findobj(ax_detect,'Tag','squiggles'); window = goodsquiggles(1).XData; delete(goodsquiggles);
weirdsquiggles = findobj(ax_detect,'Tag','weirdsquiggles'); delete(weirdsquiggles);
goodspikes = findobj(ax_detect_patch,'Tag','spikes'); spikewindow = goodspikes(1).XData; delete(goodspikes);
weirdspikes = findobj(ax_detect_patch,'Tag','weirdspikes'); delete(weirdspikes);

goodsquiggles = plot(ax_detect,window,squiggles(:,good),'tag','squiggles','Color',[.8 .8 .8]);
weirdSuspectSquiggles = plot(ax_detect,window,squiggles(:,weird),'tag','weirdsquiggles','Color',[0 0 0]);
uistack(weirdSuspectSquiggles,'bottom')
uistack(goodsquiggles,'bottom')

goodspikes = plot(ax_detect_patch,spikewindow,spikes(:,good),'color',[.8 .8 .8],'tag','spikes');
weirdspikes = plot(ax_detect_patch,spikewindow,spikes(:,weird),'color',[0 0 0],'tag','weirdspikes');
uistack(weirdspikes,'bottom')
uistack(goodspikes,'bottom')


cla(ax_fltrd_suspect)
if any(suspect)
    plot(ax_fltrd_suspect,meansquiggle.XData,squiggles(:,good),'tag','squiggles_suspect','color',[0.8 0.8 0.8]);
    plot(ax_fltrd_suspect,meansquiggle.XData,squiggles(:,weird),'tag','squiggles_suspect','color',[0 0 0]);
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
    plot(ax_unfltrd_suspect,meanspike.XData,spikes(:,good),'tag','spikes_suspect','color',[0.8 0.8 0.8]);
    plot(ax_unfltrd_suspect,meanspike.XData,spikes(:,weird),'tag','spikes_suspect','color',[0 0 0]);
    ax_unfltrd_suspect.YLim = ax_detect_patch.YLim;
end

cla(ax_fltrd_notsuspect)
if any(bad)
    plot(ax_fltrd_notsuspect,meansquiggle.XData,squiggles(:,bad),'tag','squiggles_notsuspect','color',[1 .7 .7]);
end
if any(weirdbad)
    plot(ax_fltrd_notsuspect,meansquiggle.XData,squiggles(:,weirdbad),'tag','squiggles_notsuspect','color',[.7 0 0]);
end
ax_fltrd_notsuspect.YLim = ax_detect.YLim;

cla(ax_unfltrd_notsuspect)
if any(bad)
    plot(ax_unfltrd_notsuspect,meanspike.XData,spikes(:,bad),'tag','spikes_notsuspect','color',[1 .7 .7]);
end
if any(weirdbad)
    plot(ax_unfltrd_notsuspect,meanspike.XData,spikes(:,weirdbad),'tag','spikes_notsuspect','color',[.7 0 0]);
end
ax_unfltrd_notsuspect.YLim = ax_detect_patch.YLim;


meanspike.YData = smooth(mean(spikes(:,suspect),2));
spikeWaveform_ = smooth(diff(meanspike.YData),vars.fs/2000);
spikeWaveform_ = smooth(diff(spikeWaveform_),vars.fs/2000);
spikediffdiff = findobj(ax_detect_patch,'color',[0 .8 .4]);
smthwnd = (vars.fs/2000+1:length(meanspike.YData)-vars.fs/2000);
spikediffdiff.YData = spikeWaveform_(smthwnd(2:end-1))/max(spikeWaveform_(smthwnd(2:end-1)))*max(meanspike.YData);

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
suspect_ticks = findobj(ax_main,'Tag','ticks'); suspect_ticks = flipud(suspect_ticks);
suspectUF_ls = findobj(ax_detect_patch,'Tag','spikes'); suspectUF_ls = flipud(suspectUF_ls);
all_filtered_data = findobj(ax_filtered,'Tag','filtered_data'); all_filtered_data = all_filtered_data.YData;

hist = findobj(ax_hist,'Tag','distance_hist');
selectcriteria = hist.UserData;
spike_locs = selectcriteria(:,3);
targetSpikeDist = selectcriteria(:,1);

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
hist.XData = targetSpikeDist;

selectcriteria(:,1) = targetSpikeDist;
hist.UserData = selectcriteria;

vars.spikeTemplate = spikeTemplate;

updateSpikeThreshold(ax_hist,eventdata)
end
