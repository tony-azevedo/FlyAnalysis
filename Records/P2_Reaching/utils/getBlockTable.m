function bT = getBlockTable(T)
blcks = unique(T.block);
blcks = blcks(blcks>0);
bT = T(1:length(blcks),:);
bT = table(bT.block,bT.trial,bT.hiforce,bT.target1,bT.target2,'VariableNames',{'block','trial','hiforce','target1','target2'});
bT = addvars(bT,bT.trial,'After','trial','NewVariableNames','trial_end');
trlims = zeros(height(bT),2);
for bl = 1:length(blcks)
    idx = T.block==blcks(bl);
    bT.block(bl) = blcks(bl);
    bT.trial(bl) = min(T.trial(idx));
    bT.trial_end(bl) = max(T.trial(idx));
    bT.hiforce(bl) = max(T.hiforce(idx));
    trgts = [T.target1(idx) T.target2(idx)];
    if ~all(trgts(:,1)==trgts(1,1)) || ~all(trgts(:,2)==trgts(1,2))
        bT.target1(bl) = mode(trgts(:,1));
        bT.target1(bl) = trgts(find(trgts(:,1)==bT.target1(bl),1),2);
    else
        bT.target1(bl) = trgts(1,1);
        bT.target2(bl) = trgts(1,2);
    end
end

