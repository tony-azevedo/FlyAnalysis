% Shortcut summary goes here
figs = dir('C:\Users\Anthony Azevedo\Desktop\Rachel Meeting\Figure_*.pdf');
numext = length(figs)+1;
eval(sprintf('export_fig C:\\Users\\Anthony'' Azevedo''\\Desktop\\Rachel'' Meeting''\\Figure_%d -pdf -transparent',numext));
fprintf('** Figure_%d saved\n',numext);