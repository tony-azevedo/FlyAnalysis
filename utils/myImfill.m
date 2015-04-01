function mask_o = myImfill(mask)
mask_o = mask;
% mask_ind = mask;
for c = 1:size(mask,2);
    for r = 1:size(mask,1);
        r_1 = find(mask(:,c));
        c_1 = find(mask(r,:));
%         mask_ind(r,c) = nan
        if length(r_1)>=2 && length(c_1)>=2
            if r > r_1(1) && r < r_1(end) && c>c_1(1) && c<c_1(end)
                mask_o(r,c) = 1;
            end
        end
%         mask_ind(r,c) = mask_o(r,c);
    end
end
