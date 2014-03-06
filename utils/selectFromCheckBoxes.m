function selected = selectFromCheckBoxes(ids,comments,varargin)
p = inputParser;
p.PartialMatching = 0;
p.addParameter('title','',@ischar);
p.addParameter('prechecked',[],@islogical);
p.parse(varargin{:});

if ~isempty(p.Results.prechecked) && length(p.Results.prechecked) ~= length(ids)
    error('Prechecked input is not the same length as the checkbox ids')
end

longestcomment = 0;
for c = 1:length(comments)
    if length(comments{c})>longestcomment
        longestcomment = length(comments{c});
    end
end
longestcomment = max(longestcomment,10);
height = 24*length(ids)+40;
width = 20 * longestcomment+60;
f = figure('units','pixels','Position',[645 158 width+40 height+40],'toolbar','none','menubar','none','ButtonDownFcn',@doubleclicktoclose);

selector = uipanel(f,'units','pixels','Position',[20 20 width height],'Title',p.Results.title);
chckbxs = zeros(size(ids));
    
chckbxs(end) = uicontrol(selector,'Style','checkbox','units','pixels','String',[num2str(ids(end)) ': ' comments{end}]);
curpos = get(chckbxs(end),'position');
if ~isempty(p.Results.prechecked(end))
    set(chckbxs(end),'Value',p.Results.prechecked(end))
end

for i_ind = length(ids)-1:-1:1
    chckbxs(i_ind) = uicontrol(selector,'Style','checkbox','units','pixels','position',curpos + [0 curpos(4) 0 0],'String',[num2str(ids(i_ind)) ': ' comments{i_ind}]);
    curpos = get(chckbxs(i_ind),'position');    
    if ~isempty(p.Results.prechecked(i_ind))
        set(chckbxs(i_ind),'Value',p.Results.prechecked(i_ind))
    end
end

uiwait(f);

if ~ishghandle(f), selected = []; return, end

for i_ind = 1:length(chckbxs)
    chckbxs(i_ind) = get(chckbxs(i_ind),'Value');
end
close(f);

selected = logical(chckbxs);



function doubleclicktoclose(hobject,evnt)
persistent chk
if isempty(chk)
      chk = 1;
      pause(0.5); %Add a delay to distinguish single click from a double click
      if chk == 1
          chk = [];
      end
else
      chk = [];
      uiresume(hobject)
end

