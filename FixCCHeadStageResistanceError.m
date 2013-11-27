%% Fix any traces that have the wrong gain (several folders)
f = figure(1);
ax = plot(0);
ax = get(ax,'parent');
wrongfiles = {'131115','131119','131120','131121','131122'};
for wf = 1:length(wrongfiles)
    cd(['C:\Users\Anthony Azevedo\Raw_Data\' wrongfiles{wf}])
    cellfolders = dir([wrongfiles{wf} '*']);
    for cf = 1:length(cellfolders)
        if cellfolders(cf).isdir
            cd(cellfolders(cf).name)
            rigs = dir('*Rig*');
            load(rigs(1).name);
            if rigStruct.devices.amplifier.params.headstageresistorCC ~= ...
                    rigStruct.devices.amplifier.params.headstageresistorVC ...
                    && ...
                    rigStruct.devices.amplifier.params.scaledcurrentscale_over_gain == ...
                    1e-12 * rigStruct.devices.amplifier.params.headstageresistorCC % [V/pA] * gainsetting
                
                % would like to change rigStruct.devices.amplifier.params.scaledcurrentscale_over_gain
                rigStruct.devices.amplifier.params.scaledcurrentscale_over_gain
                rigStruct.devices.amplifier.setParams('scaledcurrentscale_over_gain', 1e-12*rigStruct.devices.amplifier.params.headstageresistorVC); % [V/pA] * gainsetting
                rigStruct.devices.amplifier.params.scaledcurrentscale_over_gain

                save(rigs(1).name, 'rigStruct');

                % rigStruct.devices.amplifier.params.scaledcurrentscale_over_gain = 1e-12*rigStruct.devices.amplifier.params.headstageresistorCC; % [V/pA] * gainsetting
                for rn = 2:length(rigs)
                    rig2 = load(rigs(rn).name);
                    if rig2.rigStruct.devices.amplifier.params.headstageresistorCC ~= ...
                            rig2.rigStruct.devices.amplifier.params.headstageresistorVC ...
                            && ...
                            rig2.rigStruct.devices.amplifier.params.scaledcurrentscale_over_gain == ...
                            1e-12 * rig2.rigStruct.devices.amplifier.params.headstageresistorCC % [V/pA] * gainsetting
                        
                        rig2.rigStruct.devices.amplifier.setParams('scaledcurrentscale_over_gain', 1e-12*rigStruct.devices.amplifier.params.headstageresistorVC); % [V/pA] * gainsetting
                        save(rigs(rn).name, '-struct','rig2');
                        
                    end
                end

                rawfiles = dir('*_Raw_*');
                for rf = 1:length(rawfiles)
                    data = load(rawfiles(rf).name);
                    if sum(strcmp('VClamp',data.params.mode))
                        plot(data.current), hold on
                        data.current =...
                            data.current *...
                            (1e-12 * rigStruct.devices.amplifier.params.headstageresistorCC * data.params.gain)...
                            / ...
                            (1e-12 * rigStruct.devices.amplifier.params.headstageresistorVC * data.params.gain);
                        plot(data.current,'r'), hold off;
                        set(ax,'children',flipud(get(ax,'children')))
                        
                        pause
                        save(regexprep(data.name,'Acquisition','Raw_Data'), '-struct', 'data');
                        
                    end
                end
            end
            cd ..
        end
    end
end




