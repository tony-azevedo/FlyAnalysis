function varargout = PF_PiezoSineF2_2_F1(fig,handles,savetag,varargin)
% works on Current Sine, there for the blocks have a range of amps and freqs
% see also TransferFunctionOfLike
ip = inputParser;
ip.PartialMatching = 0;
ip.addParameter('plot',1,@isnumeric);
parse(ip,varargin{:});

Ratio = nan(length(handles.trial.params.freqs),length(handles.trial.params.displacements));
F1 = nan(length(handles.trial.params.freqs),length(handles.trial.params.displacements));
F2 = nan(length(handles.trial.params.freqs),length(handles.trial.params.displacements));
blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

dispexamples = blocktrials;
for ii = 1:length(dispexamples)
    blocktrials = findLikeTrials('trial',dispexamples(ii),'datastruct',handles.prtclData,'exclude',{'freq'});
    t = 1;
    while t <= length(blocktrials)
        trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
        blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
        t = t+1;
    end
    
    freqexamples = blocktrials;
    for jj = 1:length(freqexamples)
        handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,freqexamples(jj))));
        [F1(jj,ii),F2(jj,ii)] = TransFunc(handles);
        F1(jj,ii) = real(abs(F1(jj,ii)));
        F2(jj,ii) = real(abs(F2(jj,ii)));
        
        Ratio(jj,ii) = (F1(jj,ii)-F2(jj,ii))/(F1(jj,ii)+F2(jj,ii));
    end
    
end
varargout{1} = Ratio;
varargout{2} = F1;
varargout{3} = F2;
varargout{4} = handles.trial.params.freqs;
varargout{5} = handles.trial.params.displacements;


function varargout = TransFunc(handles, varargin)

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
end
outname = 'sgsmonitor';

y = zeros(length(x),length(trials));
u = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name)(1:length(x));
    u(:,t) = trial.(outname)(1:length(x));
end

yc = mean(y,2);
base = mean(yc(x<0));
yc = yc-base;
uc = mean(u,2);
offset = mean(uc(x<0));
uc = uc-offset;

fin = trial.params.stimDurInSec - trial.params.ramptime;
yc = yc(x>=fin-trial.params.stimDurInSec/2 & x< fin);
uc = uc(x>=fin-trial.params.stimDurInSec/2 & x< fin);
t = x(x>=fin-trial.params.stimDurInSec/2 & x< fin);

f = trial.params.sampratein/length(t)*[0:length(t)/2]; f = [f, fliplr(f(2:end-1))];
YC = fft(yc(1:length(f)));
UC = fft(uc(1:length(f)));
f_ind = find(abs(f-trial.params.freq)==min(abs(f-trial.params.freq)));

transferF1 = YC(f_ind(1));

f2_ind = find(abs(f-2*trial.params.freq)==min(abs(f-2*trial.params.freq)));

transferF2 = YC(f2_ind(1));

varargout = {transferF1,transferF2};



