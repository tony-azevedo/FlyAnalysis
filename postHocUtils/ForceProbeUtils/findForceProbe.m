function [trial,mb,tngntpnt] = findForceProbe(trial, varargin)
%% Set an ROI that avoids the leg, just gets the probe

p = inputParser;
p.PartialMatching = 0;
p.addParameter('PLOT',false,@islogical);
PLOT = 0;
parse(p,varargin{:});

%%

vid = VideoReader(trial.imageFile);

smooshedframe = double(readFrame(vid));
smooshedframe = squeeze(smooshedframe(:,:,1));

for jj = 1:10
    mov3 = double(readFrame(vid));
    smooshedframe = smooshedframe+mov3(:,:,1);
end
smooshedframe = smooshedframe/11;

%% blur the smooshed frame
smfr = imgaussfilt(smooshedframe,40);
lw = size(smfr);
if PLOT
    figure
    montage({smooshedframe/max(smooshedframe(:)),smfr/max(smfr(:))})
end

%% Find the upper triangle
upper = flipud(tril(flipud(smfr),round(-lw(1)*1/2)));

% Is there a probe?

% What is the mean of the lower left triangle, with lower corner cut out
onemat = ones(lw);
darkstrip = tril(onemat,round(-lw(1)*1/3));
darkstrip(:,round(lw(2)/3):end) = 0;
darkstrip(logical(tril(darkstrip,round(-lw(1)*2/3)))) = 0;

darkstrp = smfr;
darkstrp(~logical(darkstrip)) = 0;
if PLOT
    % montage({smooshedframe/max(smooshedframe(:)),darkstrp/max(smooshedframe(:))})
    montage({smooshedframe/max(smooshedframe(:)),upper/max(smfr(:))})
end
dark = darkstrp(logical(darkstrip));
%dark = mean(darkstrp(logical(darkstrip)));
upt = upper(upper>0);

%[n,edges] = histcounts(dark,10);
[n,edges] = histcounts(upt,10);
if PLOT
    figure
    subplot(1,2,1);
    histogram(dark,10)
    subplot(1,2,2);
    histogram(upt,10)
end
edge_med = find(edges>median(upt),1);
% find the trough associated with a bar.
while (edge_med<length(n)) && (n(edge_med) > n(edge_med+1)) 
    edge_med = edge_med+1;
end
    
if mean(upt)>mean(dark)+1/2*std(dark) && ...
        sum(n(edge_med) < n(edge_med+1:end))>2 % if there is a bar, the distribution should be bimodal
    fprintf('Bar detected: %s - %d\n',trial.params.protocol,trial.params.trial);
    dimside = quantile(upt(:),.85);
else
    fprintf('No bar detected: %s - %d\n',trial.params.protocol,trial.params.trial);
    mb = [];
    tngntpnt = [];
    %error('No bar detected: %s',trial.name);
    return
end

% Now calculating max along each row of the blurred image, then fitting a line to the max points.

l = 1/4;
onemat = ones(lw);
upper = flipud(tril(flipud(smfr),round(-lw(1)*l)));
upperones = logical(flipud(tril(flipud(onemat),round(-lw(1)*l))));

upper(~upperones) = nan;

% montage({smooshedframe/max(smooshedframe(:)),upper/max(smfr(:))})

%%
mxpnts = nan(10E3,2);
curr = 0;
for c = 1:round(lw(1)*(1-l))
    % choose 1 peak per column
    colmaxes = (find(upper(:,c)==max(upper(:,c))))';
    if all(upper(colmaxes,c)>dimside) && all(colmaxes>1)
        mxpnts(curr+1:curr+length(colmaxes),:) = [colmaxes colmaxes.*0+c];
    end
    if find(isnan(upper(:,c)),1)-2 < max(colmaxes)
        % stop if it looks like the brightest thing is at the end
        break
    end
    curr = curr+length(colmaxes);
end
mxpnts = mxpnts(~isnan(mxpnts(:,2)),:);

mb = polyfit(mxpnts(:,2),mxpnts(:,1),1);
l = mb(1)*mxpnts(:,2)+mb(2);

trial.forceProbe_line = fliplr([[l(1);l(end)], [mxpnts(1,2);mxpnts(end,2)]]);

%% Now look for a tangent line point in a profile parallel to the current line

% first calculate the x intercept
x_int = (0-mb(2))/mb(1);
% then go half way from there to end
x_int = (x_int+(lw(2)-x_int)*1/3);
% calculate a new slope intercept
mb_tngt = mb;
mb_tngt(2) = -x_int*mb(1);
% make a new line
l_tngnt = nan(2,2);
l_tngnt(1,:) = [1, (1-mb_tngt(2))/mb_tngt(1)];
l_tngnt(2,:) = [mb_tngt(1)*lw(2)+mb_tngt(2), lw(2)];

[cx,cy,c] = improfile(smfr,l_tngnt(:,2),l_tngnt(:,1));

% move it back a few indices
t_idx = find(c>mean(c(1:50))+1/10*(max(c)-nanmean(c(1:50))),1,'first')-10;

tngntpnt = [cy(t_idx), cx(t_idx)];
%line(l_tngnt(:,2),l_tngnt(:,1),'parent',dispax,'color',[1 0 1]);

trial.forceProbe_tangent = fliplr(tngntpnt);

%% 
if PLOT
    displayf = figure;
    displayf.Position = [600 2 1280 1048];
    displayf.Tag = 'big_fig';
    displayf.MenuBar = 'none';
    dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
    dispax.Box = 'off'; dispax.XTick = []; dispax.YTick = []; dispax.Tag = 'dispax';
    colormap(dispax,'gray')
    im = imshow(smfr/max(upper(:)),'parent',dispax);
    line(mxpnts(:,2),mxpnts(:,1),'parent',dispax, 'marker','o','markeredgecolor',[0 1 0]);
    
    line(mxpnts(:,2),l,'parent',dispax,'color',[1 0 1]);
    line(tngntpnt(:,2),tngntpnt(:,1),'parent',dispax,'marker','o','markeredgecolor',[1 1 0]);
end




