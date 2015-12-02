function varargout = findSineCycle(s_,start,cycles)

c_ = diff(s_);

%s_ = s_ - (max(s_)+min(s_))/2;
logical_u = s_(1:end-1) <= 0;
logical_o = s_(2:end) > 0;

logical_ascd = logical_u & logical_o;
logical_ascd = logical_ascd(1:end-1);

logical_u = c_(1:end-1) <= 0;
logical_o = c_(2:end) > 0;

logical_vall = logical_u & logical_o;

logical_o = s_(1:end-1) >= 0;
logical_u = s_(2:end) < 0;

logical_desc = logical_u & logical_o;
logical_desc = logical_desc(1:end-1);

logical_o = c_(1:end-1) >= 0;
logical_u = c_(2:end) < 0;

logical_peak = logical_u & logical_o;

% figure; plot(x_,s_,'color',[.8 .8 .8]),hold on
% plot([x_(find(logical_ascd,1)) x_(find(logical_ascd,1))],[-1 1],'r')
% plot([x_(find(logical_peak,1)) x_(find(logical_peak,1))],[-1 1],'g')
% plot([x_(find(logical_desc,1)) x_(find(logical_desc,1))],[-1 1],'b')
% plot([x_(find(logical_vall,1)) x_(find(logical_vall,1))],[-1 1],'m')

ascd = find(logical_ascd);
peak = find(logical_peak);
desc = find(logical_desc);
vall = find(logical_vall);


switch start
    case 0
        peak = peak(peak>ascd(1));
        desc = desc(desc>ascd(1));
        vall = vall(vall>ascd(1));
    case 1/2
        ascd = ascd(ascd>peak(1));
        desc = desc(desc>peak(1));
        vall = vall(vall>peak(1));
    case 1
        ascd = ascd(ascd>desc(1));
        peak = peak(peak>desc(1));
        vall = vall(vall>desc(1));
    case 3/2
        ascd = ascd(ascd>vall(1));
        peak = peak(peak>vall(1));
        desc = desc(desc>vall(1));
    otherwise
        error('Enter either 0, 1/2, 1, or 3/2')
end
l = min([length(ascd) length(peak) length(desc) length(vall)]);
cyclemat = [ascd(1:l)';peak(1:l)';desc(1:l)';vall(1:l)'];

if isempty(cycles)
    cycles = size(cyclemat,2);
end
varargout = {cyclemat(:,1:cycles),ascd,peak,desc,vall};










