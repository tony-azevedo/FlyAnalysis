p = polyfit(x,y,1);

N = length(x);

reps = 1000;
vals = nan([2,reps]);

for i = 1:reps
    ind_r = randi(N,size(x));
    
    vals(:,i) = polyfit(x(ind_r),y(ind_r),1);
end

m = vals(1,:);
b = vals(2,:);

figure(101)
subplot(2,1,1)
hist(m(:),optimalBinWidth(m(:)))
ylims = get(gca,'ylim');
hold on;
plot([p(1) p(1)], ylims,'--','color',[1 0 0]);

subplot(2,1,2)
hist(b(:),optimalBinWidth(b(:)))
ylims = get(gca,'ylim');
hold on;
plot([p(2) p(2)], ylims,'--','color',[1 0 0]);

[b_0,order] = sort(b);
m_0 = m(order);
b_95 = [0 0];
b_95(1) = b_0(round(reps*0.025));
b_95(2) = b_0(round(reps*0.975));
b_m95(1) = m_0(round(reps*0.025));
b_m95(2) = m_0(round(reps*0.975));

[m_0,order] = sort(m);
b_0 = b(order);
m_95 = [0 0];
m_95(1) = m_0(round(reps*0.025));
m_95(2) = m_0(round(reps*0.975));
m_b95(1) = b_0(round(reps*0.025));
m_b95(2) = b_0(round(reps*0.975));
