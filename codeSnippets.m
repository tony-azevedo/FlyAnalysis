% Useful code snippets and scratch

%%
fig = figure(1);
ax(1) = axes('position',[0.04,0.04,0.66,0.92],'parent',fig);
title(ax1,sprintf('%s_%s',regexprep(groupstr,'_','\\_'),grouptrialstr));
    orient(fig,'landscape'); print(fig,'-depsc',get(fig,'fileName')); close all

%%
line(x,y,'parent',ax,'DisplayName',dspn,'color',[1 1 1]*0,'linestyle',ls,'marker',m,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0,'markersize',ms)

%%
trials = zeros(length(data));
for t = 1:length(trials)
    trials(t) = data(t).trial;
end

%%
text(e+1,min(ylims)+diff(ylims)*.05,sprintf('%g',e),'parent',ax(1));
%%

xlabel(ax(2),'V\_m');
ylabel(ax(2),'freq');

%% time
stim_time = ((1:data(group(1)).nsampout) - data(group(1)).stimonsamp)/data(group(1)).samprateout;
data_time = (1:data(group(1)).nsampin)/data(group(1)).sampratein - data(group(1)).stimonsamp/data(group(1)).samprateout;


%% scratch

a = dir('WCwaveform*');
if isempty(a)
    disp('No WCwaveform file')
elseif length(a)>1
    disp('Which WCwaveform file do you mean?')
else
    load(a.name)
end
clear a

%%
f = samprate/length(x)*[0:length(x)/2]; f = [f, fliplr(f(2:end-1))];

%% Preferences
 addpref('ControlOutput','Position',[0.6000   75.6154   69.6000    5.5385])
 
 % simple thresholding
 
%% guistuff
guidata(hObject,handles)
handles = guidata(hObject);