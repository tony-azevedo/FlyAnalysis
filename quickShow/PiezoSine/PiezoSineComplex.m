function h = PiezoSineComplex(h,handles,savetag,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('trials',[],@isnumeric);
parse(p,varargin{:});

if isempty(p.Results.trials)
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);

    if isempty(h) || ~ishghandle(h)
        h = figure(100+trials(1)); clf
    else
    end
end

set(h,'tag',mfilename);
ax = subplot(1,1,1,'parent',h);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if isempty(regexp(trial.params.mode(end),'\w+'))
    trial.params.mode = trial.params.mode(1:end-1);
    data = trial;
    save(regexprep(data.name,'Acquisition','Raw_Data'), '-struct', 'data');
end

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
end

if length(trial.(y_name))<length(x)
    x = x(1:length(trial.(y_name)));
end
y = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name)(1:length(x));
end

y_ = mean(y,2);

x_win = x>= trial.params.ramptime & x<trial.params.stimDurInSec-trial.params.ramptime;

Yz = hilbert(y_-mean(y_(x>trial.params.preDurInSec+.06&x<6)));

stim = PiezoSine;
stim.setParams('-q',trial.params);
stim.setParams('-q','freqs',trial.params.freq,'displacements',trial.params.displacement);
s = stim.getStimulus.speakercommand;
Sz = hilbert(s);

Zz = Yz./Sz;

line(real(Yz(x_win)),imag(Yz(x_win)),'color',[1 .7 .7],'tag',savetag,'parent',ax);
line(real(Sz(x_win)),imag(Sz(x_win)),'color',[.7 .7 1],'tag',savetag,'parent',ax);
line(real(Zz(x_win)),imag(Zz(x_win)),'color',[.9 .9 .9],'tag',savetag,'parent',ax);

[cyclemat,ascd] = findSineCycle(s(x_win),0,1);

c_win = (cyclemat(1):cyclemat(2)) + sum(x< trial.params.ramptime);

line(real(Yz(c_win)),imag(Yz(c_win)),'color',[1 0 0],'linewidth',2,'tag',savetag,'parent',ax);
line(real(Sz(c_win)),imag(Sz(c_win)),'color',[0 0 1],'linewidth',2,'tag',savetag,'parent',ax);
line(real(Zz(c_win)),imag(Zz(c_win)),'color',[0 0 0],'linewidth',2,'tag',savetag,'parent',ax);

axis(ax,'square')
textbp(...
    [num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement*3) ' \mum'],...
    'fontsize',7,'parent',ax,'tag',savetag,'verticalAlignment','bottom')

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
title(ax,sprintf('%s - %.0f Hz %.2f \\mum', [prot '.' d '.' fly '.' cell '.' trialnum], trial.params.freq,trial.params.displacement*3));
box(ax,'off');
set(ax,'TickDir','out');
% ylabel(ax,y_units);
set(ax,'tag','response_ax');

