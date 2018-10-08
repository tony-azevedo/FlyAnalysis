function [SampleInfo, data] = AddressNaNs(interpolationMethod, bodypartData, tempSwf, triggerTime, nFrames, interpolateXnans)
%function Address NaNs is hella specific to MothTracking analysis atm
trialData.abdo = bodypartData.abdomen(3,:);
trialData.head = bodypartData.head(3,:);

startidx = find(trialData.head(1,:)~=0);
trackstart = startidx(1);
tempHead = trialData.head;
tempAbd = trialData.abdo;
nanIdxHead = isnan(tempHead);
nanIdxAbdo = isnan(tempAbd);
run = zeros(4,length(tempHead));

switch interpolationMethod
    case 'dont'
            run(1,:) = 1:length(trialData.head);
            run(2,:) = 1:length(trialData.head);
            run(3,:) = trialData.head(1,:);
            run(4,:) = trialData.abdo(1,:);
    case 'none'
        j = 0;
        for i = 1:length(tempHead)
            if i >= trackstart && nanIdxAbdo(i) == 0 && nanIdxHead(i) == 0
                run(1,i) = i - j;
                run(2,i) = i;
                run(3,i) = trialData.head(1,i);
                run(4,i) = trialData.abdo(1,i);
            else
                j = i;
            end
        end
    case 'previous' % needs to pull in actual info not just change NaNidx
        nanIdxAbdo_interprev = nanIdxAbdo;
        nanIdxHead_interprev = nanIdxHead;
        for i = 2:length(nanIdxAbdo)-1
            if nanIdxAbdo(i) == 1 && nanIdxAbdo(i-1) == 0 && nanIdxAbdo(i+1) == 0
                nanIdxAbdo_interprev(i) = 0;
                trialData.abdo(1,i) = trialData.abdo(1,i-1);
            end
            if nanIdxHead(i) == 1 && nanIdxHead(i-1) == 0 && nanIdxHead(i+1) == 0
                nanIdxHead_interprev(i) = 0;
                trialData.head(1,i) = trialData.head(1,i-1);
            end
        end
        j = 0;
        for i = 1:length(tempHead)
            if i > trackstart && nanIdxAbdo_interprev(i) == 0 && nanIdxHead_interprev(i) == 0
                run(1,i) = i - j;
                run(2,i) = i;
                run(3,i) = trialData.head(1,i);
                run(4,i) = trialData.abdo(1,i);
            else
                j = i;
            end
        end
    case 'linear'
        nanIdxAbdo_interlin = nanIdxAbdo;
        nanIdxHead_interlin = nanIdxHead;
        for k = 1:interpolateXnans % this can be condensed into one loop
            if k == 1
                for i = 2:length(nanIdxAbdo)-k
                    if nanIdxAbdo(i) == 1 && nanIdxAbdo(i-1) == 0 && nanIdxAbdo(i+1) == 0
                        nanIdxAbdo_interlin(1,i) = 0;
                        trialData.abdo(1,i) = trialData.abdo(i-1) + ((trialData.abdo(i+1) - trialData.abdo(i-1))/2);
                    end
                    if nanIdxHead(i) == 1 && nanIdxHead(i-1) == 0 && nanIdxHead(i+1) == 0
                        nanIdxHead_interlin(1,i) = 0;
                        trialData.head(1,i) = trialData.head(i-1) + ((trialData.head(i+1) - trialData.head(i-1))/2);
                    end
                end
            elseif k == 2
                for i = 2:length(nanIdxAbdo)-k
                    if sum(nanIdxAbdo(i:i+1)) == 2 && nanIdxAbdo(i-1) == 0 && nanIdxAbdo(i+2) == 0
                        nanIdxAbdo_interlin(1,i:i+1) = 0;
                        trialData.abdo(1,i) = trialData.abdo(i-1) + ((trialData.abdo(i+2) - trialData.abdo(i-1))/3);
                        trialData.abdo(1,i+1) = trialData.abdo(i-1) + ((trialData.abdo(i+2) - trialData.abdo(i-1))/3)*2;
                    end
                    if sum(nanIdxHead(i:i+1)) == 2 && nanIdxHead(i-1) == 0 && nanIdxHead(i+2) == 0
                        nanIdxHead_interlin(1,i:i+1) = 0;
                        trialData.head(1,i) = trialData.head(i-1) + ((trialData.head(i+2) - trialData.head(i-1))/3);
                        trialData.head(1,i+1) = trialData.head(i-1) + ((trialData.head(i+2) - trialData.head(i-1))/3)*2;
                    end
                end
            elseif k == 3
                for i = 2:length(nanIdxAbdo)-k
                    if sum(nanIdxAbdo(i:i+2)) == 3 && nanIdxAbdo(i-1) == 0 && nanIdxAbdo(i+3) == 0
                        nanIdxAbdo_interlin(1,i:i+2) = 0;
                        trialData.abdo(1,i) = trialData.abdo(i-1) + ((trialData.abdo(i+3) - trialData.abdo(i-1))/4);
                        trialData.abdo(1,i+1) = trialData.abdo(i-1) + ((trialData.abdo(i+3) - trialData.abdo(i-1))/4)*2;
                        trialData.abdo(1,i+2) = trialData.abdo(i-1) + ((trialData.abdo(i+3) - trialData.abdo(i-1))/4)*3;
                    end
                    if sum(nanIdxHead(i:i+2)) == 3 && nanIdxHead(i-1) == 0 && nanIdxHead(i+3) == 0
                        nanIdxHead_interlin(1,i:i+2) = 0;
                        trialData.head(1,i) = trialData.head(i-1) + ((trialData.head(i+3) - trialData.head(i-1))/4);
                        trialData.head(1,i+1) = trialData.head(i-1) + ((trialData.head(i+3) - trialData.head(i-1))/4)*2;
                        trialData.head(1,i+2) = trialData.head(i-1) + ((trialData.head(i+3) - trialData.head(i-1))/4)*3;
                    end
                end
            elseif k == 4
                for i = 2:length(nanIdxAbdo)-k
                    if sum(nanIdxAbdo(i:i+3)) == 4 && nanIdxAbdo(i-1) == 0 && nanIdxAbdo(i+4) == 0
                        nanIdxAbdo_interlin(1,i:i+3) = 0;
                        trialData.abdo(1,i) = trialData.abdo(i-1) + ((trialData.abdo(i+4) - trialData.abdo(i-1))/5);
                        trialData.abdo(1,i+1) = trialData.abdo(i-1) + ((trialData.abdo(i+4) - trialData.abdo(i-1))/5)*2;
                        trialData.abdo(1,i+2) = trialData.abdo(i-1) + ((trialData.abdo(i+4) - trialData.abdo(i-1))/5)*3;
                        trialData.abdo(1,i+3) = trialData.abdo(i-1) + ((trialData.abdo(i+4) - trialData.abdo(i-1))/5)*4;
                    end
                    if sum(nanIdxHead(i:i+3)) == 4 && nanIdxHead(i-1) == 0 && nanIdxHead(i+4) == 0
                        nanIdxHead_interlin(1,i:i+3) = 0;
                        trialData.head(1,i) = trialData.head(i-1) + ((trialData.head(i+4) - trialData.head(i-1))/5);
                        trialData.head(1,i+1) = trialData.head(i-1) + ((trialData.head(i+4) - trialData.head(i-1))/5)*2;
                        trialData.head(1,i+2) = trialData.head(i-1) + ((trialData.head(i+4) - trialData.head(i-1))/5)*3;
                        trialData.head(1,i+3) = trialData.head(i-1) + ((trialData.head(i+4) - trialData.head(i-1))/5)*4;
                    end
                end
            else
                disp('Too many NaNs to interpolate - write more code...');
            end
        end
        j = 0;
        for i = 1:length(tempHead)
            if i > trackstart && nanIdxAbdo_interlin(i) == 0 && nanIdxHead_interlin(i) == 0
                run(1,i) = i - j;
                run(2,i) = i;
                run(3,i) = trialData.head(1,i);
                run(4,i) = trialData.abdo(1,i);
            else
                j = i;
            end
        end
end % end switch case interpolation method loop

maxrun = max(run(1,:));
maxrunidx = abs((find(run(1,:) == maxrun)) - maxrun + 1);

if maxrunidx + maxrun + 1 > nFrames
    runend = nFrames;
else
    runend = maxrunidx + maxrun + 1;
end

data.headangle = run(3,maxrunidx:runend);
data.abdoangle = run(4,maxrunidx:runend);
SampleInfo(:,1) = maxrun;
SampleInfo(:,2) = maxrunidx(1);
data.Stime = triggerTime(1,maxrunidx:runend);
data.Swf = tempSwf(1,maxrunidx:runend);
end