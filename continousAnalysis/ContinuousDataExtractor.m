%% Reading a continuous file, 5000 entries at a time
classdef ContinuousDataExtractor < handle
    
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
        ylims
        
        statecount
        probebins
        probehist
        approx_framerate
    end
    
    properties (Hidden, SetAccess = protected)
        cookiesamps
        delptr_persamp_A
        delptr_persamp_D
        
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
        ylims_
        
        probe_comb
        probehist_smp
        
        
        edgetarget
    end
    
    methods
        function obj = ContinuousDataExtractor(filename,varargin)
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
            obj.probehist_smp = 0;
            
            obj.ffwRead(40);
        end
        
        function ffwRead(obj,varargin)
            if nargin > 1
                obj.cookiesize = varargin{1};
            end
            while obj.readCookie
                fprintf('Current time: %g s, %g trials\n',obj.samp1/obj.samprate,length(obj.trial_index));
            end
        end
        
        function extractProtocolFiles(obj,trial)
            if isempty(obj.target)
                obj.target = [1
                                0
                                0];
            end
            
            [prtcl,~,~,~,~,rawdir,trialStem] = extractRawIdentifiers(trial.name);
            stimhashval = trial.params.stimhashval;
            prtcl_index = find(obj.protocol_hashes==stimhashval);
            tr_index = obj.trial_index(prtcl_index);
            trnums = obj.trialnumber(prtcl_index);
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
            if length(prtcl_index) > length(prtclfiles)
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
            
            f = figure;
            ax1 = subplot(3,1,1,'parent',f);
            ax2 = subplot(3,1,2,'parent',f);
            ax3 = subplot(3,1,3,'parent',f);
            
            for i = 1:length(tr_index)
                n1 = tr_index(i);
                try trial = load(fullfile(rawdir,sprintf(trialStem,trnums(i))));
                catch e    
                    if contains(e.identifier, 'MATLAB:load:couldNotReadFile') && trnums(i)>length(prtclfiles)
                        fprintf('%s\nLikely an aborted trial\n',e.message)
                        fprintf('Saved trial %d. Done!\n',i-1)
                        close(f)
                    end
                end
                if i< length(tr_index)
                    n2 =  tr_index(i+1)-1;
                else
                    n2 = n1+trial.params.durSweep*obj.samprate; % last trial
                end

                obj.gotoSection(n1,n2);
                plot(ax1,obj.cookietime,obj.cookie(strcmp(obj.channels,'probe_position'),:));
                plot(ax2,obj.cookietime,obj.cookie(strcmp(obj.channels,'arduino_output'),:));
                plot(ax3,obj.cookietime,obj.cookie(strcmp(obj.channels,'refchan'),:));
                title(ax1,['Trial ' num2str(i)]);
                drawnow;
                
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
                    fprintf('Saving trial %d\n',trnums(i))
                end
            end
            fprintf('Saving trial %d. Done!\n',i)
            close(f)
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
        
        function st = gotoSection(obj,n1,n2)
            % Trials will have to start within the length of the trial, so
            % make that the initial cookie size
            if n2<=n1
                error('n2 must be larger than n1')
            end
            T = (n2-n1)/obj.samprate;
            obj.cookiesize = T;

            fseek(obj.afid,obj.smp2ptr(n1),-1);
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
                st = false;
                return
            end
            nextcookie = obj.filterProbePosition(nextcookie);
            if obj.samp1 > obj.probehist_smp
                nextcookie = obj.filterStimhashval(nextcookie);
            end
            obj.updateoverview(nextcookie);
            
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
                obj.cookie(:,1:obj.cookiesamps-size(nextcookie,2)) = obj.cookie(:,size(nextcookie,2)+1:obj.cookiesamps);
                % put the next cookie at the end
                obj.cookie(:,obj.cookiesamps-size(nextcookie,2)+1:obj.cookiesamps) = nextcookie;
            end
            obj.cookie_x = ((1:size(obj.cookie,2)) - 1)/obj.samprate;
            obj.cookietime = obj.samp0/obj.samprate + obj.cookie_x;            
            st = true;
        end
        
        
        function delete(obj)
            fclose(obj.afid);
            fclose(obj.dfid);
        end
        
    end
    
    methods (Access = protected)
                
        function  next = filterProbePosition(obj,next)
            % first eliminate the transients
            pp = next(strcmp(obj.channels,'probe_position'),:);
            
            dpp = diff(pp);
            % target changes when the probe jumps from one side to other
            targetchanges = ~isempty(find(dpp<obj.gains(strcmp(obj.ai_channels,'probe_position')) * 4096 * -.9,1));
            
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
            
            % first check if the target changed on the last cookie
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
                        
                        if obj.probehist_smp <= obj.samp1
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
                    
                    if obj.probehist_smp <= obj.samp1
                        
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
                            obj.target = cat(2,obj.target,...
                                [obj.samp0+ei;
                                x;
                                w]);
                            
                        end
                    end
                end
            end
        end
        
        function  next = filterStimhashval(obj,next)
            % Where are the trials?
            % stimulus hash values must be >1V, so look for 1 volt changes.
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
            if obj.probehist_smp > obj.samp1
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
                obj.probehist_smp = obj.samp1;
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
                obj.probehist_smp = obj.samp1;
            else
                % Haven't encountered a target yet
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
                obj.afid = fopen(varargin{1});
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
            %% Note, delete this, this is to see the actualnumbers.
            %obj.gains(end) = 1;
            %%
            
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
                obj.dfid = fopen(regexprep(obj.filename,'_A.bin','_D.bin'));
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
    end
end


