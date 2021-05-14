%% Reading a continuous file, 5000 entries at a time

% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200812_F1_C2_2_A.bin');

%% Prelim
%cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200823_F2_C1_1_A.bin');
%cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_210319_F2_C1_3_A.bin');

%% WT
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200904_F1_C1_1_A.bin');
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200915_F1_C1_1_A.bin')
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200915_F2_C1_1_A.bin')
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200918_F1_C1_1_A.bin');
cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200918_F2_C1_2_A.bin');

cdr.chooseChannels({'probe_position','arduino_output'});%,'b_0','b_128'});

%% Hot-Cell
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200907_F1_C1_8_A.bin');
cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200907_F2_C1_1_A.bin');
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200907_F3_C1_1_A.bin');
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200921_F1_C1_1_A.bin');
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200921_F2_C1_1_A.bin');
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200922_F1_C1_1_A.bin');

cdr.chooseChannels({'probe_position','arduino_output'});%,'b_0','b_128'});

%% Hot-Cell with EMGs
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_201104_F1_C1_1_A.bin');
cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_201104_F2_C1_1_A.bin');
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_201113_F1_C1_1_A.bin');
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_201113_F2_C1_1_A.bin');

cdr.chooseChannels({'probe_position','arduino_output','current_extEMG','current_2'});%,'b_0','b_128'});

%% continuous recording of trials
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_201209_F0_C0_2_A.bin');
% cdr.chooseChannels({'probe_position','arduino_output','refchan'});%,'b_0','b_128'});

cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_201215_F1_C1_1_A.bin');
cdr.chooseChannels({'arduino_output','refchan','probe_position'});%,'b_0','b_128'});

%%
cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_210319_F2_C1_3_A.bin');
cdr.chooseChannels({'arduino_output','refchan','probe_position','sgsmonitor','current_1'});%,'b_0','b_128'});

%% 
cdr.nextCookie(50);

%%
cdr.backup

%% 
% cdr.rewind

%%
cdr.ffw

%%
cdr.overview

%% 
cdr.ffwRecording(20,.00001)

%% plot histograms
fig = figure;
ax1 = subplot(2,1,1,'parent',fig); ax1.NextPlot = 'add';
ax2 = subplot(2,1,2,'parent',fig); ax1.NextPlot = 'add';
for c = 2:size(cdr.probehist,2) 
%     if sum(cdr.statecount(:,c)) < 20000
%         continue
%     end
%     if cdr.target(c)/cdr.samprate < 40
%         continue
%     end
    x = cdr.probebins(1:end-1)+diff(cdr.probebins)/2;
    y = cdr.probehist(:,c)/max(cdr.probehist(:,c));
    y2 = y;
    y2(y2==max(y2)) = 0;
    y2 = y2/max(y2);
    stairs(ax1,x, y,'color',[.7 .7 1]);
    l = stairs(ax1,x, y2,'color',[0 0 .8]);
    plot(ax1,cdr.target(2,c-1)*[1 1],[0 1],'color',[1 0 0]);
    plot(ax1,(cdr.target(2,c-1)+cdr.target(3,c-1))*[1 1],[0,1],'color',[1 0 0]);
    ax1.XLim = [min(cdr.probebins) max(cdr.probebins)];
    l = stairs(ax2,cdr.probebins(1:end-1)+diff(cdr.probebins)/2 - (cdr.target(2,c-1)+cdr.target(3,c-1)), cdr.probehist(:,c));
    pause
    delete(ax1.Children)
    if cdr.target(c)/cdr.samprate > 2500
        break
    end
end    
    
    


