% Rachel Meeting 130918


%% 130917 F1_C1
close all
stem = ['C:\Users\Anthony Azevedo\Raw_Data\130917\130917_F1_C1\PiezoSine_Raw_130917_F1_C1_6'];
[handles.currentPrtcl,d,fly,cell,trial,handles.dir] = extractRawIdentifiers(stem);
handles.prtclData =

for t = 6:25
    trial = load([handles.dir handles.currentPrtcl '_Raw_' d '_' fly '_' cell '_' num2str(t)]);
    handles.params = trial.params;
    h(t) = 
end


dim = [5,3];
hlayout = reshape(h(:),fliplr(dim))';

fig = layout(hlayout,[d ' ' fly ' ' cell ': ' prot ' - Rest']);

%% Other way to do this: run the Average loop for each trial, the run this

h = findobj('tag','AverageLikeSines','type','figure');
h = sort(h);
h = reshape(h,4,5)'

fig = layout(h,[d ' ' fly ' ' cell ' (VT45599): ' prot ' - Rest']);

%%
h = findobj('tag','AverageLikeSteps','type','figure');
h = sort(h);
h = reshape(h,3,2)'

fig = layout(h,[d ' ' fly ' ' cell ' (VT45599): ' prot ' - Rest'],'close');

%% 130917 F1_C1
close all, clear h
stem = ['C:\Users\Anthony Azevedo\Raw_Data\130917\130917_F1_C1\PiezoSine_Raw_130917_F1_C1_1'];
[prot,d,fly,cell,trial,D] = extractRawIdentifiers(stem);
for st = 46:60
    trials = [st:15:90];
    
    h(trials(1)) = figure(100+trials(1));
    
    ax = subplot(3,1,[1 2],'parent',h(trials(1)));
    trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(1))]);
    x = makeTime(trial.params);
    voltage = zeros(length(x),length(trials));
    for t = 1:length(trials)
        trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(t))]);
        voltage(:,t) = trial.voltage;
    end
    plot(ax,x,voltage,'color',[1, .7 .7]); hold on
    plot(ax,x,mean(voltage,2),'color',[.7 0 0]);
    
    xlim([-.1 .45])
    ylim([-100 10])
    
    %title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
    box(ax,'off'); 
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        ylabel(ax,'mV')
    end
    
    ax = subplot(3,1,3,'parent',h(trials(1)));
    plot(ax,x,trial.sgsmonitor,'color',[0 0 1]); hold on;
    text(-.1,5.2,[num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'],'fontsize',7)

    box(ax,'off');     
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        xlabel(ax,'s')
        ylabel(ax,'V')
    end
    xlim([-.1 .45])
    ylim([4.5 5.5])

end
h = h(h>0);

fig = figure(1);
set(fig,'Color','white','PaperPosition',[0.25,0.25 8, 10.5]);
dim = [5,3];
hlayout = reshape(h(:),fliplr(dim))';
margins = 0;
for y = 1:dim(1)
    for x = 1:dim(2)
        panels(y,x) = uipanel('parent',fig,'BorderType','none','BackgroundColor','white',...
            'position',[(x-1)*1/dim(2) (y-1)*1/dim(1) 1/dim(2) 1/dim(1)]);
    end
end
panels = flipud(panels);
for y = 1:dim(1)
    for x = 1:dim(2)
        set(get(hlayout(y,x),'children'),'parent',panels(y,x))
    end
end

set(panels(1),'title',[d ' ' fly ' ' cell ': Hyperpolarized'])

%% 130917 F1_C1
close all, clear h
stem = ['C:\Users\Anthony Azevedo\Raw_Data\130916\130916_F2_C1\PiezoSine_Raw_130916_F2_C1_1'];
[prot,d,fly,cell,trial,D] = extractRawIdentifiers(stem);
for st = 1:15
    trials = [st:15:45];
    
    h(trials(1)) = figure(100+trials(1));
    
    ax = subplot(3,1,[1 2],'parent',h(trials(1)));
    trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(1))]);
    x = makeTime(trial.params);
    voltage = zeros(length(x),length(trials));
    for t = 1:length(trials)
        trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(t))]);
        voltage(:,t) = trial.voltage;
    end
    plot(ax,x,voltage,'color',[1, .7 .7]); hold on
    plot(ax,x,mean(voltage,2),'color',[.7 0 0]);
    
    xlim([-.1 .45])
    ylim([-43 -33])
    
    %title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
    box(ax,'off'); 
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        ylabel(ax,'mV')
    end
    
    ax = subplot(3,1,3,'parent',h(trials(1)));
    plot(ax,x,trial.sgsmonitor,'color',[0 0 1]); hold on;
    text(-.1,5.2,[num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'],'fontsize',7)

    box(ax,'off');     
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        xlabel(ax,'s')
        ylabel(ax,'V')
    end
    xlim([-.1 .45])
    ylim([4.5 5.5])

end
h = h(h>0);

fig = figure(1);
set(fig,'Color','white','PaperPosition',[0.25,0.25 8, 10.5]);
dim = [5,3];
hlayout = reshape(h(:),fliplr(dim))';
margins = 0;
for y = 1:dim(1)
    for x = 1:dim(2)
        panels(y,x) = uipanel('parent',fig,'BorderType','none','BackgroundColor','white',...
            'position',[(x-1)*1/dim(2) (y-1)*1/dim(1) 1/dim(2) 1/dim(1)]);
    end
end
panels = flipud(panels);
for y = 1:dim(1)
    for x = 1:dim(2)
        set(get(hlayout(y,x),'children'),'parent',panels(y,x))
    end
end

set(panels(1),'title',[d ' ' fly ' ' cell ': Rest'])

%% 130917 F1_C1
close all, clear h
stem = ['C:\Users\Anthony Azevedo\Raw_Data\130916\130916_F2_C1\PiezoSine_Raw_130916_F2_C1_1'];
[prot,d,fly,cell,trial,D] = extractRawIdentifiers(stem);
for st = 46:60
    trials = [st:15:90];
    
    h(trials(1)) = figure(100+trials(1));
    
    ax = subplot(3,1,[1 2],'parent',h(trials(1)));
    trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(1))]);
    x = makeTime(trial.params);
    voltage = zeros(length(x),length(trials));
    for t = 1:length(trials)
        trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(t))]);
        voltage(:,t) = trial.voltage;
    end
    plot(ax,x,voltage,'color',[1, .7 .7]); hold on
    plot(ax,x,mean(voltage,2),'color',[.7 0 0]);
    
    xlim([-.1 .45])
    ylim([-100 10])
    
    %title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
    box(ax,'off'); 
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        ylabel(ax,'mV')
    end
    
    ax = subplot(3,1,3,'parent',h(trials(1)));
    plot(ax,x,trial.sgsmonitor,'color',[0 0 1]); hold on;
    text(-.1,5.2,[num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'],'fontsize',7)

    box(ax,'off');     
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        xlabel(ax,'s')
        ylabel(ax,'V')
    end
    xlim([-.1 .45])
    ylim([4.5 5.5])

end
h = h(h>0);

fig = figure(1);
set(fig,'Color','white','PaperPosition',[0.25,0.25 8, 10.5]);
dim = [5,3];
hlayout = reshape(h(:),fliplr(dim))';
margins = 0;
for y = 1:dim(1)
    for x = 1:dim(2)
        panels(y,x) = uipanel('parent',fig,'BorderType','none','BackgroundColor','white',...
            'position',[(x-1)*1/dim(2) (y-1)*1/dim(1) 1/dim(2) 1/dim(1)]);
    end
end
panels = flipud(panels);
for y = 1:dim(1)
    for x = 1:dim(2)
        set(get(hlayout(y,x),'children'),'parent',panels(y,x))
    end
end

set(panels(1),'title',[d ' ' fly ' ' cell ': Hyperpolarized'])


%% 130917 F1_C1
close all, clear h
stem = ['C:\Users\Anthony Azevedo\Raw_Data\130916\130916_F1_C1\PiezoSine_Raw_130916_F1_C1_1'];
[prot,d,fly,cell,trial,D] = extractRawIdentifiers(stem);
for st = 1:15
    trials = [st:15:45];
    
    h(trials(1)) = figure(100+trials(1));
    
    ax = subplot(3,1,[1 2],'parent',h(trials(1)));
    trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(1))]);
    x = makeTime(trial.params);
    voltage = zeros(length(x),length(trials));
    for t = 1:length(trials)
        trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(t))]);
        voltage(:,t) = trial.voltage;
    end
    plot(ax,x,voltage,'color',[1, .7 .7]); hold on
    plot(ax,x,mean(voltage,2),'color',[.7 0 0]);
    
    xlim([-.1 .45])
    ylim([-43 -33])
    
    %title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
    box(ax,'off'); 
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        ylabel(ax,'mV')
    end
    
    ax = subplot(3,1,3,'parent',h(trials(1)));
    plot(ax,x,trial.sgsmonitor,'color',[0 0 1]); hold on;
    text(-.1,5.2,[num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'],'fontsize',7)

    box(ax,'off');     
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        xlabel(ax,'s')
        ylabel(ax,'V')
    end
    xlim([-.1 .45])
    ylim([4.5 5.5])

end
h = h(h>0);

fig = figure(1);
set(fig,'Color','white','PaperPosition',[0.25,0.25 8, 10.5]);
dim = [5,3];
hlayout = reshape(h(:),fliplr(dim))';
margins = 0;
for y = 1:dim(1)
    for x = 1:dim(2)
        panels(y,x) = uipanel('parent',fig,'BorderType','none','BackgroundColor','white',...
            'position',[(x-1)*1/dim(2) (y-1)*1/dim(1) 1/dim(2) 1/dim(1)]);
    end
end
panels = flipud(panels);
for y = 1:dim(1)
    for x = 1:dim(2)
        set(get(hlayout(y,x),'children'),'parent',panels(y,x))
    end
end

set(panels(1),'title',[d ' ' fly ' ' cell ': Rest'])

%% 130917 F1_C1
close all, clear h
stem = ['C:\Users\Anthony Azevedo\Raw_Data\130916\130916_F1_C1\PiezoSine_Raw_130916_F1_C1_1'];
[prot,d,fly,cell,trial,D] = extractRawIdentifiers(stem);
for st = 46:60
    trials = [st:15:90];
    
    h(trials(1)) = figure(100+trials(1));
    
    ax = subplot(3,1,[1 2],'parent',h(trials(1)));
    trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(1))]);
    x = makeTime(trial.params);
    voltage = zeros(length(x),length(trials));
    for t = 1:length(trials)
        trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(t))]);
        voltage(:,t) = trial.voltage;
    end
    plot(ax,x,voltage,'color',[1, .7 .7]); hold on
    plot(ax,x,mean(voltage,2),'color',[.7 0 0]);
    
    xlim([-.1 .45])
    ylim([-100 10])
    
    %title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
    box(ax,'off'); 
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        ylabel(ax,'mV')
    end
    
    ax = subplot(3,1,3,'parent',h(trials(1)));
    plot(ax,x,trial.sgsmonitor,'color',[0 0 1]); hold on;
    text(-.1,5.2,[num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'],'fontsize',7)

    box(ax,'off');     
    set(ax,'TickDir','out');
    if st ~= 60
        set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
        set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
    else
        xlabel(ax,'s')
        ylabel(ax,'V')
    end
    xlim([-.1 .45])
    ylim([4.5 5.5])

end
h = h(h>0);

fig = figure(1);
set(fig,'Color','white','PaperPosition',[0.25,0.25 8, 10.5]);
dim = [5,3];
hlayout = reshape(h(:),fliplr(dim))';
margins = 0;
for y = 1:dim(1)
    for x = 1:dim(2)
        panels(y,x) = uipanel('parent',fig,'BorderType','none','BackgroundColor','white',...
            'position',[(x-1)*1/dim(2) (y-1)*1/dim(1) 1/dim(2) 1/dim(1)]);
    end
end
panels = flipud(panels);
for y = 1:dim(1)
    for x = 1:dim(2)
        set(get(hlayout(y,x),'children'),'parent',panels(y,x))
    end
end

set(panels(1),'title',[d ' ' fly ' ' cell ': Hyperpolarized'])


%% 130917 F1_C1
close all, clear h
stem = ['C:\Users\Anthony Azevedo\Raw_Data\130916\130916_F2_C1\PiezoSine_Raw_130916_F2_C1_1'];
[prot,d,fly,cell,trial,D] = extractRawIdentifiers(stem);
trials = [124:136];

h(trials(1)) = figure(100+trials(1));

ax = subplot(3,1,[1 2],'parent',h(trials(1)));
trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(1))]);
x = makeTime(trial.params);
voltage = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(t))]);
    voltage(:,t) = trial.voltage;
end
plot(ax,x,voltage,'color',[1, .7 .7]); hold on
plot(ax,x,mean(voltage,2),'color',[.7 0 0]);

xlim([-.1 .45])
ylim([-43 -33])

%title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
box(ax,'off');
set(ax,'TickDir','out');
if st ~= 60
    set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
else
    ylabel(ax,'mV')
end

ax = subplot(3,1,3,'parent',h(trials(1)));
plot(ax,x,trial.sgsmonitor,'color',[0 0 1]); hold on;
text(-.1,5.2,[num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'],'fontsize',7)

box(ax,'off');
set(ax,'TickDir','out');
if st ~= 60
    set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
    set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
else
    xlabel(ax,'s')
    ylabel(ax,'V')
end
xlim([-.1 .45])
ylim([4.5 5.5])

h = h(h>0);
%%
fig = figure(1);
set(fig,'Color','white','PaperPosition',[0.25,0.25 8, 10.5]);
dim = [5,3];
hlayout = reshape(h(:),fliplr(dim))';
margins = 0;
for y = 1:dim(1)
    for x = 1:dim(2)
        panels(y,x) = uipanel('parent',fig,'BorderType','none','BackgroundColor','white',...
            'position',[(x-1)*1/dim(2) (y-1)*1/dim(1) 1/dim(2) 1/dim(1)]);
    end
end
panels = flipud(panels);
for y = 1:dim(1)
    for x = 1:dim(2)
        set(get(hlayout(y,x),'children'),'parent',panels(y,x))
    end
end

set(panels(1),'title',[d ' ' fly ' ' cell ': Hyperpolarized'])
