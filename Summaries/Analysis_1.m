%% Analysis script - Define the 

% Click on a folder, load the data document
dataOverview(data)

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

%% trials index loop
desired_fn = 'stimName';
desired_val = 'Fc = 200 Hz, Fm = 0.5 Hz';

trials = zeros(length(data),1);
for t = 1:length(trials)
    if isnumeric(desired_val) && sum(data(t).(desired_fn)==desired_val)
        trials(t) = 1;
    elseif ischar(desired_val) && strcmp(data(t).(desired_fn),desired_val)
        trials(t) = 1;
    end
end
trialsl = logical(trials);
trials = find(trials); disp(trials);

%% set the size of the data matrix
data_voltage_mat = zeros(data(trials(1)).nsampin,length(trials));
data_current_mat = zeros(data(trials(1)).nsampin,length(trials));
data_stim_mat = zeros(data(trials(1)).nsampout,length(trials));

for r = 1:length(trials)
    trial = load(fnames{trials(r)});
    data_voltage_mat(:,r) = trial.voltage;
    data_current_mat(:,r) = trial.current;
    data_stim_mat(:,r) = trial.stim;
end

