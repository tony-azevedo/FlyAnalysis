ind = [];
for d = 1:length(data)
    if data(d).displacement == 1 % data(d).freq == 100
        ind(end+1) = d;
    end
end

trials = [];
i = 1;
for i = 1:length(ind)
    trials(end+1) = data(ind(i)).trial;
end

trials = trials(trials<68);

resp = zeros(length(trials),length(voltage));
for t = 1:length(trials)
    load(sprintf('PiezoStep_Raw_07-Jun-2013_F1_C1_%d.mat',trials(t)))
    resp(t,:) = voltage;
end
obj.params = data(trials(1));
x = ((1:obj.params.sampratein*obj.params.durSweep) - obj.params.preDurInSec*obj.params.sampratein)/obj.params.sampratein;

subplot(3,1,[1 2])
plot(x,resp')
subplot(6,1,5)
plot(x,sgsmonitor)
subplot(6,1,6)
plot(x,mean(resp))