%% Analysis script - 1/26/13 commit 36ff9568da3fe9fb9544b63279e5e7e1b37afb14

% Click on a folder, load the data document
% dataOverview(data)

%% order the fnames correctly
a = dir('Raw*');
fnames = cell(length(a),1);
trial_vec = zeros(length(a),1);
flynumber_vec = zeros(length(a),1);
cellnumber_vec = zeros(length(a),1);

for n = 1:length(a)
    fname = a(n).name;
    fnames{n} = fname;
    inds_ = regexp(fnames{n}, '_');
    trial_vec(n) = str2double(fname(inds_(end)+1:end-4));
    cellnumber_vec(n) = str2double(fname(inds_(end-1)+2:inds_(end)-1));
    flynumber_vec(n) = str2double(fname(inds_(end-2)+2:inds_(end-1)-1));
end

[trial_vec,order] = sort(trial_vec);
fnames = fnames(order);
cellnumber_vec = cellnumber_vec(order);
flynumber_vec = flynumber_vec(order);

%% Look at the holding potential to decide how to group or cluster
dispstr = '';
params = fieldnames(data);
l = length(data);
recMode_cell = cell(l,1);
Ihold_vec = nan(l,1);
Vrest_vec = nan(l,1);

for e = 1:l
    recMode_cell{e} = data(e).('recMode');
    Ihold_vec(e) = data(e).('Ihold');
    Vrest_vec(e) = data(e).('Vrest');
end

% Vrest_histo
fig = figure(1); clf;
set(fig,'name','Vm\_overview','fileName','figures\Vm_overview')

ax(1) = axes('position',[0.1,0.1,0.6,0.8],'parent',fig);
xlabel(ax(1),'Trial Number');
ylabel(ax(1),'V_m');

line((1:l),Vrest_vec,'parent',ax(1),'color',[1 1 1]*.9,'linestyle','-','marker','.','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])

ax(2) = axes('position',[0.8,0.1,0.15,0.8],'parent',fig);
xlabel(ax(2),'V\_m');
ylabel(ax(2),'freq');

[bins,deltax] = subOptimalBinWidth(Vrest_vec);
n = hist(Vrest_vec,bins);
hold on,
stairs(n,bins-deltax/2), hold off

ylims = [min(Vrest_vec),max(Vrest_vec)];
set(ax,'ylim',ylims)
epochs = round((1:4)*l/5);
for e = epochs
    line([e e],ylims,'parent',ax(1),'color',[1 1 1]*.9,'linestyle','--','marker','none','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])
    text(e+1,min(ylims)+diff(ylims)*.05,sprintf('%g',e),'parent',ax(1));
end

saveas(fig,get(fig,'fileName'),'pdf'); % close all;

%% group trials index loop  TODO: turn this into a tree class
params_to_discriminate = {'fc','fm','intensity'};
[grouptrial_cell,grouplabels] = groupTrials(data,params_to_discriminate)

%% plot and save data
for g = 1:length(grouptrial_cell)
    %% Plot a group of data
    group = grouptrial_cell{g};
    if isempty(group);
        continue
    end
    grouptrialstr = sprintf('%g,',group(:));
    grouptrialstr = strcat('[',grouptrialstr(1:end-1),']');
    fprintf('\t%s\n',grouplabels{g});

    % make a group time vector
    stim_time = ((1:data(group(1)).nsampout) - data(group(1)).stimonsamp)/data(group(1)).samprateout;
    data_time = (1:data(group(1)).nsampin)/data(group(1)).sampratein - data(group(1)).stimonsamp/data(group(1)).samprateout;
    
    % set the size of the data matrix
    data_voltage_mat = zeros(data(group(1)).nsampin,length(group));
    data_current_mat = zeros(data(group(1)).nsampin,length(group));
    data_stim_mat = zeros(data(group(1)).nsampout,length(group));

    fig = figure('position',[10,40,1900,800]); clf;
    set(fig,'name',sprintf('%s_%s',grouplabels{g},grouptrialstr),'fileName',sprintf('figures\\%s_%s',grouplabels{g},grouptrialstr))
    
    ax1 = axes('position',[0.1,0.65,0.8,0.25],'parent',fig);
    title(ax1,sprintf('%s\\_%s',regexprep(grouplabels{g},'_','\\_'),grouptrialstr)); 
    ylabel(ax1,'V_m');
    xlabel(ax1,'time');

    ax2 = axes('position',[0.1,0.35,0.8,0.25],'parent',fig);
    ylabel(ax2,'V_m');
    xlabel(ax2,'time');
    
    ax3 = axes('position',[0.1,0.05,0.8,0.25],'parent',fig);
    ylabel(ax3,'V_{out}');
    xlabel(ax3,'time');
   
    traces = zeros(length(group),1);
    for r = 1:length(group)
        trial = load(fnames{group(r)});
        data_voltage_mat(:,r) = trial.voltage;
        data_current_mat(:,r) = trial.current;
        data_stim_mat(:,r) = trial.stim;
        traces(r) = line(data_time,data_voltage_mat(:,r),'parent',ax1);
    end
    set(traces(:),'color',[1 1 1]*.0,'linestyle','-','marker','none','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])

    ind = randi(length(group),1);
    line(data_time,data_voltage_mat(:,ind),'parent',ax2,'DisplayName',sprintf('Trial %g',ind),'color',[1 1 1]*.8);
    line(data_time,mean(data_voltage_mat,2),'parent',ax2,'DisplayName','mean\_voltage','color',[0 0 0]);
    legend(ax2,'show');
    line(stim_time,data_stim_mat(:,r),'parent',ax3,'displayname',sprintf('%s',regexprep(grouplabels{g},'_','\\_')));
    
    %% Save group data
    orient(fig,'landscape'); print(fig,'-dpdf',get(fig,'fileName')); close all
end
clear g
%% get a 'g' in order to run the previous cell again
gstr = 'fc_0_fm_0_intensity_3';
g = find(strcmp(grouplabels,gstr))

