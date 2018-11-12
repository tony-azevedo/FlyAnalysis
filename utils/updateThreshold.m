function updateThreshold(src,evnt,smooshedframe,mask,sldr,edtr,dispax)
persistent hOVM
if isempty(hOVM)
    hOVM =findobj(dispax,'Tag','blwthresh');
end
delete(hOVM);

if strcmp(src.Style,'edit')
    src.Value = str2double(src.String);
end
trial.kmeans_threshold = src.Value;
sldr.Value = src.Value;
edtr.Value = src.Value;
edtr.String = num2str(edtr.Value);
blwthresh = smooshedframe<trial.kmeans_threshold & mask;
blwthresh = imgaussfilt(double(blwthresh),3)>.1;

hold(dispax,'on');

hOVM = alphamask(blwthresh, [0 0 1],.3,dispax);
hOVM.Tag = 'blwthresh';
hOVM.UserData = src.Value;
drawnow
end

