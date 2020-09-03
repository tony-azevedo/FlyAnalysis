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
        
        ovfig
        ovax
        ovcntax
        
        chunksize
        cookiesize
        cookieunits
        
        chunk
        cookie
        
        chunktime
        cookietime
        
        target
        ylims
        
        statecount
    end
        
    properties (Hidden, SetAccess = protected)        
        chunksamps
        cookiesamps
        ai_ch_lines
        di_ch_lines
        chunk_x
        cookie_x
        samp0
        samp1
        viz_ch
        viz_ai_ch
        viz_di_ch
        probe_bounds
        ylims_
        target_lines
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
            obj.nextChunk;
        end
        
        function openFFWFig(obj)
            if isempty(obj.ffwfig) || ~ishghandle(obj.ffwfig)
                obj.ffwfig = figure;
                obj.ffwfig.Position = [28 380 1873 600];
                obj.ffwaiax = subplot(2,1,2,'parent',obj.ffwfig);
                obj.ffwdiax = subplot(2,1,1,'parent',obj.ffwfig);
                
                obj.ffwaiax.Units = 'normalized';
                obj.ffwaiax.Position = [.05 .1 .9 .55];
                obj.ffwaiax.NextPlot = 'add';

                obj.ffwdiax.Units = 'normalized';
                obj.ffwdiax.Position = [.05 .75 .9 .2];
                obj.ffwdiax.NextPlot = 'add';

                obj.ffwaiax.YLim = [20 900];
                obj.ffwdiax.YLim = [-.1 1.1];
                
                linkaxes([obj.ffwaiax,obj.ffwdiax],'x')
            end
            if ~isempty(obj.chunk) && isempty(obj.ffwaiax.Children)
                obj.replaceChunkLines;
            end
        end
        
        function nextChunk(obj,varargin)
            % adjust the chunk size if necessary
            if nargin>1
                if ~isempty(obj.cookiesize) && ~isempty(varargin{1}) && varargin{1} > obj.cookiesize
                    error('Chunk size must be smaller than cookie size')
                end
                if ~isempty(varargin{1})
                    obj.chunksize = varargin{1};
                end
            end
            if nargin > 2
                nextplot = varargin{2};
            else
                nextplot = 'replace';
            end
            if isempty(obj.chunksize)
                obj.chunksize = .1;
            end
            obj.chunksamps = round(obj.chunksize*obj.samprate);
            if length(obj.chunk_x)~=obj.chunksamps
                obj.chunk_x = ((1:obj.chunksamps) - 1)/obj.samprate;
            end
               
            isfirstchunk = (obj.pointer==obj.datastart);

            % Read data
            % the chunksize can change here:
            % like for the whole cookie, just append the extra
            nextreads = obj.chunksamps;
            if ~isempty(obj.chunk) && size(obj.chunk,2) < obj.chunksamps
                nextreads = obj.chunksamps-size(obj.chunk,2);
            end

            nextchunk = obj.readnext(nextreads);
            if isempty(nextchunk)
                return
            end
            
            % Append data and adjust time
            if ~isempty(obj.chunk) && size(obj.chunk,2) < obj.chunksamps
                % if expanding the chunksize
                obj.chunk = cat(2,obj.chunk,nextchunk);
                % obj.samp0 = obj.samp0;
            elseif size(nextchunk,2) < obj.chunksamps
                % reached the end of the file, just append the last partial
                % cookie
                obj.chunk(:,1:obj.chunksamps-size(nextchunk,2)) = obj.chunk(:,size(nextchunk,2)+1:obj.chunksamps);
                obj.chunk(:,obj.chunksamps-size(nextchunk,2)+1:obj.chunksamps) = nextchunk;
                obj.samp0 = obj.samp0 + size(nextchunk,2);
            else
                obj.chunk = nextchunk;
                obj.samp0 = obj.samp1;
            end
            if isfirstchunk
                obj.samp0=0;
            end
            obj.chunktime = obj.samp0/obj.samprate + obj.chunk_x;
            obj.samp1 = obj.samp0 + length(obj.chunk_x);
            
            %% Plot
            obj.openFFWFig
            if isempty(obj.ai_ch_lines) || ~all(isvalid(obj.ai_ch_lines))
                % Not plotted or screwed up
                obj.replaceChunkLines;
            elseif length(obj.ai_ch_lines(1).YData) > obj.chunksamps
                % If a cookie is already plotted, and I just want the next chunk
                switch nextplot
                    case 'append'
                        % scoot em over
                        for ch = 1:length(obj.ai_channels)
                            w = length(obj.ai_ch_lines(ch).XData);                            
                            obj.ai_ch_lines(ch).XData(1:w-obj.chunksamps) = obj.ai_ch_lines(ch).XData(obj.chunksamps+1:w);
                            obj.ai_ch_lines(ch).XData(w-obj.chunksamps+1:end) = obj.chunktime;
                            obj.ai_ch_lines(ch).YData(1:w-obj.chunksamps) = obj.ai_ch_lines(ch).YData(obj.chunksamps+1:w);
                            obj.ai_ch_lines(ch).YData(w-obj.chunksamps+1:end) = obj.chunk(strcmp(obj.channels,obj.ai_channels{ch}),:);
                        end
                        for ch = 1:length(obj.di_channels)
                            w = length(obj.di_ch_lines(ch).XData);
                            obj.di_ch_lines(ch).XData(1:w-obj.chunksamps) = obj.di_ch_lines(ch).XData(obj.chunksamps+1:w);
                            obj.di_ch_lines(ch).XData(w-obj.chunksamps+1:end) = obj.chunktime;
                            obj.di_ch_lines(ch).YData(1:w-obj.chunksamps) = obj.di_ch_lines(ch).YData(obj.chunksamps+1:w);
                            obj.di_ch_lines(ch).YData(w-obj.chunksamps+1:end) = obj.chunk(strcmp(obj.channels,obj.di_channels{ch}),:);
                        end
                    case 'replace'
                        obj.replaceChunkLines;
                end
            else
                % Just change the data
                for ch = 1:length(obj.ai_channels)
                    obj.ai_ch_lines(ch).XData = obj.chunktime;
                    obj.ai_ch_lines(ch).YData = obj.chunk(strcmp(obj.channels,obj.ai_channels{ch}),:);
                end
                for ch = 1:length(obj.di_channels)
                    obj.di_ch_lines(ch).XData = obj.chunktime;
                    obj.di_ch_lines(ch).YData = obj.chunk(strcmp(obj.channels,obj.di_channels{ch}),:);
                end
            end
            obj.cleanupFigure
        end
        
        function nextCookie(obj,varargin)
            % adjust cookie size
            if nargin>1
                if ~isempty(obj.chunksize) && varargin{1} <= obj.chunksize
                    error('Cookie size must be larger than chunk size')
                end
                obj.cookiesize = varargin{1};                
            end
            if isempty(obj.cookiesize)
                obj.cookiesize = 5;
            end
            obj.readCookie;
            % plot the cookie
            obj.openFFWFig
            if isempty(obj.ai_ch_lines) || ~all(isvalid(obj.ai_ch_lines)) || length(obj.ai_ch_lines(1).YData) ~= obj.cookiesamps
                obj.replaceCookieLines
            elseif length(obj.ai_ch_lines(1).YData) == obj.cookiesamps
                % Just change the data
                for ch = 1:length(obj.ai_channels)
                    obj.ai_ch_lines(ch).XData = obj.cookietime;
                    obj.ai_ch_lines(ch).YData = obj.cookie(strcmp(obj.channels,obj.ai_channels{ch}),:);
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
                     
        function ffwRead(obj,varargin)
            if isempty(obj.cookiesize)
                obj.cookiesize = 5;
            end
            while obj.readCookie
                fprintf('Current time: %g\n',obj.samp1/obj.samprate);
            end
        end
        
        function st = readCookie(obj)
            obj.cookiesamps = round(obj.cookiesize*obj.samprate);
            obj.cookie_x = ((1:obj.cookiesamps) - 1)/obj.samprate;
            
            
            % Read, append and adjust time
            isfirstcookie = (obj.pointer==obj.datastart);
            
            % read some more of the cookie
            nextreads = obj.cookiesamps;
            if isempty(obj.cookie)
                obj.cookie = obj.chunk;
            end
            if size(obj.cookie,2) < obj.cookiesamps
                nextreads = obj.cookiesamps-size(obj.cookie,2);
            end
            
            % Read more data
            nextcookie = obj.readnext(nextreads);
            if isempty(nextcookie)
                st = false;
                return
            end
            
            % Append to data and update time
            if ~isempty(obj.cookie) && size(obj.cookie,2) < obj.cookiesamps
                obj.cookie = cat(2,obj.cookie,nextcookie);
                % obj.samp0 = obj.samp0;
            elseif size(nextcookie,2) < obj.cookiesamps
                % reached the end of the file, just append the last partial
                % cookie
                obj.cookie(:,1:obj.cookiesamps-size(nextcookie,2)) = obj.cookie(:,size(nextcookie,2)+1:obj.cookiesamps);
                obj.cookie(:,obj.cookiesamps-size(nextcookie,2)+1:obj.cookiesamps) = nextcookie;
                obj.samp0 = obj.samp0 + size(nextcookie,2);
            else
                obj.cookie = nextcookie;
                obj.samp0 = obj.samp1;
            end
            if isfirstcookie
                obj.samp0 = 0;
            end
            obj.cookietime = obj.samp0/obj.samprate + obj.cookie_x;
            obj.samp1 = obj.samp0 + length(obj.cookie_x);

            st = true;
        end
        
        function ffwRecording(obj,varargin)
            obj.chunksize = .1;
            obj.rewind

            % Start from the first chunk and expand timescale till cookie
            % length is reached
            if nargin > 1
                obj.cookiesize = varargin{1};
            else
                obj.cookiesize = 5;
            end
            if nargin > 2
                dt = varargin{2};
            else
                dt = .01;
            end
            obj.cookiesamps = round(obj.cookiesize*obj.samprate);

            fprintf('Fast forwarding through recording\n')
            figure(obj.ffwfig);
            pause(.1)
            del = obj.chunksize;
            Del = 2*del; 
            while true
                try obj.nextChunk(Del);
                    Del = round(1000*(Del+del))/1000;
                catch
                    break
                end
                drawnow
                pause(dt)
            end
            obj.chunksize = del;
            pause(.02)
            while obj.pointer<obj.filesize
                obj.nextChunk([],'append');
                drawnow
                pause(dt)
            end
        end
        
        function backup(obj)
            % back up a cookie
            
        end
        
        function rewind(obj)
            % go to the beginning and plot the first chunk or cookie
            fprintf('Rewinding to beginning\n')
            fseek(obj.afid,obj.datastart,-1);
            obj.pointer = obj.datastart;
            obj.samp0 = 0;
            obj.samp1 = 0;
            obj.nextChunk
        end
 
        function overview(obj)
            trgclr = [0 0 .8];
            if isempty(obj.ovfig) || ~ishghandle(obj.ovfig)
                obj.ovfig = figure;
                obj.ovfig.Position = [471 136 915 355];
                obj.ovax = subplot(2,1,1,'parent',obj.ovfig);
                obj.ovcntax = subplot(2,1,2,'parent',obj.ovfig);
                
                obj.ovax.Units = 'normalized';
                obj.ovax.Position = [.06 .52 .9 .438];
                obj.ovax.NextPlot = 'add';
                obj.ovax.XAxisLocation = 'top';
                
                obj.ovcntax.Units = 'normalized';
                obj.ovcntax.Position = [.06 .1 .9 .38];
                obj.ovcntax.NextPlot = 'add';
                
            else
                cla(obj.ovax)
            end
            for tidx = 1:size(obj.target,2)-1
                plot(obj.ovax,...
                    [obj.target(1,tidx) obj.target(1,tidx+1)]/obj.samprate,...
                    obj.target(2,tidx)*[1 1],'color',trgclr)
                plot(obj.ovax,...
                    [obj.target(1,tidx) obj.target(1,tidx+1)]/obj.samprate,...
                    (obj.target(2,tidx)+obj.target(3,tidx))*[1 1],'color',trgclr); 
                
            end
            tidx = tidx+1;
            plot(obj.ovax,...
                [obj.target(1,tidx) obj.samp1]/obj.samprate,...
                obj.target(2,tidx)*[1 1],'color',trgclr)
            plot(obj.ovax,...
                [obj.target(1,tidx) obj.samp1]/obj.samprate,...
                (obj.target(2,tidx)+obj.target(3,tidx))*[1 1],'color',trgclr);
            
            obj.ovax.YLim = obj.ylims_;
            obj.ovax.XLim = [0 obj.samp1/obj.samprate];
            
            x = obj.target(1,:);
            x = [0 x obj.samp1];
            y = obj.statecount;
            y_total = y(1,:)+y(2,:);
            y_ratio = y(1,:)./y_total;
            % l = [diff(x)>20000,true];
            %             x = x(l);
            %             y = y(l);
            x_center = x(1:end-1)+diff(x)/2;
            x_center = x_center/obj.samprate;
            x = x/obj.samprate;
            svl = mean(1./diff(x));
            short_x = 1./diff(x) > svl;

            plot(obj.ovcntax,[x(1) x(end)],[0 0],'color',[.8 .8 .8])
            
            % plot all points
            plot(obj.ovcntax, x_center(~short_x), y_ratio(~short_x),'color',[.8,0 0], 'linestyle', '--', 'Marker','.','Markersize',10);
            
            % plot insignificant ones in pink
            plot(obj.ovcntax, x_center(short_x), y_ratio(short_x),'color',[1,.8 .8], 'linestyle', 'none', 'Marker','.','Markersize',10);
       
            obj.ovcntax.YLim = [-.05 1];
            obj.ovcntax.XLim = [0 obj.samp1/obj.samprate];
            
            obj.ovax.NextPlot = 'replace';
            obj.ovcntax.NextPlot = 'replace';

        end
        
        function chooseChannels(obj,chnnames)
            obj.viz_ch = false(size(obj.channels)); 
            obj.viz_ai_ch = false(size(obj.ai_channels)); 
            obj.viz_di_ch = false(size(obj.di_channels)); 
            for n = 1:length(chnnames)
                if any(strcmp(obj.ai_channels,chnnames{n}))
                    fprintf('%s is visible\n',chnnames{n});
                    obj.viz_ai_ch(strcmp(obj.ai_channels,chnnames{n})) = true;
                elseif any(strcmp(obj.di_channels,chnnames{n}))
                    fprintf('%s is visible\n',chnnames{n});
                    obj.viz_di_ch(strcmp(obj.di_channels,chnnames{n})) = true;
                end
            end
            set(obj.ai_ch_lines(obj.viz_ai_ch),'Visible','on')
            set(obj.ai_ch_lines(~obj.viz_ai_ch),'Visible','off')
            set(obj.di_ch_lines(obj.viz_di_ch),'Visible','on')
            set(obj.di_ch_lines(~obj.viz_di_ch),'Visible','off')
            obj.channels_to_display = [obj.ai_channels(obj.viz_ai_ch);obj.di_channels(obj.viz_di_ch)];
            obj.ylims = [];
            obj.cleanupFigure
        end
        
        function delete(obj)
            fclose(obj.afid);
            fclose(obj.dfid);
            close(obj.ffwfig);
        end
        
        function nextTrial(obj)
            
        end
    end
    
    methods (Access = protected)
        
        function cleanupFigure(obj)
            obj.ffwaiax.XLim = [min(obj.ai_ch_lines(1).XData) max(obj.ai_ch_lines(1).XData)];
            if ~isempty(obj.cookie)
                dspldmin = min(min(obj.cookie(obj.viz_ai_ch,:)));
                dspldmax = max(max(obj.cookie(obj.viz_ai_ch,:)));
            elseif ~isempty(obj.chunk)
                dspldmin = min(min(obj.chunk(obj.viz_ai_ch,:)));
                dspldmax = max(max(obj.chunk(obj.viz_ai_ch,:)));
            else
                dspldmin = [];
                dspldmax = [];
            end
            obj.improveYLims(dspldmin, dspldmax);
            
            obj.ffwaiax.YLim = obj.ylims_;
            set(obj.ai_ch_lines(obj.viz_ai_ch),'Visible','on');
            set(obj.ai_ch_lines(~obj.viz_ai_ch),'Visible','off');
            set(obj.di_ch_lines(obj.viz_di_ch),'Visible','on');
            set(obj.di_ch_lines(~obj.viz_di_ch),'Visible','off');
            
            obj.addTargetLines;
        end
                
        function improveYLims(obj, mn, mx)
            if ~isempty(mn)
                mx = max([mx mn+1]); % incase they are equal
                if isempty(obj.ylims)
                    obj.ylims  = [mn mx];
                end
                
                if isempty(obj.target)
                    obj.ylims = [...
                        min([obj.ylims(1), mn]), ...
                        max([obj.ylims(2), mx])];
                else
                    obj.ylims = [...
                        min([obj.ylims(1), mn, min(obj.target(2,:))]), ...
                        max([obj.ylims(2), mx, max(obj.target(2,:)+ min(obj.target(3,:)))])];
                end
                % just expand them a bit, to make sure you can see all of
                % the lines
                obj.ylims_ = obj.ylims - 0.1*diff(obj.ylims) + [0 1] * 0.2 * diff(obj.ylims);
            end
        end
        
        function addTargetLines(obj)
            if isempty(obj.target)
                return
            end
            tclr = [.6 .6 1];
            delT = find(obj.target(1,:) > obj.samp0 &  obj.target(1,:) < obj.samp1);
            if isempty(delT) 
                % no target here, don't change the target lines
                if isempty(obj.target_lines)
                    obj.target_lines = gobjects(2,1);
                    obj.target_lines(1) = plot(obj.ffwaiax,obj.ffwaiax.XLim,[nan nan],'color',tclr);
                    obj.target_lines(2) = plot(obj.ffwaiax,obj.ffwaiax.XLim,[nan nan],'color',tclr);
                elseif ~isempty(obj.target_lines)
                    obj.target_lines = obj.target_lines(:,end);
                    obj.target_lines(1).XData = obj.ffwaiax.XLim;
                    obj.target_lines(2).XData = obj.ffwaiax.XLim;
                end
            else
                % go through the target changes and plot the targets
                if isempty(obj.target_lines)
                    obj.target_lines = gobjects(2,1);
                    obj.target_lines(1) = plot(obj.ffwaiax,[obj.samp0 obj.target(1,delT(1))]/obj.samprate,[nan nan],'color',tclr);
                    obj.target_lines(2) = plot(obj.ffwaiax,[obj.samp0 obj.target(1,delT(1))]/obj.samprate,[nan nan],'color',tclr);
                else
                    delete(obj.target_lines(:,1:end-1));
                    obj.target_lines = obj.target_lines(:,end);
                    obj.target_lines(1).XData = [obj.samp0/obj.samprate obj.target(1,delT(1))/obj.samprate];
                    obj.target_lines(2).XData = [obj.samp0/obj.samprate obj.target(1,delT(1))/obj.samprate];
                end
                
                for tidx = 1:length(delT)-1
                    obj.target_lines = cat(2,obj.target_lines,gobjects(2,1));
                    obj.target_lines(1,tidx+1) = plot(obj.ffwaiax,[obj.target(1,delT(tidx)) obj.target(1,delT(tidx+1))]/obj.samprate,obj.target(2,delT(tidx))*[1 1],'color',tclr);
                    obj.target_lines(2,tidx+1) = plot(obj.ffwaiax,[obj.target(1,delT(tidx)) obj.target(1,delT(tidx+1))]/obj.samprate,obj.target(2,delT(tidx))+obj.target(3,delT(tidx))*[1 1],'color',tclr);
                end
                
                tidx = length(delT);
                obj.target_lines = cat(2,obj.target_lines,gobjects(2,1));
                obj.target_lines(1,tidx+1) = plot(obj.ffwaiax,[obj.target(1,delT(tidx)) obj.samp1]/obj.samprate,obj.target(2,delT(tidx))*[1 1],'color',tclr);
                obj.target_lines(2,tidx+1) = plot(obj.ffwaiax,[obj.target(1,delT(tidx)) obj.samp1]/obj.samprate,(obj.target(2,delT(tidx))+obj.target(3,delT(tidx)))*[1 1],'color',tclr);
            end
                
            
        end
    
        
        function replaceChunkLines(obj)
            obj.ai_ch_lines = gobjects(size(obj.ai_channels));
            for ch = 1:length(obj.ai_channels)
                obj.ai_ch_lines(ch) = plot(obj.ffwaiax,obj.chunktime, obj.chunk(strcmp(obj.channels,obj.ai_channels{ch}),:));
                obj.ai_ch_lines(ch).Tag = obj.ai_channels{ch};
                obj.ai_ch_lines(ch).DisplayName = obj.ai_channels{ch};
            end
            obj.di_ch_lines = gobjects(size(obj.di_channels));
            for ch = 1:length(obj.di_channels)
                obj.di_ch_lines(ch) = plot(obj.ffwdiax,obj.chunktime, obj.chunk(strcmp(obj.channels,obj.di_channels{ch}),:));
                obj.di_ch_lines(ch).Tag = obj.di_channels{ch};
                obj.di_ch_lines(ch).DisplayName = obj.di_channels{ch};
            end
        end
   
        function replaceCookieLines(obj)
            obj.ai_ch_lines = gobjects(size(obj.ai_channels));
            for ch = 1:length(obj.ai_channels)
                obj.ai_ch_lines(ch) = plot(obj.ffwaiax,obj.cookietime, obj.cookie(strcmp(obj.channels,obj.ai_channels{ch}),:));
                obj.ai_ch_lines(ch).Tag = obj.ai_channels{ch};
                obj.ai_ch_lines(ch).DisplayName = obj.ai_channels{ch};
            end
            obj.di_ch_lines = gobjects(size(obj.di_channels));
            for ch = 1:length(obj.di_channels)
                obj.di_ch_lines(ch) = plot(obj.ffwdiax,obj.cookietime, obj.cookie(strcmp(obj.channels,obj.di_channels{ch}),:));
                obj.di_ch_lines(ch).Tag = obj.di_channels{ch};
                obj.di_ch_lines(ch).DisplayName = obj.di_channels{ch};
            end
        end

        
        function next = readnext(obj,nextreads)
            next = fread(obj.afid,[length(obj.ai_channels),nextreads],'int16=>double');
            obj.pointer = ftell(obj.afid);
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
            %nextd = nextd * diff(obj.probe_bounds) + obj.probe_bounds(1);
            
            next = cat(1,next, nextd);

            next = obj.filterProbePosition(next);
            targets = [];
            if ~isempty(obj.target)
                targets = obj.target(1,(obj.target(1,:)>obj.samp1));
            end
            if ~isempty(targets)
                targets = targets-obj.samp1;
                ardon = nextd(strcmp(obj.di_channels,'arduino_output'),:);
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
            end
        end
        
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
                    
                    bottom = min(pp(di:di+1000));
                    bottom = pp(di+1);
                    ei = find(pp(di:di+1000)==bottom,1,'last')+di;
                    target_vals = unique(pp(di+1:ei-1));
                    target_vals = target_vals(target_vals~=bottom);
                    
                    if length(target_vals)~=2
                        error('Handle this case')
                    end
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
                        
                    if isempty(obj.target)
                        obj.target = ...
                            [obj.samp1+ei;
                            x;
                            w];
                    else
                        obj.target = cat(2,obj.target,...
                            [obj.samp1+ei;
                            x;
                            w]);

                    end
                    next(strcmp(obj.ai_channels,'probe_position'),fi:ei) = lastpos;
                end
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
        end
    end
end


%         function aChunk(obj,varargin)
%             if nargin > 1
%                 relativechunk = varargin{1};
%             else
%                 relativechunk = 1;
%             end
%             if isempty(obj.chunk)
%                 % no chunk yet
%                 obj.nextChunk;
%                 return                
%             elseif isempty(obj.ai_ch_lines) || ~all(isvalid(obj.ai_ch_lines)) 
%                 % maybe there is a chunk, but it's not plotted correctly
%                 obj.nextChunk;
%                 return
%             elseif length(obj.ai_ch_lines(1).YData) == obj.chunksamps
%                 % a chunk is already plotted
%                 return
%             elseif length(obj.ai_ch_lines(1).YData) > obj.chunksamps
%                 % If a cookie is already plotted, and I just want a chunk
%                 cla(obj.ffwaiax);
%                 startingsamp = round(relativechunk*obj.cookiesamps);
%                 if startingsamp > obj.cookiesamps-obj.chunksamps+1
%                     startingsamp = obj.cookiesamps-obj.chunksamps;
%                 end
%                 obj.chunk = obj.cookie(:,startingsamp+1:startingsamp+obj.chunksamps);
%                 obj.ai_ch_lines = plot(obj.ffwaiax, obj.chunk');
%                 for ch = 1:length(obj.channels)
%                     obj.ai_ch_lines(ch).Tag = obj.channels{ch};
%                     obj.ai_ch_lines(ch).DisplayName = obj.channels{ch};
%                 end
%             else
%                 % 
%                 fprintf(1,'What is this case?\n')
%             end            
%         end
%         
%         function aCookie(obj,varargin)
%             if nargin > 1
%                 relativecookie = varargin{1};
%             else
%                 relativechunk = 1;
%             end
%             if isempty(obj.chunk)
%                 % no chunk yet to be relative to
%                 obj.nextCookie;
%                 return
%             elseif isempty(obj.ai_ch_lines) || ~all(isvalid(obj.ai_ch_lines))
%                 % maybe there is a chunk or cookie, but it's not plotted
%                 % correctly, just move on
%                 obj.nextCookie;
%                 return
%             elseif length(obj.ai_ch_lines(1).YData) == obj.cookiesamps
%                 % a cookie is already plotted
%                 return
%             elseif isempty(obj.cookie)
%                 % There is a chunk, just fill out the rest of the cookie
%                 obj.cookie = obj.chunk;
%                 obj.nextCookie; % This assumes default length of 5 seconds
%             elseif length(obj.ai_ch_lines(1).YData) < obj.cookiesamps
%                 % a chunk is plotted, want the surrounding cookie
%                 cla(obj.ffwaiax);
%                 startingsamp = obj.cookiesamps - round(relativechunk*obj.cookiesamps);
%                 if startingsamp > obj.cookiesamps-obj.chunksamps+1
%                     startingsamp = obj.cookiesamps-obj.chunksamps;
%                 end
%                 obj.chunk = obj.cookie(:,startingsamp+1:startingsamp+obj.chunksamps);
%                 obj.ai_ch_lines = plot(obj.ffwaiax, obj.chunk');
%                 for ch = 1:length(obj.channels)
%                     obj.ai_ch_lines(ch).Tag = obj.channels{ch};
%                     obj.ai_ch_lines(ch).DisplayName = obj.channels{ch};
%                 end
%             else
%                 %
%                 fprintf(1,'What is this case?\n')
%             end
%         end