function [Bodypart1, Bodypart2, Bodypart3] = OrganizeCsvBodyParts(fileData, liklihoodthresh) % data = trialData.data
    % [BodyPart1, BodyPart2, BodyPart3] = OrganizeCsvBodyParts(data)
    table = fileData.data(:,2:end);
    bodyparts = fileData.textdata(2:end);
    
    for bp = 1:3:(length(bodyparts)-2)
        fileData.(bodyparts{bp}) = (table(:,bp:bp+2))';
    end
    for bp = 1:3:length(bodyparts)
        for liklihoodcheck = 1:length(fileData.(bodyparts{bp}))
            if fileData.(bodyparts{bp})(3,liklihoodcheck) > liklihoodthresh
                DLC.(bodyparts{bp})(1:2,liklihoodcheck) = fileData.(bodyparts{bp})(1:2,liklihoodcheck);
            else DLC.(bodyparts{bp})(1:2,liklihoodcheck) = NaN;
            end
        end
    end
    
    DistAbd = DLC.dist_abd_x(1:2,:);    
    ProxAbd = DLC.prox_abd_x(1:2,:);
    DistHead = DLC.dist_head_x(1:2,:);
    ProxHead = DLC.prox_head_x(1:2,:);     
    DistAnt = DLC.dist_ant_x(1:2,:);     
    ProxAnt = DLC.prox_ant_x(1:2,:);
    
    Bodypart1(1,:) = DistAbd(1,:) - ProxAbd(1,:);
    Bodypart1(2,:) = DistAbd(2,:) - ProxAbd(2,:);  
    
    Bodypart2(1,:) = DistHead(1,:) - ProxHead(1,:);
    Bodypart2(2,:) = DistHead(2,:) - ProxHead(2,:);
    
    Bodypart3(1,:) = DistAnt(1,:) - ProxAnt(1,:);
    Bodypart3(2,:) = DistAnt(2,:) - ProxAnt(2,:);
    
    Bodypart1(3,:) = 360 - abs((atan2(Bodypart1(2,:),Bodypart1(1,:)))*(180/pi));
    Bodypart2(3,:) = 360 - abs((atan2(Bodypart2(2,:),Bodypart2(1,:)))*(180/pi));
    Bodypart3(3,:) = 360 - abs((atan2(Bodypart3(2,:),Bodypart3(1,:)))*(180/pi));   
end