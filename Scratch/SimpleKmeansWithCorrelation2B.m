%Revised on 2016/12/21. Doesn't show the avg image or the cluster with
%different color anymore. No other difference.
%
%Writtenon 2016/11/1. Because of the memory issues (running out of memory
%when calculating the correlations between each pixels), this verison
%doesn't run the correlation analysis for now. (we can run it one by one,
%but after the third one it seems to run out of memory) We probably also
%need to check if there is something wrong with the computer's memory
%usage, because this was not happening before.
%
%Written on 2016/09/12. Just have a option to select manually the region in
%addition to the PixelThreshold. Useful when we have some bright spot in
%the image that is clearly not responding. Save with the same name so we
%don't have to change the next script. Also changed the color plotting
%scheme of the cluster map. 
%
%Written on 2016/07/06 based on SimpleKmeansTest and SimlePCATest. This version uses
%correlation as the "Distance" for clustering the pixels. Need to apply
%threshold before clustering to chose the responding pixels. For now we
%apply absolute threshold to the top 10% of the intensity recorded from
%that pixel during the entire trial. We can use other measures if it is
%more suitable. This is necessary because background pixels share some type
%of correlated noise. They cluster together.
%
%PixelThreshold of 100 seems to work well.
%BaselinN of 10 seems to work well.
%
%Written on 2016/06/30. Basically the Kmeans clustering and DFF calculation
%part of the SimplePCAandKmeans3.
%
%Revised on 2016/06/28. Now we specify how many K-means clustering to
%repeat so that we don't get stuck in local minima.
%
%
%Revised on 2016/06/22. Now calculates DF/F using N consecutive frames with the least
%average fluorescence for each ROI
%
%Written on 2016/06/21. Simple start for the PCA and Kmeans analysis.
%Needs some improvement.
%Plots out DF/F lines for all the groups.
%May be define ROI first?

function []=SimpleKmeansWithCorrelation2B(InFile,NofClusters,BaselineN,Repetition,PixelThreshold)

%Load the *ReadAndAdjustImages9.mat files.
load(InFile);
clear MultiImage MultiImageG MultiImageGC MultiImageGGC;%Clear so that we don't get confused.

%make an average image so it will be easy to find the region of interest.
AvgImage=mean(MovementAdjMultiImageGGC,3);
%We will calculate baseline differently now.
%BaseImage=mean(MovementAdjMultiImageGGC(:,:,BeginB:EndB),3);

%figure;
%imshow(AvgImage, []);

NofRows=size(MovementAdjMultiImageGGC,1);
NofColumns=size(MovementAdjMultiImageGGC,2);
NofPixels=NofRows*NofColumns;
NofFrames=size(MovementAdjMultiImageGGC,3);

Test=reshape(MovementAdjMultiImageGGC,[NofPixels, NofFrames]);
Test2=Test';%For calculating PC in the other direction.

%Sort the image to get high intensity values and apply threshold.
SortedImage=sort(MovementAdjMultiImageGGC,3,'descend');
%This is hard coded for now, but can be specified.
PercentToUse=10;
FramesToUse=ceil(NofFrames*PercentToUse/100);

MaxMeanImage=mean(SortedImage(:,:,1:FramesToUse),3);
figure,imshow(MaxMeanImage,[])

%Manual selection of the responding region.
ManualMask=roipoly;

Mask3=MaxMeanImage>=PixelThreshold;

%Put the two together.
Mask3=Mask3&ManualMask;

[idx1,C1]=kmeans(Test(Mask3,:),NofClusters,'Distance','correlation','Replicates',Repetition);

%Go through each pixels and assign cluster number. Background will be zero.
idx3=zeros(NofPixels,1);
m=1;
for n=1:NofPixels
    if Mask3(n)==0
        idx3(n)=0;
    else
        idx3(n)=idx1(m);
        m=m+1;
    end
end

ClustersInImage=reshape(idx3,[NofRows NofColumns]);
%figure,imshow(ClustersInImage,[])
%colormap(gca,'jet')
TempMap=[0 0 0;1 0 0;0 1 0;0 0 1;1 0 1;1 1 0;0 1 1];
figure,imshow(ClustersInImage,[])
colormap(gca,TempMap(1:NofClusters+1,:));

%Make DFF with the following code.
AvgInt1=zeros(NofClusters,NofFrames);
DFF1=zeros(NofClusters,NofFrames);
BoxAverage1=zeros(NofClusters,NofFrames-BaselineN+1);

figure
hold on
for n=1:NofClusters
    TempCluster=Test(idx3==n,:);
    AvgInt1(n,:)=mean(TempCluster,1);
    %For each cluster, calculate the running average with BaselineN frames
    %each.
    for m=1:(NofFrames-BaselineN)+1
        BoxAverage1(n,m)=mean(AvgInt1(n,m:m+BaselineN-1));
    end
    Baseline=min(BoxAverage1(n,:));
    DFF1(n,:)=(AvgInt1(n,:)-Baseline)/Baseline;
    %For now we make it so that we will re do the loop one more time if
    %there are more than 4 clusters.Won't be able to have more than 8 for
    %now.
    if n<=size(TempMap,1)-1
        plot(DFF1(n,:)','Color',TempMap(n+1,:))
    else
        plot(DFF1(n,:)','Color',TempMap(mod(n,7)+2,:))
    end
end
hold off



%Correlation before clustering.
%R1=corrcoef(Test(Mask3,:)');
%figure,imshow(R1,[])


%For plotting the correlation matrix.
%Cluster1size=sum(idx3==1);
%Cluster2size=sum(idx3==2);
%Cluster3size=sum(idx3==3);
%Cluster4size=sum(idx3==4);
%Cluster1=Test(idx3==1,:);
%Cluster2=Test(idx3==2,:);
%Cluster3=Test(idx3==3,:);
%Cluster4=Test(idx3==4,:);
%Test3=Cluster1;
%Test3(end+1:end+Cluster2size,:)=Cluster2;
%Test3(end+1:end+Cluster3size,:)=Cluster3;
%Test3(end+1:end+Cluster4size,:)=Cluster4;
%R2=corrcoef(Test3');
%figure,imshow(R2,[])
%colormap(gca,'jet')

position=strfind(InFile,'.'); %gives the position of the period in the string FileName. This is the last of the set of the files from the same region.
NewName=InFile(1:position-1); %string NewName has the file name without the ".tiff".

Outfile = strcat(NewName,'SimpleKmeansWithCorrelation');
save(Outfile,'BaselineN','BoxAverage*','Clusters*','AvgInt*','DFF*','idx*','C1');


clear
