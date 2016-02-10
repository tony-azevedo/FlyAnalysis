function varargout = PF_PiezoSineDepolTransFunc_Current(fig,handles,savetag,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('closefig',1,@isnumeric);
parse(p,varargin{:});

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);

trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));

x = makeTime(trial.params);

y = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.current(1:length(x));
end

y_ = mean(y,2);

d1 = getpref('FigureMaking','CurrentFilter');
% lpFilt = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',50e3);
% setpref('FigureMaking','CurrentFilter',lpFilt);
if d1.SampleRate ~= trial.params.sampratein
    d1 = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',trial.params.sampratein);
end

for c = 1:size(y,2)
    y(:,c) = filtfilt(d1,y(:,c));
end
y_ = filtfilt(d1,y_);

base = mean(y_(x<0&x>-trial.params.preDurInSec+.06));
y_ = y_-base;

response_area = trapz(...
    x(x>=0 & x <trial.params.stimDurInSec-eps),...
    y_(x>=0 & x <trial.params.stimDurInSec-eps));
response_area = response_area/trial.params.stimDurInSec;

response_area_ext = trapz(x(x>=0),y_(x>=0));


varargout = {response_area,response_area_ext};