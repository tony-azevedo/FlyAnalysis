%% Reading a continuous file, 5000 entries at a time
classdef ContinuousDataReader < handle
    
    properties
        filename
        name
        D
        filesize
        afid
        dfid
        datastart
        pointer
        entrybytes
        di_start
        di_pointer
        gains
        channels
        ai_channels
        di_channels
        channels_to_display
        protocol
        samprate
        
        ffwfig
        ffwaiax
        ffwdiax
        ffwrefax
        ffwposax
        
        ovfig
        ovax
        ovcntax
        
        cookiesize
        cookieunits
        
        cookie
        cookietime
        trial_index
        protocol_hashes
        trialnumber
        
        target
        posylims
        voltageylims
        
        statecount
        probebins
        probehist
        approx_framerate
        extracted
    end
    
    properties (Hidden, SetAccess = protected)
        cookiesamps
        delptr_persamp_A
        delptr_persamp_D
        
        pos_line
        ref_line
        sgs_line
        ai_ch_lines
        di_ch_lines
        cookie_x
        cookie_trial_index
        lastrefchanval

        samp0
        samp1
        viz_ch
        viz_ai_ch
        viz_di_ch
        probe_bounds
        posylims_
        voltageylims_
        
        probe_comb
        last_seen_samp
        

        nextbutt
        nexttrialbutt
        prevbutt
        prevtrialbutt
        sizeedit
        gotoedit
        refchedit
        trialedit
        resizebutt
        vizucheck
        quickShow
        
        edgetarget
        
        cm
    end
    
    methods
        function obj = ContinuousDataReader(filename,varargin)
            obj.readHeader(filename);
            obj.readDHeader;
            obj.channels = cat(1,obj.ai_channels,obj.di_channels);
            obj.viz_ch = true(size(obj.channels));
            obj.viz_ai_ch = true(size(obj.ai_channels));
            obj.viz_di_ch = true(size(obj.di_channels));
            tmp = dir(obj.name);
            obj.filesize = tmp.bytes;
            obj.cookieunits = 'seconds';
            obj.samp0 = 0;
            obj.samp1 = 0;
            obj.statecount = [0;0];
            obj.probebins = (200:5:1000)';
            obj.probehist = 0 * obj.probebins(1:end-1);
            obj.last_seen_samp = 0;
            obj.extracted = false;
            obj.setclrmap;
            obj.nextCookie;
            
            
            %% Load continuous acquisition map
            if exist(regexprep(filename,'.bin','_map.mat'),'file')
                obj.loadmap(filename);
                if obj.extracted
                    obj.cleanupFigure();
                end
            else 
                obj.ffwRead(40);
                obj.savemap();
                obj.plotCookie();
            end
            
        end
        
        function ffwRead(obj,varargin)
            if nargin > 1
                obj.cookiesize = varargin{1};
                if numel(obj.cookiesize)>1
                    obj.cookiesize = obj.cookiesize;
                end
            end
            while obj.readCookie
                fprintf('Current time: %g s, %g trials\n',obj.samp1/obj.samprate,length(obj.trial_index));
            end
        end
        
        function extractProtocolFiles(obj,trial)
            
            if obj.extracted
                fprintf('Protocols are already extracted.\nIf re-extracting, run:\ncdr.extracted = false\ncdr.saveMap\ncdr.extractProtocolFiles\n')
            end
            
            % find all the protocols
            cd(obj.D) % just in case
            a = dir(fullfile(obj.D,'*_Raw*'));
            protocols = {};
            for i = 1:length(a)
                ind = regexpi(a(i).name,'_');
                if contains(char(65:90),a(i).name(1)) && ...
                        ~isempty(ind) && ...
                        ~sum(strcmp(protocols,a(i).name(1:ind(1)-1)))
                    protocols{end+1} = a(i).name(1:ind(1)-1); %#ok<AGROW>
                end
            end
            
            % Need a look up table for stimrefvals
            map = load('controlProtocolRefValueMap');
            stimRefVals = zeros(size(protocols));
            for p = 1:length(protocols)
                try stimRefVals(p) = map.(protocols{p});
                catch e
                    fprintf('No reference value for protocol %s\n',protocols{p})
                    e.rethrow
                end
            end
            
            if isempty(obj.target)
                obj.target = [1
                                0
                                0];
            end

            prtcl_extracted = false(size(protocols));
            % Go through each trial in the acquisition file and put it in a
            % Control file. If there isn't a control file, copy the last
            % one and make it up. If there is a question about params,
            % leave them empty.
            
            for r_idx = 1:length(stimRefVals)
                refval = stimRefVals(r_idx);
                prtcl = protocols{r_idx};
                prtcl_index = find(obj.protocol_hashes==refval);
                tr_index = obj.trial_index(prtcl_index);
                trnums = obj.trialnumber(prtcl_index);
                fprintf('Extracting %s:\n',prtcl)

                if length(unique(trnums))<length(trnums)
                    % perhaps some numbers got written over...
                    fprintf('Perhaps some numbers got written over. Using unique trialnumbers.\n')
                    fprintf('Repeat trial numbers exist, using the larger indices.\n')
                    overwritten_trialindices = find(diff(trnums)==0);
                    keepindices = true(size(trnums));
                    keepindices([diff(trnums)==0,false]) = false;
                    prtcl_index = prtcl_index(keepindices);
                    tr_index = tr_index(keepindices);
                    trnums = trnums(keepindices);
                end
                
                prtclfiles = dir([prtcl '_Raw*']);   
                [~,d] = fileparts(obj.D);
                trialStem = [prtcl '_Raw_' d '_%d.mat'];
                if isempty(prtcl_index)
                    fprintf('Trials for protocol %s exist, but no ref chan values\n',prtcl)
                    % count the protocol_extracted for the purposes of 
                    ptcl_extracted(r_idx) = true;
                elseif length(prtcl_index) > length(prtclfiles)
                    fprintf('More trial indices exist than saved control trials.\nThis likely reflects aborted trials. Using prtclfiles\n')
                elseif length(prtcl_index) < length(prtclfiles)
                    fprintf('Trials in continuous acquisition don''t line up with control files.\n')
                    if all(ismember(trnums,(1:length(prtclfiles))))
                        fprintf('A subset of control trials are in this continuous acquisition file.\n')
                    else
                        error('Handle the case where not all trials have a prtcl file\n')
                    end
                else
                end
                
                lastextracted = 0;
                for i = 1:length(tr_index)
                    n1 = tr_index(i);
                    
                    % Has this been run?
                    % You can run this as many times as you like but if
                    % data has already been extracted, skip it for now
                    trinfo = dir(fullfile(obj.D,sprintf(trialStem,trnums(i))));
                    if trinfo.bytes>100000
                        % data has likely been extracted, go on to next
                        % file.
                        fprintf('.')
                        lastextracted = 1;
                        continue
                    elseif lastextracted == 1
                        lastextracted = 0;
                        fprintf('\n')
                    end
                        
                    try trial = load(fullfile(obj.D,sprintf(trialStem,trnums(i))));
                    catch e
                        if contains(e.identifier, 'MATLAB:load:couldNotReadFile') && trnums(i)>length(prtclfiles)
                            fprintf('%s\nLikely an aborted trial\n',e.message)
                            fprintf('Saved trial %d. Done!\n',i-1)
                        else
                            e.rethrow
                        end
                    end
                    if i< length(tr_index)
                        n2 =  tr_index(i+1)-1;
                    else
                        n2 = n1+(trial.params.durSweep+.5)*obj.samprate; % last trial
                    end
                    
                    obj.gotoSection(n1,n2);
                    obj.plotCookie();
                    
                    lasttarget = find(obj.target(1,:)<n1,1,'last');
                    trial.target_location = obj.target([2 3],lasttarget);
                    trial.starttime = n1/obj.samprate;
                    trial.startsample = n1;
                    
                    for ch = 1:length(obj.channels)
                        if ~startsWith(obj.channels{ch},'b_') && ~strcmp(obj.channels{ch},'refchan')
                            cstr = obj.channels{ch};
                            trial.(cstr) = obj.cookie(strcmp(obj.channels,cstr),1:trial.params.durSweep*obj.samprate);
                            trial.intertrial.(cstr) = obj.cookie(strcmp(obj.channels,cstr),trial.params.durSweep*obj.samprate+1:end);
                        end
                    end
                    
                    save(trial.name,'-struct','trial');
                    if rem(i,10)==0
                        drawnow
                        fprintf('Saving %s trial %d\n',prtcl,trnums(i))
                    end
                end
                fprintf('Saving %s trial %d. Done!\n',prtcl,i)
                prtcl_extracted(r_idx) = true;
            end
            if all(prtcl_extracted)
                obj.extracted = true;
                obj.savemap
            end
        end
        
        function openFFWFig(obj)
            if isempty(obj.ffwfig) || ~ishghandle(obj.ffwfig)
                obj.ffwfig = figure;
                obj.ffwfig.Position = [2 140 1891 848];
                panl = panel(obj.ffwfig);
                panl.pack('v',{1/6 1/6 2/6 2/6})  % response panel, stimulus panel
                panl.margin = [18 10 2 20];
                panl.fontname = 'Arial';
                panl(1).marginbottom = 2;
                panl(2).margintop = 2;
                panl(3).margintop = 10;
                panl(4).margintop = 10;
                
                obj.ffwdiax = panl(1).select();
                obj.ffwrefax = panl(2).select();
                obj.ffwposax = panl(3).select();
                obj.ffwaiax = panl(4).select();
                
                obj.ffwdiax.YLim = [-.1 1.1];
                obj.ffwposax.YLim = [20 900];
                obj.ffwrefax.YLim = [-1 11];
                obj.ffwaiax.YLim = [-60 10];
                
                obj.ffwdiax.XAxis.Visible = 'off';
                
                linkaxes([obj.ffwaiax,obj.ffwdiax],'x')
                
                obj.nextbutt = uicontrol('Parent',obj.ffwfig,'Style','pushbutton','Position',[1800 824 40 20],'String','->');
                obj.prevbutt = uicontrol('Parent',obj.ffwfig,'Style','pushbutton','Position',[1750 824 40 20],'String','<-');
                obj.sizeedit = uicontrol('Parent',obj.ffwfig,'Style','edit','Position',[1700 824 40 20],'String',num2str(obj.cookiesize));
                obj.gotoedit = uicontrol('Parent',obj.ffwfig,'Style','edit','Position',[1650 824 40 20],'String',num2str(obj.cookietime(1)));

                obj.nexttrialbutt = uicontrol('Parent',obj.ffwfig,'Style','pushbutton','Position',[1800 800 40 20],'String','->');
                obj.prevtrialbutt = uicontrol('Parent',obj.ffwfig,'Style','pushbutton','Position',[1750 800 40 20],'String','<-');
                obj.trialedit = uicontrol('Parent',obj.ffwfig,'Style','edit','Position',[1700 800 40 20],'String',num2str(0));
                obj.refchedit = uicontrol('Parent',obj.ffwfig,'Style','edit','Position',[1650 800 40 20],'String',num2str(0));

                obj.resizebutt = uicontrol('Parent',obj.ffwfig,'Style','pushbutton','Position',[1600 824 40 20],'String','resize');
                obj.vizucheck = uicontrol('Parent',obj.ffwfig,'Style','togglebutton','Position',[1600 800 40 20],'String','An In');
                obj.quickShow = uicontrol('Parent',obj.ffwfig,'Style','pushbutton','Position',[1550 824 40 20],'String','qckSh');
                obj.quickShow.Visible = obj.extracted;
                if obj.extracted
                    obj.quickShow.Enable = 'on';
                else
                    obj.quickShow.Enable = 'off';
                end
                
                obj.nextbutt.Callback = @(btn,event) obj.nextCookieButt(btn);
                %obj.nextbutt.Enable = 'off';
                obj.prevbutt.Callback = @(btn,event) obj.prevCookieButt(btn);
                %obj.prevbutt.Enable = 'off';
                
                obj.nexttrialbutt.Callback = @(btn,event) obj.nextTrialButt(btn);
                %obj.nexttrialbutt.Enable = 'off';
                obj.prevtrialbutt.Callback = @(btn,event) obj.prevTrialButt(btn);
                %obj.prevtrialbutt.Enable = 'off';
                
                obj.sizeedit.Callback = @(edt,event) obj.changeCookieSize(edt);
                obj.gotoedit.Callback = @(edt,event) obj.gotoCookie(edt);
                obj.refchedit.Callback = @(edt,event) obj.gotoTrial(edt);
                obj.trialedit.Callback = @(edt,event) obj.gotoTrial(edt);
                obj.resizebutt.Callback = @(btn,event) obj.resizeAxes(btn);
                obj.vizucheck.Callback = @(btn,event) obj.toggleAnalogInput(btn);
                obj.vizucheck.Value = 1;
                obj.quickShow.Callback = @quickShow;
                
                figure(obj.ffwfig);
                
            end
            if ~isempty(obj.cookie) && isempty(obj.ffwaiax.Children)
                obj.replaceCookieLines;
            end
        end

        function nextTrialButt(obj,btn)
            curtrial = str2double(obj.trialedit.String);
            refchval = str2double(obj.refchedit.String);
            if isnan(curtrial) || isnan(refchval)
                error('Handle case')
            end
            idx = find(obj.trialnumber==curtrial & obj.protocol_hashes==refchval);
            if idx == length(obj.trialnumber)
                % at last trial
                fprintf('At last trial\n')
                return
            elseif isempty(idx)
                error('Handle this case')
            else
                idx = idx+1;
            end 
            obj.trialedit.String = num2str(obj.trialnumber(idx));
            obj.refchedit.String = num2str(obj.protocol_hashes(idx));
            obj.gotoTrial(obj.trialedit);
        end

        function prevTrialButt(obj,btn)
            curtrial = str2double(obj.trialedit.String);
            refchval = str2double(obj.refchedit.String);
            if isnan(curtrial) || isnan(refchval)
                error('Handle case')
            end
            idx = find(obj.trialnumber==curtrial & obj.protocol_hashes==refchval);
            if idx == 1
                % at first trial
                fprintf('At trial 1\n')
                return
            elseif isempty(idx)
                error('Handle this case')
            else
                idx = idx-1;
            end 
            obj.trialedit.String = num2str(obj.trialnumber(idx));
            obj.refchedit.String = num2str(obj.protocol_hashes(idx));
            obj.gotoTrial(obj.trialedit);
        end
        
        function nextCookieButt(obj,btn)
            obj.nextCookie;
        end

        function prevCookieButt(obj,btn)
            time1 = obj.currentTime-obj.cookiesize;
            if time1<0
                time1=0;
            end
            smp1 = round(time1*obj.samprate);
            smp2 = smp1+obj.cookiesize*obj.samprate;
            obj.gotoSection(smp1,smp2);
            obj.plotCookie();
        end

        function resizeAxes(obj,btn)
            obj.voltageylims = [];
            obj.posylims = [];
            obj.plotCookie
        end
        
        function t = currentTime(obj)
            t = obj.cookietime(1);         
        end

        
        function st = nextCookie(obj,varargin)
            % adjust cookie size
            if nargin>1
                obj.cookiesize = varargin{1};
            end
            if isempty(obj.cookiesize)
                obj.cookiesize = 10;
            end
            st = obj.readCookie;
            if ~st
                return
            end
            obj.plotCookie
        end

        function plotCookie(obj)
            % plot the cookie
            obj.openFFWFig
            % obj.replaceCookieLines
            if isempty(obj.pos_line) || ~all(isvalid(obj.ai_ch_lines)) || length(obj.ai_ch_lines(1).YData) ~= obj.cookiesamps
                obj.replaceCookieLines
            elseif length(obj.ai_ch_lines(1).YData) == obj.cookiesamps
                % Just change the data
                obj.pos_line.XData = obj.cookietime;
                obj.pos_line.YData = obj.cookie(strcmp(obj.channels,'probe_position'),:);
                obj.ref_line.XData = obj.cookietime;
                obj.ref_line.YData = obj.cookie(strcmp(obj.channels,'refchan'),:);
                obj.sgs_line.XData = obj.cookietime;
                obj.sgs_line.YData = obj.cookie(strcmp(obj.channels,'sgsmonitor'),:);
                for ch = 1:length(obj.ai_ch_lines)
                    obj.ai_ch_lines(ch).XData = obj.cookietime;
                    obj.ai_ch_lines(ch).YData = obj.cookie(strcmp(obj.channels,obj.ai_ch_lines(ch).Tag),:);
                end
                for ch = 1:length(obj.di_channels)
                    obj.di_ch_lines(ch).XData = obj.cookietime;
                    obj.di_ch_lines(ch).YData = obj.cookie(strcmp(obj.channels,obj.di_channels{ch}),:);
                end
            else
                error('What is this case?')
            end
            obj.cleanupFigure
        end

        function time = makeCookieTime(obj,in)
            if ~isstruct(in)
                params.durSweep = in;
            else 
                params = in;
            end
            time = (0:1:round(params.durSweep*obj.samprate) -1)/obj.samprate;
            if isfield(params,'preDurInSec')
                time = time-params.preDurInSec;
            end
            time = time(:);
        end
        
        function changeCookieSize(obj,edt)
            obj.cookiesize = str2double(edt.String);
            if numel(obj.cookiesize)>1
                obj.cookiesize = obj.cookiesize(1);
            end
            smp1 = obj.currentTime*obj.samprate;
            smp2 = smp1+obj.cookiesize*obj.samprate;

            obj.gotoSection(smp1,smp2);
            obj.plotCookie();
        end
        
        function gotoTrial(obj,edt)
            trialNum = str2double(obj.trialedit.String);
            refchval = str2double(obj.refchedit.String);
            if isnan(trialNum) && strcmp(obj.trialedit.String,'end')
                trialNum = max(obj.trialnumber);
            elseif isnan(trialNum) && strcmp(obj.trialedit.String,'init')
                trialNum = obj.trialnumber(1);
                refchval = obj.protocol_hashes(1);
            elseif isnan(trialNum)
                fprintf('invalid entry\n');
                return
            end

            curidx = find(obj.trial_index>=obj.samp0,1,'first');
            if ~any(obj.trialnumber==trialNum)
                trialNum = obj.trialnumber(curidx);
                fprintf('No such trial number\n');
            end
            if ~any(obj.protocol_hashes==refchval)
                refchval = obj.protocol_hashes(curidx);
                fprintf('No such protocol hash\n');
            end
            idx = find(obj.trialnumber==trialNum & obj.protocol_hashes==refchval);
            if isempty(idx)
                smp1 = obj.samp0;
            else                
                smp1 = obj.trial_index(idx);
            end
            smp2 = smp1+obj.cookiesize*obj.samprate;
            obj.gotoSection(smp1,smp2);
            obj.plotCookie();
        end
        
        function gotoCookie(obj,edt)
            time1 = str2double(edt.String);
            smp1 = round(time1*obj.samprate);
            smp2 = smp1+obj.cookiesize*obj.samprate;
            obj.gotoSection(smp1,smp2);
            obj.plotCookie();
        end

        function st = gotoAndPlotSection(obj,smp1,smp2)
            % Trials will have to start within the length of the trial, so
            % make that the initial cookie size
            obj.gotoSection(smp1,smp2);
            obj.plotCookie();
        end

        function st = gotoSection(obj,n1,n2)
            % Trials will have to start within the length of the trial, so
            % make that the initial cookie size
            if n2<=n1
                error('n2 must be larger than n1')
            end
            T = (n2-n1)/obj.samprate;
            obj.cookiesize = T;

            st = fseek(obj.afid,obj.smp2ptr(n1),-1);
            if st<0
                ferror(obj.afid)
                error('fseek cannot access pointer')
            end
            [dptr, extra] = obj.smp2dptr(n1);
            fseek(obj.dfid,dptr,-1);
            for i=1:extra
                fread(obj.dfid,1,'ubit1=>double');
            end
                        
            st = obj.readCookie;
            if ~st
                return
            end
        end
        
        function st = readCookie(obj)
            obj.cookiesamps = round(obj.cookiesize*obj.samprate);            
            nextreads = obj.cookiesamps;
            
            % Read more data
            nextcookie = obj.readnext(nextreads);
            if isempty(nextcookie)
                obj.savemap; % just to update last_seen_samp
                st = false;
                return
            end
            
            % filter the probe position and look for targetchanges
            nextcookie = obj.filterProbePosition(nextcookie);
            nextcookie = obj.detectTargetChanges(nextcookie);
            
            if obj.samp1 > obj.last_seen_samp
                nextcookie = obj.filterStimhashval(nextcookie);
            end
            obj.updateoverview(nextcookie);
            nextcookie = obj.customFilters(nextcookie);
            
            if isempty(obj.cookie) && size(nextcookie,2) < obj.cookiesamps
                % there is not enough data to fill out the cookie
                obj.cookie = nextcookie;
                obj.cookiesamps = size(nextcookie,2);
                obj.cookie_x = ((1:obj.cookiesamps) - 1)/obj.samprate;
                obj.cookietime = obj.cookie_x;
                obj.cookiesize = obj.cookiesamps/obj.samprate; 
                st = true;
                return
            end

            if size(nextcookie,2) == obj.cookiesamps
                obj.cookie = nextcookie;
            elseif size(nextcookie,2) < obj.cookiesamps
                % reached the end of the file, 
                % slide the old cookie over
                if obj.cookiesamps == size(obj.cookie,2)
                    obj.cookie(:,1:obj.cookiesamps-size(nextcookie,2)) = obj.cookie(:,size(nextcookie,2)+1:obj.cookiesamps);
                    % put the next cookie at the end
                    obj.cookie(:,obj.cookiesamps-size(nextcookie,2)+1:obj.cookiesamps) = nextcookie;
                else % might have gotten to end of file by extending a cookie
                    obj.cookie = nextcookie;
                    obj.cookiesamps = size(nextcookie,2);
                    obj.cookiesize = obj.cookiesamps/obj.samprate;
                end
            end
            obj.cookie_x = ((1:size(obj.cookie,2)) - 1)/obj.samprate;
            obj.cookietime = obj.samp0/obj.samprate + obj.cookie_x;            
            st = true;
        end
        
        function chooseChannels(obj,chnnames)
            aichns = cell(size(obj.ai_ch_lines));
            for tg = 1:length(obj.ai_ch_lines)
                aichns{tg} = obj.ai_ch_lines(tg).Tag;
            end
            
            obj.viz_ai_ch(:) = false;
            for n = 1:length(chnnames)
                if any(strcmp(aichns,chnnames{n}))
                    fprintf('%s is visible\n',chnnames{n});
                    obj.viz_ai_ch(strcmp(aichns,chnnames{n})) = true;
                end
            end
            set(obj.ai_ch_lines(obj.viz_ai_ch),'Visible','on')
            set(obj.ai_ch_lines(~obj.viz_ai_ch),'Visible','off')
            obj.ylims = [];
            obj.cleanupFigure
        end
        
        function delete(obj)
            fclose(obj.afid);
            fclose(obj.dfid);
            try close(obj.ffwfig);
            catch e
                ...
            end
        end
        
        function toggleAnalogInput(obj,butt)
            if butt.Value
                obj.showAnalogInput();
            else
                obj.hideAnalogInput()
            end
        end
        
        function showAnalogInput(obj)
            obj.viz_ai_ch(:) = true;
            set(obj.ai_ch_lines(obj.viz_ai_ch),'Visible','on')
            set(obj.ai_ch_lines(~obj.viz_ai_ch),'Visible','off')
            obj.cleanupFigure
        end
        
        function hideAnalogInput(obj)
            obj.viz_ai_ch(:) = false;
            aichns = cell(size(obj.ai_ch_lines));
            for tg = 1:length(obj.ai_ch_lines)
                aichns{tg} = obj.ai_ch_lines(tg).Tag;
            end
            obj.viz_ai_ch(strcmp(aichns,'voltage_1')) = true;
            set(obj.ai_ch_lines(obj.viz_ai_ch),'Visible','on')
            set(obj.ai_ch_lines(~obj.viz_ai_ch),'Visible','off')
            obj.cleanupFigure            
        end
        
        function savemap(obj,varargin)
            map.target = obj.target;
            map.trial_index = obj.trial_index;
            map.trialnumber = obj.trialnumber;
            map.protocol_hashes = obj.protocol_hashes;
            map.statecount = obj.statecount;
            map.probebins = obj.probebins;
            map.probehist = obj.probehist;
            map.last_seen_samp = obj.last_seen_samp;
            map.extracted = obj.extracted;
            
            save(regexprep(obj.filename,'.bin','_map.mat'),'-struct','map');
            fprintf('Saving map of trial times:\n\t%d targets\n\t%d trials\n\t%d different protocol hashes: ',...
                size(map.target,1),...
                length(map.trialnumber),...
                length(unique(map.protocol_hashes)));
            hshs = unique(map.protocol_hashes);
            if ~isempty(hshs)
                str = '{';
                for h = 1:length(hshs)
                    str = [str,sprintf('%.1f,',hshs(h))];
                end
                fprintf('%s}\n',str(1:end-1));
            else
                fprintf('\n')
            end
            fprintf('Trials extracted?: %i\n',obj.extracted);

        end
        
    end
    
    methods (Access = protected)
                
        function cleanupFigure(obj)
            if isempty(obj.cookie)
                error('What is going on?')
            end
            obj.ffwposax.XLim = [min(obj.pos_line.XData) max(obj.pos_line.XData)];
            posmin = min(obj.pos_line.YData);
            posmax = max(obj.pos_line.YData);
            obj.improvePosLims(posmin, posmax);
            obj.ffwposax.YLim = obj.posylims_;
            
            obj.ffwrefax.XLim = [obj.cookietime(1) obj.cookietime(end)];            
            obj.ffwaiax.XLim = [obj.cookietime(1) obj.cookietime(end)];            
            obj.ffwdiax.XLim = [obj.cookietime(1) obj.cookietime(end)];

            vlin = findobj(obj.ai_ch_lines,'Tag','voltage_1');
            vmin = min(vlin.YData);
            vmax = max(vlin.YData);
            obj.improveVoltageLims(vmin,vmax);
            obj.ffwaiax.YLim = obj.voltageylims_;

            set(obj.ai_ch_lines(obj.viz_ai_ch),'Visible','on');
            set(obj.ai_ch_lines(~obj.viz_ai_ch),'Visible','off');
            set(obj.di_ch_lines(obj.viz_di_ch),'Visible','on');
            set(obj.di_ch_lines(~obj.viz_di_ch),'Visible','off');
            
            obj.addTargetLines;
            obj.gotoedit.String = num2str(obj.currentTime);
            obj.sizeedit.String = num2str(obj.cookiesize);
            
            idx = find(obj.trial_index>=obj.samp0,1,'first');
            if isempty(idx) && ~isempty(obj.trial_index)
                [~,idx] = max(obj.trial_index);
            end
            obj.trialedit.String = num2str(obj.trialnumber(idx));
            obj.refchedit.String = num2str(obj.protocol_hashes(idx));
    
            if obj.extracted
                obj.quickShow.Visible = obj.extracted;
                obj.quickShow.Enable = 'on';
            end

        end
        
        function improvePosLims(obj, mn, mx)
            if ~isempty(mn)
                mx = max([mx mn+1]); % incase they are equal
                if isempty(obj.posylims)
                    obj.posylims  = [mn mx];
                end
                
                if isempty(obj.target)
                    obj.posylims = [...
                        min([obj.posylims(1), mn]), ...
                        max([obj.posylims(2), mx])];
                else
                    % not really any point looking at all targets. Just
                    % resize for the closest couple
                    [~,cls] = min(abs(obj.target(1,:)-obj.samp0));
                    clsfew = cls+(-2:2);
                    clsfew = clsfew(clsfew<=size(obj.target,2)&clsfew>0);
                    obj.posylims = [...
                        min([obj.posylims(1), mn, min(obj.target(2,clsfew))]), ...
                        max([obj.posylims(2), mx, max(obj.target(2,clsfew)+ min(obj.target(3,clsfew)))])];
                end
                % just expand them a bit, to make sure you can see all of
                % the lines
                obj.posylims_ = obj.posylims - 0.1*diff(obj.posylims) + [0 1] * 0.2 * diff(obj.posylims);
            end
        end

        function improveVoltageLims(obj, mn, mx)
            if ~isempty(mn)
                mx = max([mx mn+1]); % incase they are equal
                if isempty(obj.voltageylims)
                    obj.voltageylims  = [mn mx];
                end
                
                obj.voltageylims = [...
                    min([obj.voltageylims(1), mn]), ...
                    max([obj.voltageylims(2), mx])];
                % just expand them a bit, to make sure you can see all of
                % the lines
                obj.voltageylims_ = obj.voltageylims - 0.1*diff(obj.voltageylims) + [0 1] * 0.2 * diff(obj.voltageylims);
            end
        end
        
        function addTargetLines(obj)
            if isempty(obj.target)
                return
            end
            tclr = [.6 .6 1];
            delT = find(obj.target(1,:) > obj.samp0 &  obj.target(1,:) < obj.samp1);
            prevDelT = find(obj.target(1,:) < obj.samp0,1,'last');
            if ~isempty(delT) && delT(1)>1
                delT = [delT(1)-1, delT];
                trgt = obj.target(:,delT);
                delT = 1:size(trgt,2);
            elseif ~isempty(delT) && delT(1)==1
                trgt = [[1;0;10] obj.target(:,delT)];
                delT = [1, 2];
            end
            
            delete(findobj(obj.ffwposax,'Tag','target'));
            if isempty(delT)
                % no target here, don't change the target lines
                if ~isempty(prevDelT)
                    patch('XData',[obj.samp0 obj.samp1 obj.samp1 obj.samp0]/obj.samprate, ...
                        'YData',obj.target(2,prevDelT(1))*[1 1 1 1] + obj.target(3,prevDelT(1))*[0 0 1 1],...
                        'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'parent',obj.ffwposax,'Tag','target')
                end
            else
                % go through the target changes and plot the targets                
                patch('XData',[obj.samp0 trgt(1,delT(2)) trgt(1,delT(2)) obj.samp0]/obj.samprate, ...
                    'YData',trgt(2,delT(1))*[1 1 1 1] + trgt(3,delT(1))*[0 0 1 1],...
                    'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'parent',obj.ffwposax,'Tag','target')

                for tidx = 2:length(delT)-1
                    patch('XData',[trgt(1,delT(tidx)) trgt(1,delT(tidx+1)) trgt(1,delT(tidx+1)) trgt(1,delT(tidx))]/obj.samprate, ...
                        'YData',trgt(2,delT(tidx))*[1 1 1 1] + trgt(3,delT(tidx))*[0 0 1 1],...
                        'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'parent',obj.ffwposax,'Tag','target')
                end
                tidx = length(delT);
                patch('XData',[trgt(1,delT(tidx)) obj.samp1 obj.samp1 trgt(1,delT(tidx))]/obj.samprate, ...
                    'YData',trgt(2,delT(tidx))*[1 1 1 1] + trgt(3,delT(tidx))*[0 0 1 1],...
                    'FaceColor',[.8 .8 .8],'EdgeColor',[.8 .8 .8],'parent',obj.ffwposax,'Tag','target')
            end
            obj.ffwposax.Children = flipud(obj.ffwposax.Children);
        end
        
        function replaceCookieLines(obj)
            delete(findobj(obj.ffwposax,'type','line'));
            delete(findobj(obj.ffwrefax,'type','line'));
            delete(findobj(obj.ffwaiax,'type','line'));
            
            obj.ffwrefax.NextPlot = 'add';
            obj.ffwposax.NextPlot = 'add';
            obj.ffwaiax.NextPlot = 'add';
            
            aichans = obj.ai_channels;
            obj.ai_ch_lines = gobjects(size(obj.ai_channels));
            while ~isempty(aichans)
                aichan = aichans{end};
                try aichans = aichans(1:end-1);
                catch e
                    aichans = {};
                end
                if strcmp(aichan,'probe_position')
                    obj.pos_line = plot(obj.ffwposax,obj.cookietime, obj.cookie(strcmp(obj.channels,aichan),:));
                    obj.pos_line.Color = obj.cm.probe_position;
                    obj.pos_line.Tag = 'probe_position';
                    obj.pos_line.DisplayName = 'probe_position';
                elseif strcmp(aichan,'refchan')
                    obj.ref_line = plot(obj.ffwrefax,obj.cookietime, obj.cookie(strcmp(obj.channels,aichan),:));
                    obj.ref_line.Color = obj.cm.refchan;
                    obj.ref_line.Tag = 'refchan';
                    obj.ref_line.DisplayName = 'refchan';
                elseif strcmp(aichan,'sgsmonitor')
                    obj.sgs_line = plot(obj.ffwrefax,obj.cookietime, obj.cookie(strcmp(obj.channels,aichan),:));
                    obj.sgs_line.Color = obj.cm.sgsmonitor;
                    obj.sgs_line.Tag = 'sgsmonitor';
                    obj.sgs_line.DisplayName = 'sgsmonitor';
                else % if obj.viz_ai_ch(ch)
                    ch = find(strcmp(obj.ai_channels,aichan));
                    obj.ai_ch_lines(ch) = plot(obj.ffwaiax,obj.cookietime, obj.cookie(strcmp(obj.channels,obj.ai_channels{ch}),:));
                    obj.ai_ch_lines(ch).Tag = aichan;
                    obj.ai_ch_lines(ch).DisplayName = aichan;
                    if any(strcmp(fieldnames(obj.cm),aichan))
                        obj.ai_ch_lines(ch).Color = obj.cm.(aichan);
                    end
                end
            end
            
            selectaich = true(size(obj.ai_ch_lines));
            for ac = 1:length(obj.ai_ch_lines)
                if isa(obj.ai_ch_lines(ac),'matlab.graphics.GraphicsPlaceholder')
                    selectaich(ac) = false;
                end
            end
            obj.ai_ch_lines = obj.ai_ch_lines(selectaich);
            obj.viz_ai_ch = obj.viz_ai_ch(selectaich);

            delete(findobj(obj.ffwdiax,'type','line'));
            obj.ffwdiax.NextPlot = 'add';
            obj.di_ch_lines = gobjects(size(obj.di_channels));
            for ch = 1:length(obj.di_channels)
                obj.di_ch_lines(ch) = plot(obj.ffwdiax,obj.cookietime, obj.cookie(strcmp(obj.channels,obj.di_channels{ch}),:));
                obj.di_ch_lines(ch).Tag = obj.di_channels{ch};
                obj.di_ch_lines(ch).DisplayName = obj.di_channels{ch};
                if any(strcmp(fieldnames(obj.cm),obj.di_channels{ch}))
                    obj.di_ch_lines(ch).Color = obj.cm.(obj.di_channels{ch});
                end
            end
        end

        
        function  next = filterProbePosition(obj,next)
            % first eliminate the transients
            pp = next(strcmp(obj.channels,'probe_position'),:);
            
            dpp = diff(pp);            
            dpp = find(dpp);
            
            if any(dpp)
                dsamp = 10; % generally enough to reach steady state
                dpp = bsxfun(@plus, (1:dsamp)', dpp);
                dpp = dpp(:);
                dpp = dpp(dpp<length(pp)-dsamp);
                next(strcmp(obj.channels,'probe_position'),dpp) = pp(dpp+dsamp);
            end
            
            % Estimate the number if samples per frame.
            pp = next(strcmp(obj.channels,'probe_position'),:);
            dpp = diff(pp);
            obj.probe_comb = find([1,0,diff(dpp)>0]);
            
            obj.approx_framerate = quantile(diff(obj.probe_comb),.5);
        end
           
        function next = detectTargetChanges(obj,next)
            % first check if the target changed on the last cookie
            pp = next(strcmp(obj.channels,'probe_position'),:);
            dpp = diff(pp);
            % target changes when the probe jumps from one side to other
            targetchanges = ~isempty(find(dpp<obj.gains(strcmp(obj.ai_channels,'probe_position')) * 4096 * -.9,1));            
            obj.probe_comb = find([1,0,diff(dpp)>0]);
            
            obj.approx_framerate = quantile(diff(obj.probe_comb),.5);

            if ~isempty(obj.edgetarget)
                
                [~,bidx] = min((pp(1:800)-1.2497).^2);
                bottom = pp(bidx);
                ei = find(pp(1:1000)==bottom,1,'last');
                target_vals = unique(pp(1:ei-1));
                keep = false(size(target_vals));
                for idx = 1:length(target_vals)
                    keep(idx) = (sum(pp(1:ei-1)==target_vals(idx)) > 4);
                end
                target_vals = target_vals(keep & target_vals>bottom);
                switch obj.edgetarget.case
                    case 0
                        % which is which?
                        if length(target_vals)~=2
                            error('Handle this case')
                        end
                        idx1 = find(pp(1:ei-1)==target_vals(1),1,'first');
                        idx2 = find(pp(1:ei-1)==target_vals(2),1,'first');
                        target_vals = round(target_vals);
                        if idx1<idx2
                            x = target_vals(1);
                            w = target_vals(2);
                        elseif idx1>idx2
                            x = target_vals(2);
                            w = target_vals(1);
                        else
                            error('Handle this case')
                        end
                        
                    case 1
                        % Already know what x is
                        target_vals = round(target_vals);
                        x = obj.edgetarget.x;
                        w = target_vals(target_vals~=x);
                    case 2
                        x = obj.edgetarget.x;
                        w = obj.edgetarget.w;
                end
                
                if isempty(obj.target)
                    obj.target = ...
                        [obj.samp0+ei;
                        x;
                        w];
                else
                    obj.target = cat(2,obj.target,...
                        [obj.samp0+ei;
                        x;
                        w]);
                end
                next(strcmp(obj.ai_channels,'probe_position'),1:ei) = obj.edgetarget.lastpos;
                obj.edgetarget = [];
            end
            
            if targetchanges
                % then see if the target changed
                pp = next(strcmp(obj.channels,'probe_position'),:);
                dpp = diff(pp);
                del_target = find(dpp<obj.gains(strcmp(obj.ai_channels,'probe_position')) * 4096 * -.9);
                for didx = 1:length(del_target)
                    di = del_target(didx);
                    
                    % go find last stable value
                    fi = find(pp(1:di)~=pp(di),1,'last') - 5;
                    lastpos = pp(fi);
                    
                    
                    % bottom should be as close to 1.2497 as possible
                    try [~,bidx] = min((pp(di:di+1000)-1.2497).^2);
                    catch e
                        % the target is occuring at the edge,
                        % could be missing the width,
                        % could be missing x
                        % could be missing the bottom
                        [~,bidx] = min((pp(di:end)-1.2497).^2);
                        bottom = pp(di+bidx);
                        
                        target_vals = unique(pp(di+1:end));
                        keep = false(size(target_vals));
                        for idx = 1:length(target_vals)
                            keep(idx) = (sum(pp(di+1:end)==target_vals(idx)) > 2);
                        end
                        target_vals = target_vals(keep & target_vals>bottom);
                        next(strcmp(obj.ai_channels,'probe_position'),fi:end) = lastpos;
                        
                        if obj.last_seen_samp <= obj.samp1
                            switch length(target_vals)
                                case 0
                                    % only the bottom
                                    obj.edgetarget.case = 0;
                                    obj.edgetarget.x = [];
                                    obj.edgetarget.w = [];
                                    obj.edgetarget.lastpos = lastpos;
                                case 1
                                    % x value is there
                                    obj.edgetarget.case = 1;
                                    obj.edgetarget.x = round(target_vals(1));
                                    obj.edgetarget.w = [];
                                    obj.edgetarget.lastpos = lastpos;
                                case 2 % w value is there
                                    % x value is there
                                    obj.edgetarget.case = 1;
                                    % which is which?
                                    idx1 = find(pp(di+1:ei-1)==target_vals(1),1,'first');
                                    idx2 = find(pp(di+1:ei-1)==target_vals(2),1,'first');
                                    target_vals = round(target_vals);
                                    if idx1<idx2
                                        x = target_vals(1);
                                        w = target_vals(2);
                                    elseif idx1>idx2
                                        x = target_vals(2);
                                        w = target_vals(1);
                                    else
                                        error('Handle this case')
                                    end
                                    
                                    obj.edgetarget.x = x;
                                    obj.edgetarget.w = w;
                                    obj.edgetarget.lastpos = lastpos;
                            end
                        end
                        
                        % then need something to get the target on the next
                        % cookie
                        continue % could be break, since this should be the end
                    end
                    bottom = pp(di+bidx);
                    % bottom = pp(di+1);
                    ei = find(pp(di:di+1000)==bottom,1,'last')+di;
                    next(strcmp(obj.ai_channels,'probe_position'),fi:ei) = lastpos;
                    
                    if obj.last_seen_samp <= obj.samp1
                        
                        target_vals = unique(pp(di+1:ei-1));
                        keep = false(size(target_vals));
                        for idx = 1:length(target_vals)
                            keep(idx) = (sum(pp(di+1:ei-1)==target_vals(idx)) > 4);
                        end
                        target_vals = target_vals(keep & target_vals>bottom);
                        
                        if length(target_vals)~=2
                            % might be the same values
                            if length(target_vals)==1
                                idx = find(pp(di+1:ei-1)==target_vals(1));
                                if any(diff(idx) > 20)
                                    x = round(target_vals);
                                    w = x;
                                end
                            else
                                error('Handle this case')
                            end
                        else
                            % which is which?
                            idx1 = find(pp(di+1:ei-1)==target_vals(1),1,'first');
                            idx2 = find(pp(di+1:ei-1)==target_vals(2),1,'first');
                            target_vals = round(target_vals);
                            if idx1<idx2
                                x = target_vals(1);
                                w = target_vals(2);
                            elseif idx1>idx2
                                x = target_vals(2);
                                w = target_vals(1);
                            else
                                error('Handle this case')
                            end
                        end
                        if isempty(obj.target)
                            obj.target = ...
                                [obj.samp0+ei;
                                x;
                                w];
                        else
                            
                            try obj.target = cat(2,obj.target,...
                                [obj.samp0+ei;
                                x;
                                w]);
                            catch e
                                e.rethrow
                            end
                        end
                    end
                end
            end
        end
        
        function  next = filterStimhashval(obj,next)
            % Where are the trials?
            % stimulus hash values must be >.5V, so look for 1 volt changes.
            % But the change could come between samples, so first filter
            % the changes to get full steps.
            rfch = next(strcmp(obj.channels,'refchan'),:);
            rfch = round(rfch*10)/10; % round off, get rid of noise
            
            % differentiate, filter and smooth. Have to account for a
            % fraction of the full step.
            del = [0 diff(rfch)];
            del(2:end) = del(2:end)+del(1:end-1);
            idxs = find(del>1);
            if ~isempty(idxs)
                idxs = idxs([true diff(idxs)>1]);
            end
            % just see if refchan val increased at any point before the
            % trial started
            idxidx = rfch(idxs-1) > 0;
            idxs(idxidx) = idxs(idxidx)-1;
            
            % Just make sure the value didn't change at the cookie
            if ~isempty(obj.lastrefchanval) && obj.lastrefchanval == 0 && rfch(1)>0
                idxs = [0 idxs];
            end
            
            obj.cookie_trial_index = idxs;
            cookie_trialnumbers = idxs;
            cookie_hashes = idxs;
            
            if ~isempty(obj.cookie_trial_index)
                trnumsamps = 25+10*(0:8);
                % Check if this occurs at the end of the cookie
                if obj.cookie_trial_index(end)+trnumsamps(end)>length(rfch)
                    error('The trial number signal in the refchannel is right at the end of the cookie')
                end
                for tidx = 1:length(obj.cookie_trial_index)
                    tridx = obj.cookie_trial_index(tidx);
                    digits = rfch(tridx+trnumsamps)-rfch(tridx+10);
                    digits = round(digits*10);
                    digits = digits(1:find(digits==-1,1,'last'));
                    digits = digits(digits>=0);
                    cookie_trialnumbers(tidx) = sum(10.^(0:length(digits)-1).*digits);
                    cookie_hashes(tidx) = rfch(tridx+10);
                    % rfch(tridx+10:tridx+trnumsamps(end)) = cookie_hashes(tidx);
                end
                
                % next(strcmp(obj.channels,'refchan'),:) = rfch;
                obj.lastrefchanval = rfch(end);
                obj.trial_index = [obj.trial_index, obj.samp0+idxs];
                obj.protocol_hashes = [obj.protocol_hashes, cookie_hashes];
                obj.trialnumber = [obj.trialnumber, cookie_trialnumbers];
            end
        end
        
        function updateoverview(obj,next)
            % don't run this if the histogram pointer is already ahead
            if obj.last_seen_samp > obj.samp1
                return
            end
            targets = [];
            
            % Find the targets up to the end of the cookie.
            % Cannot do this when backing up yet
            if ~isempty(obj.target)
                targets = obj.target(1,(obj.target(1,:)>obj.samp1));
            end
            if ~isempty(targets)
                targets = targets-obj.samp1;
                
                ardon = next(strcmp(obj.channels,'arduino_output'),:);
                % These targets are past samp1, i.e. in the current cookie
                % first go to the next target
                trgt1 = targets(1);
                on = sum(ardon(1:trgt1));
                obj.statecount(:,end) = obj.statecount(:,end) + [
                    on;
                    trgt1-on];
                for tidx = 2:length(targets)
                    trgt2 = targets(tidx);
                    on = sum(ardon(trgt1+1:trgt2));
                    obj.statecount = cat(2,obj.statecount,...
                        [on
                        (trgt2-trgt1)-on]);
                    trgt1 = trgt2;
                end
                on = sum(ardon(trgt1+1:length(ardon)));
                obj.statecount = cat(2,obj.statecount,...
                    [on
                    (length(ardon)-trgt1)-on]);
                
                % Now bin the probe positions
                pp = next(strcmp(obj.channels,'probe_position'),:);
                trgt1 = targets(1);
                pp_target = pp(1:trgt1);
                n_target = round(histcounts(pp_target,obj.probebins)/obj.approx_framerate);
                obj.probehist(:,end) = obj.probehist(:,end) + n_target(:);
                
                for tidx = 2:length(targets)
                    trgt2 = targets(tidx);
                    pp_target = pp(trgt1+1:trgt2);
                    n_target = round(histcounts(pp_target,obj.probebins)/obj.approx_framerate);
                    obj.probehist = cat(2,obj.probehist,n_target(:));
                    trgt1 = trgt2;
                end
                pp_target = pp(trgt1+1:length(pp));
                n_target = round(histcounts(pp_target,obj.probebins)/obj.approx_framerate);
                obj.probehist = cat(2,obj.probehist,n_target(:));
            elseif ~isempty(obj.target)
                % This is key, if the target doesn't change, the stats
                % still need to be added
                
                ardon = next(strcmp(obj.channels,'arduino_output'),:);
                on = sum(ardon);
                obj.statecount(:,end) = obj.statecount(:,end) + [
                    on;
                    length(ardon)-on];
                
                pp = next(strcmp(obj.channels,'probe_position'),:);
                n_target = round(histcounts(pp,obj.probebins)/obj.approx_framerate);
                obj.probehist(:,end) = obj.probehist(:,end) + n_target(:);
            else
                % Haven't encountered a target yet
            end
            obj.last_seen_samp = obj.samp1;
        end

        function next = customFilters(obj,next)
            % If certain cells need to be adjusted, like if the wrong mode is used
            
            if contains(obj.filename,'210319_F2_C1')
                % the amp was in voltage clamp for this cell, so membrane
                % voltage was saved as current and scaled by 10X
                current = next(strcmp(obj.channels,'current_1'),:);
                voltage = next(strcmp(obj.channels,'voltage_1'),:);
                next(strcmp(obj.channels,'voltage_1'),:) = current/10;
                next(strcmp(obj.channels,'current_1'),:) = voltage;
            end                
        end
        
        function smp = ptr2smp(obj,ptr)
            smp = (ptr - obj.datastart)/obj.delptr_persamp_A;
        end

        function smp = dptr2smp(obj,ptr)
            smp = (ptr - obj.di_start)/obj.delptr_persamp_D;
        end
        
        function ptr = smp2ptr(obj,smp)
            ptr = smp*obj.delptr_persamp_A+obj.datastart;
        end
        
        function [ptr,extra] = smp2dptr(obj,smp)
            bits = smp*length(obj.di_channels);
            bytes = floor(bits/8);
            extra = rem(bits,8);
            ptr = bytes+obj.di_start;
        end

        function next = readnext(obj,nextreads)
            ptr0 = ftell(obj.afid);
            obj.samp0 = obj.ptr2smp(ptr0);
            next = fread(obj.afid,[length(obj.ai_channels),nextreads],'int16=>double');
            obj.pointer = ftell(obj.afid);
            obj.samp1 = obj.ptr2smp(obj.pointer);

            if isempty(next)
                % Reached the end of the file
                fprintf('Reached the end of the file\n')
                if obj.pointer ~= obj.filesize
                    error('Filesize and pointer are not in alignment')
                end
                return
            end
            next = bsxfun(@times, obj.gains, next);
            
            nextd = fread(obj.dfid,[length(obj.di_channels),nextreads],'ubit1=>double');
            obj.di_pointer = ftell(obj.dfid);
            if size(next,2)==size(nextd,2)
                next = cat(1,next, nextd);
            else
                error('Deal with this')
            end
        end

        function readHeader(obj,varargin)
            if ~isempty(obj.afid)
                frewind(obj.afid);
            elseif nargin > 1
                obj.afid = fopen(varargin{1},'r');
                if obj.afid<=0
                    error('No filename to open, possibly in wrong folder?')
                end
            else
                error('No filename to open')
            end
            
            % Read the filename
            bra = fread(obj.afid,1,'char');
            while bra~='<'
                bra = fread(obj.afid,1,'char');
            end
            ket = fread(obj.afid,1,'char');
            fn = '';
            while ket~= '>'
                fn = [fn,ket];
                ket = fread(obj.afid,1,'char');
            end
            obj.filename = char(fn);
            [obj.D,obj.name] = fileparts(obj.filename);
            if nargin > 1 && ~strcmp(varargin{1},obj.name)
                obj.name = varargin{1};
                obj.filename = fullfile(obj.D,obj.name);
            end
            bra = ket;
            
            % Read the protocol and samprate
            while bra~='<'
                bra = fread(obj.afid,1,'char');
            end
            protocolsamprate = '';
            ket = fread(obj.afid,1,'char');
            while ket~= '>'
                protocolsamprate = [protocolsamprate,ket];
                ket = fread(obj.afid,1,'char');
            end
            protocolsamprate = char(protocolsamprate);
            protocolsamprate = split(protocolsamprate);
            obj.protocol = protocolsamprate{2};
            obj.samprate = str2double(protocolsamprate{4});
            
            bra = ket;
            
            % Read column names
            while bra~='<'
                bra = fread(obj.afid,1,'char');
            end
            columnnames = '';
            ket = fread(obj.afid,1,'char');
            while ket~= '>'
                columnnames = [columnnames,ket];
                ket = fread(obj.afid,1,'char');
            end
            columnnames = char(columnnames);
            obj.ai_channels = split(columnnames);
            
            bra = ket;
            
            % Read gains
            while bra~='<'
                bra = fread(obj.afid,1,'char');
            end
            gain = zeros(size(obj.ai_channels));
            for idx = 1:length(gain)
                gain(idx) = fread(obj.afid,1,'double');
            end
            obj.gains = gain;
            
            % should have made it to the end
            ket = fread(obj.afid,1,'char');
            if ket~='>'
                error('corrupted file format: what do I do?')
            end
            
            obj.datastart = ftell(obj.afid);
            obj.pointer = obj.datastart;
            obj.entrybytes = 2;
            next = fread(obj.afid,[length(obj.ai_channels),1],'int16=>double');
            obj.delptr_persamp_A = ftell(obj.afid)-obj.datastart;
            fseek(obj.afid,obj.datastart,-1);
        end
        
        function readDHeader(obj,varargin)
            if ~isempty(obj.dfid)
                frewind(obj.dfid);
            else
                obj.dfid = fopen(regexprep(obj.filename,'_A.bin','_D.bin'),'r');
            end
            
            % Read the filename
            bra = fread(obj.dfid,1,'char');
            while bra~='<'
                bra = fread(obj.dfid,1,'char');
            end
            ket = fread(obj.dfid,1,'char');
            fn = '';
            while ket~= '>'
                fn = [fn,ket];
                ket = fread(obj.dfid,1,'char');
            end
            bra = ket;
            
            % Read the protocol and samprate
            while bra~='<'
                bra = fread(obj.dfid,1,'char');
            end
            protocolsamprate = '';
            ket = fread(obj.dfid,1,'char');
            while ket~= '>'
                protocolsamprate = [protocolsamprate,ket];
                ket = fread(obj.dfid,1,'char');
            end
            bra = ket;
            
            % Read column names
            while bra~='<'
                bra = fread(obj.dfid,1,'char');
            end
            ket = fread(obj.dfid,1,'char');
            columnnames = '';
            while ket~= '>'
                columnnames = [columnnames,ket];
                ket = fread(obj.dfid,1,'char');
            end
            columnnames = char(columnnames);
            obj.di_channels = split(columnnames);
            
            bra = ket;
            
            % No gains
            
            % should have made it to the end
            if ket~='>'
                error('corrupted file format: what do I do?')
            end
            
            obj.di_start = ftell(obj.dfid);
            obj.di_pointer = obj.di_start;
            next = fread(obj.dfid,[length(obj.di_channels),1],'ubit1=>double');
            obj.delptr_persamp_D = ftell(obj.dfid)-obj.di_start;
            fseek(obj.dfid,obj.di_start,-1);
        end
        
        function loadmap(obj,filename)
            fprintf('Loading map to continuous file\n');
            map = load(regexprep(filename,'.bin','_map.mat'));

            obj.target = map.target;
            obj.trial_index = map.trial_index;
            obj.trialnumber = map.trialnumber;
            obj.protocol_hashes = map.protocol_hashes;
            obj.statecount = map.statecount;
            obj.probebins = map.probebins;
            obj.probehist = map.probehist;
            obj.last_seen_samp = map.last_seen_samp;
            obj.extracted = map.extracted;
            if obj.extracted
                fprintf('Trials extracted: Yes\n');
            else
                fprintf('Trials extracted: No\n');
            end
        end
        
        function setclrmap(obj)
            obj.cm.voltage_1 = [0.4940 0.1840 0.5560];
            obj.cm.probe_position = [0 0.4470 0.7410];
            obj.cm.sgsmonitor = [0 0 0.7410];
            obj.cm.arduino_output = [1 0 0];
            obj.cm.refchan = [0.8500 0.3250 0.0980];
        end
    end
end


        %         function decimateCookie(obj)
        %             % plot the cookie
        %
        %             fig = figure;
        %             fig.Position = [28 380 1873 600];
        %             pax = subplot(2,1,2,'parent',fig);
        %             lax = subplot(2,1,1,'parent',fig);
        %
        %             pax.Units = 'normalized';
        %             pax.Position = [.05 .1 .9 .55];
        %             pax.NextPlot = 'add';
        %
        %             lax.Units = 'normalized';
        %             lax.Position = [.05 .75 .9 .2];
        %             lax.NextPlot = 'add';
        %             linkaxes([pax,lax],'x')
        %
        %             pp = obj.cookie(strcmp(obj.channels,'probe_position'),:);
        %             dpp = [1,find(diff(pp)),length(pp)];
        %             pl = plot(pax,obj.cookietime(dpp),pp(dpp));
        %             pl.Tag = 'probe_position';
        %
        %             led = obj.cookie(strcmp(obj.channels,'arduino_output'),:);
        %             dled = find(diff(led));
        %             dled = [dled-1;dled;dled+1];
        %             dled = dled(:);
        %             dled = [1,dled',length(led)];
        %             pl = plot(lax,obj.cookietime(dled),led(dled));
        %
        %             pax.XLim = [obj.cookietime(1) obj.cookietime(end)];
        %
        %             if isempty(obj.target)
        %                 return
        %             end
        %             tclr = [.6 .6 1];
        %             delT = find(obj.target(1,:) > obj.samp0 &  obj.target(1,:) < obj.samp1);
        %             prevDelT = find(obj.target(1,:) < obj.samp0,1,'last');
        %             if ~isempty(delT) && delT(1)>1
        %                 delT = [delT(1)-1, delT];
        %             end
        %             if isempty(delT)
        %                 % no target here, don't change the target lines
        %                 plot(pax,[obj.samp0 obj.samp1]/obj.samprate,obj.target(2,prevDelT(1))*[1 1],'color',tclr);
        %                 plot(pax,[obj.samp0 obj.samp1]/obj.samprate,(obj.target(2,prevDelT(1))+obj.target(3,prevDelT(1)))*[1 1],'color',tclr);
        %             else
        %                 % go through the target changes and plot the targets
        %                 plot(pax,[obj.samp0 obj.target(1,delT(1))]/obj.samprate,[nan nan],'color',tclr);
        %                 plot(pax,[obj.samp0 obj.target(1,delT(1))]/obj.samprate,[nan nan],'color',tclr);
        %
        %                 for tidx = 1:length(delT)-1
        %                     plot(pax,[obj.target(1,delT(tidx)) obj.target(1,delT(tidx+1))]/obj.samprate,obj.target(2,delT(tidx))*[1 1],'color',tclr);
        %                     plot(pax,[obj.target(1,delT(tidx)) obj.target(1,delT(tidx+1))]/obj.samprate,obj.target(2,delT(tidx))+obj.target(3,delT(tidx))*[1 1],'color',tclr);
        %                 end
        %
        %                 tidx = length(delT);
        %                 plot(pax,[obj.target(1,delT(tidx)) obj.samp1]/obj.samprate,obj.target(2,delT(tidx))*[1 1],'color',tclr);
        %                 plot(pax,[obj.target(1,delT(tidx)) obj.samp1]/obj.samprate,(obj.target(2,delT(tidx))+obj.target(3,delT(tidx)))*[1 1],'color',tclr);
        %             end
        %         end
        
        % function overview(obj)
        %     trgclr = [0 0 .8];
        %     if isempty(obj.ovfig) || ~ishghandle(obj.ovfig)
        %         obj.ovfig = figure;
        %         obj.ovfig.Position = [471 136 915 355];
        %         obj.ovax = subplot(2,1,1,'parent',obj.ovfig);
        %         obj.ovcntax = subplot(2,1,2,'parent',obj.ovfig);
        %
        %         obj.ovax.Units = 'normalized';
        %         obj.ovax.Position = [.06 .52 .9 .438];
        %         obj.ovax.NextPlot = 'add';
        %         obj.ovax.XAxisLocation = 'top';
        %
        %         obj.ovcntax.Units = 'normalized';
        %         obj.ovcntax.Position = [.06 .1 .9 .38];
        %         obj.ovcntax.NextPlot = 'add';
        %
        %     else
        %         cla(obj.ovax)
        %     end
        %     for tidx = 1:size(obj.target,2)-1
        %         plot(obj.ovax,...
        %             [obj.target(1,tidx) obj.target(1,tidx+1)]/obj.samprate,...
        %             obj.target(2,tidx)*[1 1],'color',trgclr)
        %         plot(obj.ovax,...
        %             [obj.target(1,tidx) obj.target(1,tidx+1)]/obj.samprate,...
        %             (obj.target(2,tidx)+obj.target(3,tidx))*[1 1],'color',trgclr);
        %
        %     end
        %     tidx = tidx+1;
        %     plot(obj.ovax,...
        %         [obj.target(1,tidx) obj.samp1]/obj.samprate,...
        %         obj.target(2,tidx)*[1 1],'color',trgclr)
        %     plot(obj.ovax,...
        %         [obj.target(1,tidx) obj.samp1]/obj.samprate,...
        %         (obj.target(2,tidx)+obj.target(3,tidx))*[1 1],'color',trgclr);
        %
        %     obj.ovax.YLim = [200 1100]; %obj.ylims_
        %     obj.ovax.XLim = [0 obj.samp1/obj.samprate];
        %
        %     x = obj.target(1,:);
        %     x = [0 x obj.samp1];
        %     y = obj.statecount;
        %     y_total = y(1,:)+y(2,:);
        %     y_ratio = y(1,:)./y_total;
        %     pi = (y(1,:)-y(2,:))./y_total;
        %     % l = [diff(x)>20000,true];
        %     %             x = x(l);
        %     %             y = y(l);
        %     x_center = x(1:end-1)+diff(x)/2;
        %     x_center = x_center/obj.samprate;
        %     x = x/obj.samprate;
        %     % svl = mean(1./diff(x));
        %     short_x = diff(x)<40;
        %
        %     plot(obj.ovcntax,[x(1) x(end)],[0 0],'color',[.8 .8 .8])
        %
        %     % plot all points
        %     plot(obj.ovcntax, x_center(~short_x), y_ratio(~short_x),'color',[.8,0 0], 'linestyle', '--', 'Marker','.','Markersize',10);
        %     % plot(obj.ovcntax, x_center(~short_x), pi(~short_x),'color',[.8,0 0], 'linestyle', '--', 'Marker','.','Markersize',10);
        %
        %     % plot insignificant ones in pink
        %     plot(obj.ovcntax, x_center(short_x), y_ratio(short_x),'color',[1,.8 .8], 'linestyle', 'none', 'Marker','.','Markersize',10);
        %     % plot(obj.ovcntax, x_center(short_x), pi(short_x),'color',[1,.8 .8], 'linestyle', 'none', 'Marker','.','Markersize',10);
        %
        %     obj.ovcntax.YLim = [-.05 1.05];
        %     % obj.ovcntax.YLim = [-1.05 1.05];
        %     obj.ovcntax.XLim = [0 obj.samp1/obj.samprate];
        %
        %     obj.ovax.NextPlot = 'replace';
        %     obj.ovcntax.NextPlot = 'replace';
        %
        % end
