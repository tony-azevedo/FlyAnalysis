rawfiles = dir('PiezoSine_Image_*');

for rf = 1:length(rawfiles)
    movefile(rawfiles(rf).name,regexprep(rawfiles(rf).name,'PiezoSine','Sweep'));
end