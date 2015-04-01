
dots = findobj(get(ax_fluo,'children'),'type','line');
dots_y_peak = dots;
dots_y_trough = dots;
for d_ind = 1:length(dots)
    dot = get(dots(d_ind),'ydata');
    dots_y_peak(d_ind) = dot(1);
    dots_y_trough(d_ind) = dot(2);
end

dots = findobj(get(ax_freq,'children'),'type','line');
dots_x_peak = dots;
dots_x_trough = dots;
for d_ind = 1:length(dots)
    dot = get(dots(d_ind),'ydata');
    dots_x_peak(d_ind) = dot(1);
    dots_x_trough(d_ind) = dot(2);
end

% Alternative
% dots_x_peak(:) = peak_point;
% dots_x_trough(:) = trough_point;

dots_x_peak = dots_x_peak+leftfreq;
dots_x_trough = dots_x_trough+leftfreq;


for d_ind = 1:length(dots);
    line([dots_x_peak(d_ind) dots_x_trough(d_ind)],...
        [dots_y_peak(d_ind) dots_y_trough(d_ind)],...
        'parent',ax_comp,'DisplayName',get(dots(d_ind),'displayName'),...
        'color',[1 1 1]*0,...
        'linestyle','-',...
        'marker','o',...
        'markerfacecolor','none',...
        'markeredgecolor',[1 1 1]*0,...
        'markersize',5 ...
        )
end

% left upper lines
cross_y = mean(dots_y_peak);
length_y = max(std(dots_y_peak)/sqrt(length(dots_y_peak)),.2);
cross_x = mean(dots_x_peak);
length_x = std(dots_x_peak)/sqrt(length(dots_x_peak));
line(cross_x + [-length_x length_x],...
    [cross_y cross_y],...
    'parent',ax_comp,...
    'color',[1 1 1]*0,...
    'linestyle','-'...
    )
line([cross_x  cross_x],...
    cross_y + [-length_y length_y],...
    'parent',ax_comp,...
    'color',[1 1 1]*0,...
    'linestyle','-'...
    )

% right lower lines
cross_y = mean(dots_y_trough);
length_y = max(std(dots_y_trough)/sqrt(length(dots_y_trough)),.2);
cross_x = mean(dots_x_trough);
length_x = std(dots_x_trough)/sqrt(length(dots_x_trough));
line(cross_x + [-length_x length_x],...
    [cross_y cross_y],...
    'parent',ax_comp,...
    'color',[1 1 1]*0,...
    'linestyle','-'...
    )
line([cross_x  cross_x],...
    cross_y + [-length_y length_y],...
    'parent',ax_comp,...
    'color',[1 1 1]*0,...
    'linestyle','-'...
    )

%significantly different than 0?
p = signtest(dots_y_peak);
if p<0.01
    line(peak_point, 30,...
        'parent',ax_comp,...
        'marker','*',...
        'markeredgecolor',[1 0 0],...
        'markersize',5 ...
        )
end

%significantly different than 0?
p = signtest(dots_y_trough);
if p<0.01
    line(trough_point, -20,...
        'parent',ax_comp,...
        'marker','*',...
        'markeredgecolor',[1 0 0],...
        'markersize',5 ...
        )
end


% whisker
% figure, plot(0),ax = gca;
% boxplot(ax,dots_y_peak,'position',peak_point - .25,'labels',{});
% chi = findobj(get(ax,'children'),'type','hggroup');
% copyobj(chi,ax_comp);
% 
% boxplot(ax,dots_y_trough,'position',trough_point + .25,'labels',{});
% chi = findobj(get(ax,'children'),'type','hggroup');
% copyobj(chi,ax_comp);
% axis(ax_comp,'tight')
