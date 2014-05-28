function g = genotypoToFilename(g)

g = regexprep(g,'/','!');
%Stupid clean up
g = regexprep(g,':',';');