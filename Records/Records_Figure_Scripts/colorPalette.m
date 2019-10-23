%% color palette for figure

% current 16 bit colors for the paper:

hexclrs = [
    '3C489E'
    'D64C90'
    'F9A61A'
    '00FF00'
    '47DDFF'
    '03AC72'
];
clrs = hex2rgb(hexclrs);

%{
clrs =

    0.2353    0.2824    0.6196
    0.8392    0.2980    0.5647
    0.0118    0.6745    0.4471
    0.9765    0.6510    0.1020
         0    1.0000         0
    0.2784    0.8667    1.0000
%}

figure
plot(0)
ax = gca, hold on;
for r = 1:size(clrs,1)
    plot(ax,[0 1],[-r,-r],'color',clrs(r,:),'linewidth',2);
end
