function h = PiezoNoisePS(h,handles,savetag)
% h = AverageLikeSongs(h,handles,savetag)
% see also AverageLikeSines
if isfield(handles,'infoPanel')
    notes = get(handles.infoPanel,'userdata');
else
    a = dir([handles.dir '\notes_*']);

    fclose('all');
    handles.notesfilename = fullfile(handles.dir,a.name);
    notes = fileread(handles.notesfilename);
end

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);

if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
delete(get(h,'children'));
ax = subplot(2,2,1,'parent',h);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
end

y = zeros(length(x),length(trials));
u = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name)(1:length(x));
    u(:,t) = trial.sgsmonitor(1:length(x));
end
u = mean(u,2);
y = mean(y,2);
wind = x>=0 & x<trial.params.stimDurInSec;
y = y(wind);
u = u(wind);
y = y-mean(y);
u = u-mean(u);
y = y(:);
u = u(:);

f = trial.params.sampratein/length(u)*[0:length(u)/2]; f = [f, fliplr(f(2:end-1))];
Y = real(fft(y).*conj(fft(y)));
Y = Y/sum(Y);
loglog(ax,f,Y/diff(f(1:2)),'color',[1 .7 .7],'tag',savetag); hold on

[Py,f] = pwelch(y-mean(y),trial.params.sampratein,[],[],trial.params.sampratein);
loglog(ax,f,Py/diff(f(1:2)),'color',[.7 0 0]); hold on
[Pu,f] = pwelch(u,trial.params.sampratein,[],[],trial.params.sampratein);
loglog(ax,f,Pu,'color','b'); hold on

xlim(ax,[1 1000])
xlabel('Hz')
ylabel('PSD')


ax = subplot(2,2,2,'parent',h);
lag_wind = [-5000 5000];
[xcor, lags] = xcorr(u);
lwind = lags>=lag_wind(1) & lags<=lag_wind(2);
plot(ax,lags(lwind)/trial.params.samprateout,xcor(lwind)/max(xcor(lwind)),'b','displayname','stim');hold on
[xcor, lags] = xcorr(y);
lwind = lags>=lag_wind(1) & lags<=lag_wind(2);
plot(ax,lags(lwind)/trial.params.samprateout,xcor(lwind)/max(xcor(lwind)),'color',[.7 0 0],'displayname','resp');  hold on

% get filter
u_snips = reshape(u,[],trial.params.stimDurInSec);
y_snips = reshape(y,[],trial.params.stimDurInSec);
lags = u_snips;
h_snips = lags;
% figure,plot(0),hold on
for col = 1:size(u_snips,2)
    [h_temp, lags] = xcorr(u_snips(:,col),y_snips(:,col));
    wind = ceil(length(lags)/2);
    h_snips(:,col) = h_temp(lags>=-wind/2 & lags<wind/2);
    % plot(lags,h_temp), hold on
end
lags = lags(lags>=-wind/2 & lags<wind/2)/trial.params.sampratein;

h = mean(h_snips,2);
plot(ax,lags(lags>=-.1 &lags<.1),h(lags>=-.1 &lags<.1)/max(h(lags>=-.1 &lags<.1)),'color',[1 0 1],'displayname','filt');

x_prime = x(x>=0 & x<trial.params.stimDurInSec);
u_prime = conv(u,flipud(h),'same');
u_prime = u_prime/max(abs(u_prime));
y = y/max(abs(y));
set(ax,'tag','unlink','xlim',[-.05 .025]);
xlabel('ms')
legend('location','best')

ax = subplot(2,2,3);
wind_l = 5.4;
wind_r = 5.8;
plot(ax,x_prime(x_prime>=wind_l&x_prime<wind_r),u_prime(x_prime>=wind_l&x_prime<wind_r),'b');hold on
plot(ax,x_prime(x_prime>=wind_l&x_prime<wind_r),y(x_prime>=wind_l&x_prime<wind_r),'r');

xlabel('ms')
ylabel('norm resp')
set(ax,'tag','unlink');

[linpredcor, lags] = xcorr(u_prime,y);
linpredcor = linpredcor(:);
lags = lags(:)/trial.params.sampratein;
R_ = corrcoef(u_prime,y);
R = R_(1,2);

ax = subplot(2,2,4);
%plot(ax,lags(lags>=-.1 &lags<.1),linpredcor(lags>=-.1 &lags<.1))
plot(ax,u_prime(100:100:length(u_prime))/max(abs(u_prime)),...
    y(100:100:length(u_prime))/max(abs(y)),'marker','.','linestyle','none','markersize',.1,'color',[.7 0 0])
text(0,-.8,['R=' num2str(R)]);

set(ax,'tag','unlink');

% R = nan(2000,1);
% for lag = -1000:1000-1;
%     R_ = corrcoef(u_prime(1000+1:length(u_prime)-1000),y(1000+lag+1:length(y)-1000+lag));
%     R(lag+1000+1) = R_(1,2);
% end
% plot(ax,x(wind),y/max(abs(y)),'.','markersize',.1,'color',[.7 0 0]); hold on
% plot(ax,x(wind),u_prime/max(abs(u_prime)),'.','markersize',.1,'color',[0 0 1]);

