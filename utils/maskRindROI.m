function rind = maskRindROI(I_mask)

[FX,FY] = gradient(I_mask);

for c = 1:size(FY,2);
    r = find(FY(:,c)<0);
    skip = 0;
    for r_ind = 1:length(r)
        if skip == 1
            skip = 0;
            continue;
        end
        if r_ind<length(r) && r(r_ind+1) == r(r_ind)+1
            FY(r(r_ind+1),c) = -1;
            FY(r(r_ind),c) = 0;
            skip = 1;
        elseif r_ind==length(r)
            FY(r(r_ind),c) = -1;
        else
            FY(r(r_ind),c) = -1;
        end
    end
    
    r = find(FY(:,c)>0);
    skip = 0;
    for r_ind = 1:length(r)
        if skip == 1
            skip = 0;
            continue;
        end
        if r_ind<length(r) && r(r_ind+1) == r(r_ind)+1
            FY(r(r_ind),c) = 1;
            FY(r(r_ind+1),c) = 0;
            skip = 1;
        elseif r_ind==length(r)
            FY(r(r_ind),c) = 1;
        else
            FY(r(r_ind),c) = 1;
        end
    end
end

for r = 1:size(FX,1);
    c = find(FX(r,:)<0);
    skip = 0;
    for c_ind = 1:length(c)
        if skip == 1
            skip = 0;
            continue;
        end
        if c_ind<length(c) && c(c_ind+1) == c(c_ind)+1
            FX(r,c(c_ind+1)) = -1;
            FX(r,c(c_ind)) = 0;
            skip = 1;
        elseif c_ind==length(c)
            FX(r,c(c_ind)) = -1;
        else
            FX(r,c(c_ind)) = -1;
        end
    end
    
    c = find(FX(r,:)>0);
    skip = 0;
    for c_ind = 1:length(c)
        if skip == 1
            skip = 0;
            continue;
        end
        if c_ind<length(c) && c(c_ind+1) == c(c_ind)+1
            FX(r,c(c_ind)) = 1;
            FX(r,c(c_ind+1)) = 0;
            skip = 1;
        elseif c_ind==length(c)
            FX(r,c(c_ind)) = 1;
        else
            FX(r,c(c_ind)) = 1;
        end
    end
end

rind = abs(FX) + abs(FY);
rind(rind>0) = 1;

