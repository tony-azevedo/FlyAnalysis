function h = EpiFlash2TTrainTibiaAngle(h,handles,savetag)

if ~isfield(handles.trial,'legPositions')
    fprintf('No leg positions\n')
    return
end

    
delete(get(h,'children'));
panl = panel(h);
panl.pack('v',{1/4 1/4 1/4 1/4})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

trial = handles.trial;
x = makeTime(trial.params);

switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end   
switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end   

% displayTrial
ax1 = panl(1).select();
line(x,trial.(invec1),'parent',ax1,'color',[1 .2 .2],'tag',savetag);
ylabel(ax1,'V_m (mV)'); %xlim([0 max(t)]);
box(ax1,'off'); set(ax1,'TickDir','out','tag','quickshow_inax'); axis(ax1,'tight');
xlim(ax1,[min(x) max(x)]);

ax2 = panl(2).select(); 
line(x,trial.(invec2),'parent',ax2,'color',[1 .2 .2],'tag',savetag);
ylabel(ax2,'I (pA)'); %xlim([0 max(t)]);
box(ax2,'off'); set(ax2,'TickDir','out','tag','quickshow_inax'); axis(ax2,'tight');
xlim(ax2,[min(x) max(x)]);


ax3 = panl(3).select();
t2 = postHocExposure(trial,max(size(trial.legPositions.Tibia_Angle)));
% ax3 = axes('parent',clusterfig,'units','pixels','position',[0 0 wh]);
ax3.Box = 'off';
box(ax3,'off'); set(ax3,'TickDir','out','tag','quickshow_ax'); axis(ax3,'tight');
plot(ax3,x(t2.exposure),trial.legPositions.Tibia_Angle)

xlim(ax3,[min(x) max(x)]);

ylabel(ax3,'Tibia Angle'); %xlim([0 max(t)]);

ax4 = panl(4).select();
t2 = postHocExposure(trial,max(size(trial.legPositions.Tibia_Angle))-1);
ax4.Box = 'off';
plot(ax4,x(t2.exposure),diff(smooth(trial.legPositions.Tibia_Angle,4)))
box(ax4,'off'); set(ax4,'TickDir','out','tag','quickshow_ax'); axis(ax4,'tight');
xlim(ax4,[min(x) max(x)]);
ylabel(ax4,'Tibia Angle'); %xlim([0 max(t)]);

  
