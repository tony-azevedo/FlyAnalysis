%Written on 2017/03/07. A script that goes through the standard routine for
%NMF and DF/F extraction using typical dendrites/axons parameters.
%
%Specify appropriate K.
%For files that doesn't work, re-run with different K or different
%parameters.

function []=RunNMF_All_DendritesAxons(K)
%load the *ReadAndAdjustImages9.mat file.
ImageFiles=dir('*ReadAndAdjustImages9.mat');
NofFiles=size(ImageFiles,1);

%Set of parameters for Dendrites/Axons.
tau=[];

%For now don't use the edges, because they contain movement artifact.
%The edge is fixed for now.
d1=216;
d2=216;
d=d1*d2;

options = CNMFSetParms(...
'd1',d1,'d2',d2,...                           % dimensions of datasets
'init_method','HALS',...                      % initialize algorithm with plain NMF
'max_iter_hals_in',50,...                     % maximum number of iterations
'search_method','dilate',...                  % search locations when updating spatial components
'temporal_iter',2,...                         % number of block-coordinate descent steps
'merge_thr',0.8,...                           % merging threshold
'conn_comp',false,...                         % do not limit to largest connected component for each found component
'maxthr',0.05...                              % for every component set pixels that are below max_thr*max_value to 0
);

TempColorMap=[1 0 0; 0 1 0; 0 0 1; 0 0 0;1 0 1;0 1 1;1 1 0];


%Go through each file in order.
for n=1:NofFiles
    %Show the name
    ImageFiles(n).name
    %Load the file
    load(ImageFiles(n).name);
    GCaMPSignal=MovementAdjMultiImageGGC(21:236,21:236,:);
    %T is different for different file.
    T=size(GCaMPSignal,3);
    %Run the preprocessing step
    [P,Y]=preprocess_data(GCaMPSignal,0);
    %Initialize the components.
    [Ain,Cin,bin,fin,center] = initialize_components(Y,K,tau,options,P);  % initialize
    %Need to reshape the Y so that we can update the spatial components.
    Yr = reshape(Y,d,T);
    %Update spatial components.
    [A,b,Cin] = update_spatial_components(Yr,Cin,fin,[Ain, bin],P,options);
    %Update temporal components.
    [C,f,P,S] = update_temporal_components(Yr,A,b,Cin,fin,P,options);
    %Extract DF/F for each components.
    [C_df,Df]=extract_DF_F(Yr,A,C,P,options)
    %Show spatial components map.
    for m=1:K
        SpatialMap=reshape(A(:,m),[216,216]);
        SpatialMap=full(SpatialMap);
        figure,imshow(SpatialMap,[])
    end
    %plot the DF/F
    figure,
    for m=1:K
       plot(C_df(m,:),'color',TempColorMap(m,:));
       hold on
    end
    %Save the data.
    position=strfind(ImageFiles(n).name,'.'); %gives the position of the period in the string FileName
    NewName=ImageFiles(n).name(1:position-1); %string NewName has the file name without the ".tiff".
    Outfile = strcat(NewName,'_NMF_DendritesAxons');
    save(Outfile,'C*','Df','b','A','fin','P','options','Y*');

    
end






clear
