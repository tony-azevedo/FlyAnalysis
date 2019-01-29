%% Script_CorrectAndAddTrackedPostitions

%% Current Algorithm

% Compute pairwise distances between points

% Find the outliers, typically only one or two distances, indicating that
% a single point is weird

% Map weird distances back to the points that compose that distance

% Turn the weird points to nans and median filter.

% Then go back and find all the frames in which a single point is weird in
% neighboring frames ("double weird") and insert nans. In a subsequent
% step, these double weird points could be filled in.

%% Collect all the points and distances between points across all trials

DEBUG_PLOT = 1;

[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

if ~exist(fullfile(D,'csv'),'dir')
    mkdir(fullfile(D,'csv'))
end
br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

cnt = 0;

TibiaCoords = trial.legPositions.Positions(:,startsWith(trial.legPositions.Positions.Properties.VariableNames,'Tibia'));
varTypes = cell(1,1+size(TibiaCoords,2)); varTypes(:) = {'double'};
Coords = table('Size',[height(TibiaCoords)*length(trialnumlist), size(TibiaCoords,2)+1],'VariableTypes',varTypes);%T = table('Size',sz,'VariableTypes',varTypes)
Coords.Properties.VariableNames = ['tr_idx',TibiaCoords.Properties.VariableNames];

for tr_idx = trialnumlist
    cnt = cnt+1;
    trial = load(sprintf(trialStem,tr_idx));
    waitbar(cnt/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
    
    idx_i = find(~Coords{:,1},1,'first');
    TibiaCoords = trial.legPositions.Positions(:,startsWith(trial.legPositions.Positions.Properties.VariableNames,'Tibia'));
    idx_f = idx_i-1 + height(TibiaCoords);
    Coords{idx_i:idx_f,1} = tr_idx;
    Coords(idx_i:idx_f,2:end) = TibiaCoords;
end

delete(br)

%% Compute distances between points

TibiaParts = regexprep(Coords.Properties.VariableNames(endsWith(Coords.Properties.VariableNames,'_x')),'_x','');
% TibiaParts = regexprep(TibiaParts,'Constriction','Kink');

pairs = {...
    'TibiaVentralKink'  'TibiaVentralMid'
    'TibiaVentralKink'  'TibiaDorsalConstriction'
    'TibiaVentralMid'   'TibiaVentralBulge'
    'TibiaVentralMid'   'TibiaDorsalMid'
    'TibiaVentralBulge' 'TibiaDorsalBulge'
    'TibiaDorsalBulge'  'TibiaDorsalMid'
    'TibiaDorsalMid'    'TibiaDorsalConstriction'};
pairs = pairs';

varTypes = cell(1,size(pairs,2)); varTypes(:) = {'double'};
varNames = varTypes;
PWDists = table('Size',[height(Coords),length(varTypes)],'VariableTypes',varTypes);
for c = 1:size(pairs,2)
    part1 = pairs{1,c};
    part2 = pairs{2,c};
    PWDists{:,c} = sqrt((Coords.([part1 '_x']) - Coords.([part2 '_x'])).^2 + (Coords.([part1 '_y']) - Coords.([part2 '_y'])).^2);
    varNames{c} = [part1 '_vs_' part2];
end
PWDists.Properties.VariableNames = varNames;

bin_max = max(max(PWDists{:,:}));
bin_min = min(min(PWDists{:,:}));
bin_del = (bin_max-bin_min)/(height(TibiaCoords));
bins = bin_min+bin_del/2:bin_del:bin_max;


%% Distances should be bounded, Find the weird distances
% Weird distances indicate an error in the tracking

N_cutoff = 5;
fprintf('Distance is bad if there are fewer than %g values in a bin\n',N_cutoff);

% For each distance comparison, determine weird ones
weird_dists = false(size(PWDists));
cs = PWDists.Properties.VariableNames;
bounds = zeros(size(pairs));
for c = 1:length(cs)
    [N] = hist(PWDists{:,c},bins);
    [bestbet,n] = max(N);
    right_bin = find(N(n:end)<=N_cutoff,1,'first')+n;
    left_bin = find(N(1:n)<=N_cutoff,1,'last');
    bounds(:,c) = [bins(left_bin) bins(right_bin)];
    weird_dists(:,c) = PWDists{:,c} >= max(bounds(:,c)) | PWDists{:,c} <= min(bounds(:,c)) | isnan(PWDists{:,c});
end
weird_frames = any(weird_dists,2);
fprintf('%d frames are weird\n',sum(weird_frames));

[weirdest_dis,o] = sort(sum(weird_dists,1));
for oidx = length(o):-1:1
    fprintf('%d weird %s distances\n',weirdest_dis(oidx),varNames{oidx});
end

for idx = 1:length(o)
    fprintf('%d frames are %dX weird\n',sum(sum(weird_dists,2)==idx),idx);
end

if DEBUG_PLOT
    showDistanceDistributions(PWDists,bins,bounds,weird_dists)
end

% Show some weird frames

% howweird = 4;
% weird_idx = find(sum(weird_points,2)==howweird);
% tridx = unique(Coords{weird_idx,1});
% weird_fn = find(sum(weird_points(Coords{:,1}==tridx(6),:),2)==howweird);
% 
% trial = load(sprintf(trialStem,tridx(6)));
% weird_pnts_trl = weird_points(Coords{:,1}==tridx(6),:);
% dist_trl = PWDists{Coords{:,1}==tridx(6),:};
% 
% for idx = 1:length(weird_fn)
%     fprintf('Trial %d, frame %d, has weird distances for: \n',tridx(6),weird_fn(idx));
% 
%     weird_pnts_fr = find(weird_pnts_trl(weird_fn(idx),:));
%     dist_fr = dist_trl(weird_fn(idx),:);
%     
%     for widx = weird_pnts_fr
%         fprintf('%s: ',cs{widx});
%         if dist_fr(widx) < bounds(1,widx)
%             fprintf('dist %g < %g\n',dist_fr(widx) ,bounds(1,widx));
%         elseif dist_fr(widx) > bounds(2,widx)
%             fprintf('dist %g > %g\n',dist_fr(widx) ,bounds(2,widx));
%         end
%     end
% end
% Script_ProofreadDLCGeneratedPositions

% showCam1Frame(trial,[weird_fn(2)+1]);

%% From the weird distances, guess at the points that are wrong
% Then median filter so remove the points that are individually way off.
% The points where neighboring frames are weird should not be filtered

% First go from weird distances back to weird points
weird_points = false(size(Coords));
crdnms = Coords.Properties.VariableNames;
for bidx = 1:length(TibiaParts)
    part = TibiaParts{bidx};
    px = contains(crdnms,[part '_x']);
    py = contains(crdnms,[part '_y']);
    wd = contains(cs,part);
    weird_points(:,px|py) = repmat(any(weird_dists(:,wd),2),1,2);
end

% confirm weird_points and weird_dists are weird for the same frames
any(any(weird_points,2)~=any(weird_dists,2)) % Should be 0
np = Coords{:,:};
np(weird_points) = nan;

for tr_idx = trialnumlist
    idx = np(:,1)==tr_idx;
    np(idx,:) = medfilt1(np(idx,:),3,[],1,'omitnan','truncate'); 
end

poor_frames = isnan(np);
fprintf('\nAfter filtering points and filling nans where possible, there are only %d weird frames\n', sum(any(poor_frames,2)));
% Down to ~173 frames that still have nans after the filtering

% Now add back nans to any values where more than 1 frames were weird in a
% row
doubleweird = weird_points;
doubleweird(1,:) = weird_points(1,:) & weird_points(2,:);
doubleweird(2:end-1,:) =...
    weird_points(1:end-2,:) & weird_points(2:end-1,:) |...
    weird_points(2:end-1,:) & weird_points(3:end,:);
doubleweird(end,:) = weird_points(end-1,:) & weird_points(end,:);
np(doubleweird) = nan;

poor_frames = isnan(np);
fprintf('After blanking double weird frames, there are %d weird frames\n', sum(any(poor_frames,2)));
% Down to ~173 frames that still have nans after the filtering


if DEBUG_PLOT
    xlims = [min(np(:,contains(crdnms,'_x')),[],'all') max(np(:,contains(crdnms,'_x')),[],'all')];
    ylims = [min(np(:,contains(crdnms,'_y')),[],'all') max(np(:,contains(crdnms,'_y')),[],'all')];
    
    op = Coords{:,:};
    trials = find(diff(np(:,1)));
    
    medfilterfig = figure;
    medfilterfig.Position = [171 78 1069 900];
    ax = subplot(2,2,1,'parent',medfilterfig); ax.NextPlot = 'add';
    plot(ax,op(:,contains(crdnms,'_y')),'color',[.9 .9 .9]); 
    plot(ax,np(:,contains(crdnms,'_y'))); 
    plot(ax,repmat(trials,1,2)',repmat(ylims,size(trials,1),1)','k')
    ax.YLim = ylims;
    
    
    ax = subplot(2,2,4,'parent',medfilterfig); ax.NextPlot = 'add';
    plot(ax,op(:,contains(crdnms,'_x')),'color',[.9 .9 .9]); 
    plot(ax,np(:,contains(crdnms,'_x'))); 
    ax.YLim = xlims;
    ax.View = [90 -90];
    
    ax = subplot(2,2,2,'parent',medfilterfig); ax.NextPlot = 'add';
    plot(ax,op(:,contains(crdnms,'_x')),op(:,contains(crdnms,'_y')),'color',[.9 .9 .9]); 
    op = np;
    op(trials+1,:) = nan;
    plot(ax,op(:,contains(crdnms,'_x')),op(:,contains(crdnms,'_y'))); 
    ax.XLim = xlims;
    ax.YLim = ylims;
end

%% Now measure pairwise distances and look at weirdness again

pairwiseD = double(weird_dists);
weird_dists_post = weird_dists;
for c = 1:size(pairs,2)
    part1 = pairs{1,c};
    part2 = pairs{2,c};
    p1col1 = contains(crdnms,[part1 '_x']);
    p1col2 = contains(crdnms,[part1 '_y']);
    p2col1 = contains(crdnms,[part2 '_x']);
    p2col2 = contains(crdnms,[part2 '_y']);
    pairwiseD(:,c) = sqrt((np(:,p1col1) - np(:,p2col1)).^2 + (np(:,p1col2) - np(:,p2col2)).^2);
    weird_dists_post(:,c) = pairwiseD(:,c) >= max(bounds(:,c)) | pairwiseD(:,c) <= min(bounds(:,c)); %| isnan(pairwiseD(:,c));
end

weird_frames = any(weird_dists_post,2);
fprintf('%d frames are weird\n',sum(weird_frames));

[weirdest_dis,o] = sort(sum(weird_dists_post,1));
for oidx = length(o):-1:1
    fprintf('%d weird %s distances\n',weirdest_dis(oidx),varNames{oidx});
end

for idx = 1:length(o)
    fprintf('%d frames are %dX weird\n',sum(sum(weird_dists_post,2)==idx),idx);
end

PWDists{:,:} = pairwiseD;

if 1%DEBUG_PLOT
    showDistanceDistributions(PWDists,bins,bounds,weird_dists_post)
end

%% Write the new values back to the trials, with nans in the double weird spots
br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];
cnt = 0;
for tr_idx = trialnumlist
    cnt = cnt+1;
    trial = load(sprintf(trialStem,tr_idx));
    waitbar(cnt/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
    
    trial.legPositions.Positions_Corrected = trial.legPositions.Positions;
    
    idx = find(np(:,1)==trial.params.trial);
    for part = TibiaParts
        x = [part{1} '_x'];
        y = [part{1} '_y'];
        px = contains(crdnms,x);
        py = contains(crdnms,y);
        trial.legPositions.Positions_Corrected.(x) = np(idx,px);
        trial.legPositions.Positions_Corrected.(y) = np(idx,py);
        
        trial.legPositions.PositionsChanged = 1;
    end
    trial.legPositions.PositionsChanged = 1;
    trial.legPositions.PairWiseBounds = bounds;
    save(trial.name, '-struct', 'trial')
end

delete(br)
% clear Coords doubleweird I idx_f idx_i np op


%%
function showCam1Frame(trial,weird_fn)

t = makeInTime(trial.params);
exp = postHocExposure(trial);

ft = t(exp.exposure);
weird_ft = ft(weird_fn);

vid = VideoReader(trial.imageFile);
vid.CurrentTime = weird_ft(1);
I = vid.readFrame;
I = double(squeeze(I(:,:,1)));

displayf = figure;
set(displayf,'position',[120 10 fliplr(size(I))]+[0 0 0 10],'tag','big_fig');
displayf.MenuBar = 'none';
displayf.ToolBar = 'none';

dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(size(I))]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

im = imshow(I,[0 1.6*quantile(I(:),0.975)],'parent',dispax);

clear pnt

% ask to label each point static point in turn
txt = text(dispax,size(I,2)/3,20,'TXT');
txt.Position = [20 10 0]*size(I,2)/640;
txt.VerticalAlignment = 'top';
txt.Color = [1 1 1];
txt.FontSize = 18;
txt.FontName = 'Ariel';

% put each body part on the image
bodyparts = trial.legPositions.Positions.Properties.VariableNames(contains(trial.legPositions.Positions.Properties.VariableNames,'_x'));
bodyparts = regexprep(bodyparts,'_x','');
clrs = distinguishable_colors(length(bodyparts));

try delete(pnt); catch e, end

for i = 1:length(weird_fn)
    for bdidx = 1:length(bodyparts)
        T_X = trial.legPositions.Positions.([bodyparts{bdidx} '_x']);
        T_Y = trial.legPositions.Positions.([bodyparts{bdidx} '_y']);
        xy = [T_X(weird_fn(i),1) T_Y(weird_fn(i),1)];
        pnt(bdidx) = drawpoint(dispax,'Position',xy,'Color',clrs(bdidx,:),'Label',bodyparts{bdidx});
        %     pnt(bdidx).setString(bodyparts{bdidx});
    end
end

end

%% Distributions of distances
function showDistanceDistributions(PWDists,bins,bounds,weird_points)

weird_frames = any(weird_points,2);

distfig = figure;
distfig.Position = [74 148 1487 830];

% Left
idxs = 1:length(weird_frames);
ax = subplot(2,9,[1 2]);
plot(ax,idxs,PWDists.TibiaVentralKink_vs_TibiaVentralMid,'Color',[.8 .8 .8]), hold(ax,'on')
l1 = plot(ax,idxs(~weird_frames),PWDists.TibiaVentralKink_vs_TibiaVentralMid(~weird_frames)); hold on
plot(ax,idxs,PWDists.TibiaVentralMid_vs_TibiaVentralBulge,'Color',[.8 .8 .8]), hold(ax,'on')
l2 = plot(ax,idxs(~weird_frames),PWDists.TibiaVentralMid_vs_TibiaVentralBulge(~weird_frames)); hold on
ax.YLim = [0 900];

ax = subplot(2,9,[10 11]);
plot(ax,PWDists.TibiaVentralKink_vs_TibiaVentralMid,PWDists.TibiaVentralMid_vs_TibiaVentralBulge,'.','Color',[.8 .8 .8]), hold(ax,'on')
plot(ax,PWDists.TibiaVentralKink_vs_TibiaVentralMid(~weird_frames),PWDists.TibiaVentralMid_vs_TibiaVentralBulge(~weird_frames),'.')
ax.XLim = [0 900];
ax.YLim = [0 900];

ax = subplot(2,9,3);
[N] = hist(PWDists.TibiaVentralKink_vs_TibiaVentralMid,bins);
plot(ax,bins,N,'color',l1.Color); hold on
plot(ax,[bounds(1,1),bounds(1,1)],[0 max(N)],'Color',l1.Color);
plot(ax,[bounds(2,1),bounds(2,1)],[0 max(N)],'Color',l1.Color);
[N] = hist(PWDists.TibiaVentralMid_vs_TibiaVentralBulge,bins);
plot(ax,bins,N,'color',l2.Color);
plot(ax,[bounds(1,3),bounds(1,3)],[0 max(N)],'Color',l2.Color);
plot(ax,[bounds(2,3),bounds(2,3)],[0 max(N)],'Color',l2.Color);
ax.XLim = [0 900];
ax.View = [90 -90];

% Center
ax = subplot(2,9,[4 5]); ax.NextPlot = 'add';
plot(ax,idxs,PWDists.TibiaVentralKink_vs_TibiaDorsalConstriction,'Color',[.8 .8 .8])
l1 = plot(ax,idxs(~weird_frames),PWDists.TibiaVentralKink_vs_TibiaDorsalConstriction(~weird_frames));
plot(ax,idxs,PWDists.TibiaVentralMid_vs_TibiaDorsalMid,'Color',[.8 .8 .8])
l2 = plot(ax,idxs(~weird_frames),PWDists.TibiaVentralMid_vs_TibiaDorsalMid(~weird_frames));
plot(ax,idxs,PWDists.TibiaVentralBulge_vs_TibiaDorsalBulge,'Color',[.8 .8 .8])
l3 = plot(ax,idxs(~weird_frames),PWDists.TibiaVentralBulge_vs_TibiaDorsalBulge(~weird_frames)); 
ax.YLim = [0 900];

ax = subplot(2,9,[13 14]);
plot(ax,PWDists.TibiaVentralKink_vs_TibiaDorsalConstriction,PWDists.TibiaVentralBulge_vs_TibiaDorsalBulge,'.','Color',[.8 .8 .8]), hold on
plot(ax,PWDists.TibiaVentralKink_vs_TibiaDorsalConstriction(~weird_frames),PWDists.TibiaVentralBulge_vs_TibiaDorsalBulge(~weird_frames),'.'), hold on
ax.XLim = [0 900];
ax.YLim = [0 900];

ax = subplot(2,9,6);
[N] = hist(PWDists.TibiaVentralKink_vs_TibiaDorsalConstriction,bins);
plot(ax,bins,N,'color',l1.Color); hold on
plot(ax,[bounds(1,2),bounds(1,2)],[0 max(N)],'Color',l1.Color);
plot(ax,[bounds(2,2),bounds(2,2)],[0 max(N)],'Color',l1.Color);
[N] = hist(PWDists.TibiaVentralMid_vs_TibiaDorsalMid,bins);
plot(ax,bins,N,'color',l2.Color);
plot(ax,[bounds(1,4),bounds(1,4)],[0 max(N)],'Color',l2.Color);
plot(ax,[bounds(2,4),bounds(2,4)],[0 max(N)],'Color',l2.Color);
[N] = hist(PWDists.TibiaVentralBulge_vs_TibiaDorsalBulge,bins);
plot(ax,bins,N,'color',l3.Color);
plot(ax,[bounds(1,5),bounds(1,5)],[0 max(N)],'Color',l3.Color);
plot(ax,[bounds(2,5),bounds(2,5)],[0 max(N)],'Color',l3.Color);
ax.XLim = [0 900];
ax.View = [90 -90];

% Right
ax = subplot(2,9,[7 8]); ax.NextPlot = 'add';
plot(ax,idxs,PWDists.TibiaDorsalMid_vs_TibiaDorsalConstriction,'Color',[.8 .8 .8])
l1 = plot(ax,idxs(~weird_frames),PWDists.TibiaDorsalMid_vs_TibiaDorsalConstriction(~weird_frames)); hold on
plot(ax,idxs,PWDists.TibiaDorsalBulge_vs_TibiaDorsalMid,'Color',[.8 .8 .8])
l2 = plot(ax,idxs(~weird_frames),PWDists.TibiaDorsalBulge_vs_TibiaDorsalMid(~weird_frames)); hold on
ax.YLim = [0 900];

ax = subplot(2,9,[16 17]);
plot(ax,PWDists.TibiaDorsalMid_vs_TibiaDorsalConstriction,PWDists.TibiaDorsalBulge_vs_TibiaDorsalMid,'.','Color',[.8 .8 .8]), hold on
plot(ax,PWDists.TibiaDorsalMid_vs_TibiaDorsalConstriction(~weird_frames),PWDists.TibiaDorsalBulge_vs_TibiaDorsalMid(~weird_frames),'.'), hold on
ax.XLim = [0 900];
ax.YLim = [0 900];

ax = subplot(2,9,9);
[N] = hist(PWDists.TibiaDorsalMid_vs_TibiaDorsalConstriction,bins);
plot(ax,bins,N,'color',l1.Color); hold on
plot(ax,[bounds(1,6),bounds(1,6)],[0 max(N)],'Color',l1.Color);
plot(ax,[bounds(2,6),bounds(2,6)],[0 max(N)],'Color',l1.Color);
[N] = hist(PWDists.TibiaDorsalBulge_vs_TibiaDorsalMid,bins);
plot(ax,bins,N,'color',l2.Color);
plot(ax,[bounds(1,7),bounds(1,7)],[0 max(N)],'Color',l2.Color);
plot(ax,[bounds(2,7),bounds(2,7)],[0 max(N)],'Color',l2.Color);
ax.XLim = [0 900];
ax.View = [90 -90];
end