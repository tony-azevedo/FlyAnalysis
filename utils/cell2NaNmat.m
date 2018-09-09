function nanmat = cell2NaNmat(cel)

nanmat = nan(size(cel));
int_idx = find(~isempty(cel(:)),2,'first');

doublelength = 
for r = 1:size(cel,1)
    for c = 1:size(cel,2)
        if isempty(cell{r,c})
            continue
        elseif