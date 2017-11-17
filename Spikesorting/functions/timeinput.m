function output = timeinput(t)
% TIMEINPUT
% Input arguments:
% t - time delay

% Creating a figure
h = figure('Position',[500 650 130 80],'MenuBar','none',...
'NumberTitle','off','Name','Stop?');
% Creating an Edit field
% hedit = uicontrol('style','edit','Units','pixels','Position',[10 15 200 25],'callback','uiresume','string',default_string);
hedit = uicontrol('Style', 'pushbutton', 'String', {'Click to change','spike distance threshold'},...
        'Position', [20 20 100 50],...
        'Callback', 'uiresume','value',1);    

uiwait(h,t);
output = get(hedit,'value');
close(h);
clear hedit;

end