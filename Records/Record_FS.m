%% Record_FS - take from the different types and agreggate here
close all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS';
if ~isdir(savedir)
    mkdir(savedir)
end

%Record_FS_BandPassHiB1s
%Record_FS_BandPassLowB1s
%Record_FS_LowPassB1s
%Record_FS_HighFreqDepolB1s

% Script_FrequencySelectivity
% Script_FS_f1_f2
% Script_FS_CurrentChirpAndSteps % and others

% Populations
close all
%uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_LowPassB1s\LP_PiezoSineOsciRespVsFreq.fig',1)
uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_LowPassB1s\LP_PiezoSineOsciRespVsFreq_Aggregate.fig',1)
fig_low = gcf;
ax_low = findobj(fig_low,'type','axes','tag','mag_0.15');

%uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassLowB1s\BPL_PiezoSineOsciRespVsFreq.fig',1)
uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassLowB1s\BPL_PiezoSineOsciRespVsFreq_Aggregate.fig',1)
fig_bpl = gcf; 
ax_bpl = findobj(fig_bpl,'type','axes','tag','mag_0.15');

% uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassHighB1s\BPH_PiezoSineOsciRespVsFreq.fig',1)
uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassHighB1s\BPH_PiezoSineOsciRespVsFreq_Aggregate.fig',1)
fig_bph = gcf; 
ax_bph  = findobj(fig_bph,'type','axes','tag','mag_0.15');

% uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_HighPassB1s\HP_PiezoSineDepolRespVsFreq.fig',1)
uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_HighPassB1s\HP_PiezoSineDepolRespVsFreq_Aggregate.fig',1)
fig_hi = gcf; 
ax_hi = findobj(fig_hi,'type','axes','tag','mag_0.15');

fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 3 10 3.7],'name','Summary_FrequencySelectivity');
pnl = panel(fig);
pnl.margin = [20 18 6 12];
pnl.pack('h',4);
pnl.de.margin = [4 4 4 4];

copyobj(get(ax_low,'children'),pnl(1).select()); set(pnl(1).select(),'tag',get(ax_low,'tag'))
copyobj(get(ax_bpl,'children'),pnl(2).select()); set(pnl(2).select(),'tag',get(ax_bpl,'tag'))
copyobj(get(ax_bph,'children'),pnl(3).select()); set(pnl(3).select(),'tag',get(ax_bph,'tag'))
copyobj(get(ax_hi,'children'),pnl(4).select()); set(pnl(4).select(),'tag',get(ax_hi,'tag'))

axs = [pnl(1).select(),pnl(2).select(),pnl(3).select(),pnl(4).select()];
set(axs,'xscale','log','xlim',[16 600],'xtick',[25 100 400],'tickdir','out');

set(findobj(fig,'color',[0 0 0]),'marker','none','color',[1 1 1]*.8);

set(findobj(fig,'color',[0 1/3*2 0]),...
    'markeredgecolor',[0 0 0],'markerfacecolor',[0 0 0],'color',[0 0 0])

set([pnl(1).select(),pnl(2).select(),pnl(3).select()],'ylim',[0 6],'ytick',[2 4 6])
set([pnl(4).select()],'ylim',[0 15],'ytick',[5 10 15])

pnl.fontname = 'Arial';
pnl.fontsize = 18;

xlabel(pnl(1).select(),'(Hz)');
ylabel(pnl(1).select(),'Magnitude (mV)');

fn = fullfile(savedir, 'Summary_FrequencySelectivity.pdf');
figure(fig)
eval(['export_fig ' regexprep(fn,'\sAzevedo',''' Azevedo''') ' -pdf -transparent']);

ls = findobj(fig,'type','line','marker','o');
for l = ls'
    axname = get(get(l,'parent'),'tag');
    set(l,'tag',['ave_' axname],'color',[0 0 0],'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0]);
end

savePDFandFIG(fig,savedir,[],'FS_Summary_0_15')

%% Color the Fru-Gal4
base_clr = [1 1 1]*0.92;
set(findobj(fig,'type','line','-not','marker','o'),'color',base_clr);

ls = findobj(fig,'type','line','marker','o');
for l = ls' 
    set(l,'color',[1 1 1],'markerfacecolor',[1 1 1],'markeredgecolor',[1 1 1]);
    uistack(l,'bottom');
end


genotypes = {'FruGal4/+';
    '20XUAS-mCD8:GFP;VT27938-Gal4';
    'VT30609';
    'GH86-Gal4/GH86-Gal4;pJFRC7/pJFRC7;'
    'pJFRC7;VT45599-Gal4'};

clrs = [
    0 0 1
    1 0 0
    0 1 0
    0 1 0
    0 1 0
    ];


for g = 1:length(genotypes)
    geno = genotypes{g};
    ls = findobj(fig,'color',base_clr,'type','line','-regexp','tag',geno);
    if ~isempty(ls)
        
        set(ls,'color',clrs(g,:))
        legend_lines(g) = ls(1);
        savePDFandFIG(fig,savedir,[],['FS_' regexprep(geno,{'/','+',';','-',':'}, {'_','','','_',''})])
        pause
        set(findobj(fig,'type','line','-not','marker','o'),'color',base_clr);
    end
end



%% examples
close all

trials = {
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\PiezoSine_Raw_150513_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_56.mat';    
}

fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 3 10 3],'name','Summary_FrequencySelectivity');
pnl = panel(fig);
pnl.margin = [20 18 6 12];
pnl.pack('h',4);
pnl.de.margin = [4 4 4 4];

trial = load(analysis_cell(c_ind).PiezoSineTrial);
obj.trial = trial;

[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

cnt = cnt+1;
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

if exist('f','var') && ishandle(f), close(f),end

% hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
[transfer{cnt},freqs{cnt},dsplcmnts{cnt}] = PiezoSineDepolRespVsFreq([],obj,'');
f = findobj(0,'tag','PiezoSineDepolRespVsFreq');
if save_log
    p = panel.recover(f);
    if isfield(obj.trial.params,'trialBlock'), tb = num2str(obj.trial.params.trialBlock);
    else tb = 'NaN';
    end
    fn = fullfile(savedir,[id dateID '_' flynum '_' cellnum '_' tb '_',...
        'PiezoSineDepolRespVsFreq.pdf']);
    p.fontname = 'Arial';
    p.export(fn, '-rp','-l','-a1.4');
end

%% PCA on Freq_Selectivity 
close all
uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_LowPassB1s\LP__PiezoSineOsciRespVsFreq.fig',1)
fig_low = gcf; chi_low = get(gcf,'children');

uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassLowB1s\BPL__PiezoSineOsciRespVsFreq.fig',1)
fig_bpl = gcf; chi_bpl = get(gcf,'children');

uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassHighB1s\BPH__PiezoSineOsciRespVsFreq.fig',1)
fig_bph = gcf; chi_bph = get(gcf,'children');

% uiopen('C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_HighPassB1s\HP_PiezoSineDepolRespVsFreq.fig',1)
% fig_hi = gcf; chi_hi = get(gcf,'children');

H0_categories = {'chi_low', 'chi_bpl', 'chi_bph'};%, 'chi_hi'};
ofinterest = [9,7,5];
ofinterest = [8,6,4];

ls = findobj(chi_low(9),'color',[0 0 0]);
names = cell(size(ls));
y_dim = 0;
for n_idx = 1:length(names)
    names{n_idx} = get(ls(n_idx),'tag');
    if length(get(ls(n_idx),'ydata'))> y_dim
        y_dim = length(get(ls(n_idx),'ydata'));
        x = get(ls(n_idx),'xdata');
    end
end
x = round(x*100)/100;

Y = [];
group0 = [];
for cat_idx = 1:length(H0_categories)
    eval(['chi = ' H0_categories{cat_idx}]);
    
    ls = findobj(chi(9),'color',[0 0 0]);
    names = cell(size(ls));
    for n_idx = 1:length(names)
        names{n_idx} = get(ls(n_idx),'tag');
    end
    
    y = nan(length(x),length(names));
    ys = [];
    for oi_idx = 1:length(ofinterest)
        for n_idx = 1:length(names)
            ls = findobj(chi(ofinterest(oi_idx)),'tag',names{n_idx});
            [~,~,idx] = intersect(round(get(ls,'xdata')*100)/100,x);
            y(idx,n_idx) = get(ls,'ydata');
        end
        ys = [ys;y];
    end
    Y = [Y, ys];
    group0 = [group0, cat_idx*ones(1,length(names))];
end

figure, hold on
plot(Y)

X0 = repmat(x(:),3,size(Y,2));
Y0 = Y;
x0 = x;
%% PCA
%Y = bsxfun(@minus,Y,mean(Y,1));
%[coeff1,score1,latent,tsquared,explained,mu1] = pca(y,...
%'algorithm','als');

%% First attempt - get rid of 17, 800 Hz, get rid of NaN columns

X = reshape(X0(X0~=x0(1) & X0~=x0(end)),(length(x0)-2)*3,[]);
Y = reshape(Y0(X0~=x0(1) & X0~=x0(end)),(length(x0)-2)*3,[]);
x = x0(2:end-1);
x = repmat(x(:),3,1);

cols = 1:size(Y,2);
for c_idx = 1:length(cols)
    cols(c_idx) = sum(isnan(Y(:,c_idx)))>0;
end

Y = Y(:,~cols);
group = group0(:,~cols);

[U,sigma,V] = svd(Y,0); 

% project the responses into a lower dimensional space that captures 99%
% of the energy.  the projections are then a D x N matrix in the space
% spaned by the orthonormal column vectors of U (the operation performed by
% U'M).

% M = U sig V';
% U'M = U'U sig V';
% U'M = sig V';

AX = sigma*V';

% column (:,1) of AX is the projection of 1st column vec of Y along PCs
% column (:,2) of AX is the projection of 2nd column vec of Y along PCs
% row (1,:) of AX is the projection of Y columns on to 1st PC
% row (2,:) of AX is the projection of Y columns on to 2nd PC

figure; hold on
for g_idx = (unique(group));
plot3(AX(1,group == g_idx),AX(2,group == g_idx),AX(3,group == g_idx),'.')
end

%% Second attempt - get rid of 17, 800 Hz, get rid of NaN columns, subtract mean -
% This works better than the previous case, PC2 does a pretty good job of
% separating the categories: Low has the largest projection onto PC2, BPH
% has the smallest

X = reshape(X0(X0~=x0(1) & X0~=x0(end)),(length(x0)-2)*3,[]);
Y = reshape(Y0(X0~=x0(1) & X0~=x0(end)),(length(x0)-2)*3,[]);
x = x0(2:end-1);

cols = 1:size(Y,2);
for c_idx = 1:length(cols)
    cols(c_idx) = sum(isnan(Y(:,c_idx)))>0;
end

Y = Y(:,~cols);
Y = bsxfun(@minus,Y,mean(Y,1));

group = group0(:,~cols);

[U,sigma,V] = svd(Y,0); 
variances = diag(sigma).^2;
energyfrac = cumsum(variances)/sum(variances);
disp(energyfrac(1:3))

AX = sigma*V';
figure(6); clf, hold on
for g_idx = (unique(group));
plot3(AX(1,group == g_idx),AX(2,group == g_idx),AX(3,group == g_idx),'.','markersize',12,'displayname',H0_categories{g_idx})
end
legend('toggle')
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')

figure(7); clf, hold on
x = x0(2:end-1);
plot(x,reshape(U(:,1),[],3),'color',[0 0 1]);
plot(x,reshape(U(:,2),[],3),'color',[1 0 0]);
plot(x,reshape(U(:,3),[],3),'color',[0 1 0]);

%% Third attempt - subtract the nan mean, use this weird algorithm

Y = bsxfun(@minus,Y0,nanmean(Y0,1));

group = group0;

[U,AX,latent,tsquared,explained,mu1] = pca(Y','algorithm','als');
energyfrac = cumsum(explained)/sum(explained);
disp(energyfrac(1:3))


figure(6); clf, hold on
for g_idx = (unique(group));
plot3(AX(1,group == g_idx),AX(2,group == g_idx),AX(3,group == g_idx),'.','markersize',12,'displayname',H0_categories{g_idx})
end
legend('toggle')
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')

figure(7); clf, hold on
x = x0;
plot(x,reshape(U(:,1),[],3),'color',[0 0 1]);
plot(x,reshape(U(:,2),[],3),'color',[1 0 0]);
plot(x,reshape(U(:,3),[],3),'color',[0 1 0]);

%% Fourth attempt - get rid of NaN rows, subtract mean -

%X = reshape(X0(X0~=x0(1) & X0~=x0(end)),(length(x0)-2)*3,[]);
Y = Y0;
%x = x0(2:end-1);

rows = 1:size(Y,1);
for r_idx = 1:length(rows)
    rows(r_idx) = sum(isnan(Y(r_idx,:)))>0;
end

Y = Y(~rows,:);
X = X0(~rows,:);
Y = bsxfun(@minus,Y,mean(Y,1));

group = group0(:,~cols);

[U,sigma,V] = svd(Y,0); 
variances = diag(sigma).^2;
energyfrac = cumsum(variances)/sum(variances);
disp(energyfrac(1:3))

AX = sigma*V';
figure(6); clf, hold on
for g_idx = (unique(group));
plot3(AX(1,group == g_idx),AX(2,group == g_idx),AX(3,group == g_idx),'.','markersize',12,'displayname',H0_categories{g_idx})
end
legend('toggle')
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')

figure(7); clf, hold on
x = unique(X(:));
plot(x,reshape(U(:,1),[],3),'color',[0 0 1]);
plot(x,reshape(U(:,2),[],3),'color',[1 0 0]);
plot(x,reshape(U(:,3),[],3),'color',[0 1 0]);

%% Fifth attempt - use the strange algorithm to recreate the data, 
% then try to project it into the space spanned by the eigenvectors found
% in the first place

%X = reshape(X0(X0~=x0(1) & X0~=x0(end)),(length(x0)-2)*3,[]);
Y = Y0;
%x = x0(2:end-1);

rows = 1:size(Y,1);
for r_idx = 1:length(rows)
    rows(r_idx) = sum(isnan(Y(r_idx,:)))>0;
end

Y = Y(~rows,:);
X = X0(~rows,:);
Y = bsxfun(@minus,Y,mean(Y,1));

group = group0(:,~cols);

[U,sigma,V] = svd(Y,0); 
variances = diag(sigma).^2;
energyfrac = cumsum(variances)/sum(variances);
disp(energyfrac(1:3))

AX = sigma*V';
figure(6); clf, hold on
for g_idx = (unique(group));
plot3(AX(1,group == g_idx),AX(2,group == g_idx),AX(3,group == g_idx),'.','markersize',12,'displayname',H0_categories{g_idx})
end
legend('toggle')
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')

figure(7); clf, hold on
x = unique(X(:));
plot(x,reshape(U(:,1),[],3),'color',[0 0 1]);
plot(x,reshape(U(:,2),[],3),'color',[1 0 0]);
plot(x,reshape(U(:,3),[],3),'color',[0 1 0]);




