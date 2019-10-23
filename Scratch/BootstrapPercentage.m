% Stim and unstim are vectors of ones and zeros, in this case of 40% vs 25%
stim = zeros(100,1); stim(randperm(100,40)) = 1;
unstim = zeros(100,1); unstim(randperm(100,25)) = 1;

Dpctg = sum(stim)/numel(stim) - sum(unstim)/numel(unstim);

N = 10E4;

alltrials = [stim,unstim];

dpctg_reps = 1:N;
for n = 1:N
    inds = randperm(numel(alltrials));
    stim_draw = alltrials(inds(1:numel(stim)));
    unstim_draw = alltrials(inds(numel(stim)+1:end));
    dpctg_reps(n) = sum(stim_draw)/numel(stim_draw) - sum(unstim_draw)/numel(unstim_draw);
end

%% Plot distributions

figure, f = gcf;
a = histogram(dpctg_reps);
a.Parent.NextPlot = 'add';
plot([1 1]*Dpctg,a.Parent.YLim,'r');

p = sum(dpctg_reps>=Dpctg)/length(dpctg_reps);
disp(p)