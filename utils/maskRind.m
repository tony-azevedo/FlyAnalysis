function rind = maskRind(I_mask)

[FX,FY] = gradient(I_mask);
for c = 1:size(FY,2);
    r = find(FY(:,c));
    r_min = min(r);
    r_max = max(r);
    FY(:,c) = 0;
    FY(r_min,c) = 1;
    FY(r_max,c) = 1;
end
for r = 1:size(FX,2);
    c = find(FX(r,:));
    c_min = min(c);
    c_max = max(c);
    FX(r,:) = 0;
    FX(r,c_min) = 1;
    FX(r,c_max) = 1;
end
rind = FX + FY;
rind(rind>0) = 1;
