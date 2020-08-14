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
        di_channels
        protocol
        samprate
        
        ffwfig
        ffwax
        
        chunksize
        cookiesize
        cookieunits
        
        chunk
        cookie
        
        chunktime
        cookietime
    end
        
    properties (Hidden, SetAccess = protected)        
        chunksamps
        cookiesamps
        ch_lines
        chunk_x
        cookie_x
        samp0
        samp1
    end

    methods
        function obj = ContinuousDataReader(filename,varargin)
            obj.readHeader(filename);
            obj.readDHeader;
            tmp = dir(obj.name);
            obj.filesize = tmp.bytes;
            obj.cookieunits = 'seconds';
            obj.samp0 = 0;
            obj.samp1 = 0;
            obj.nextChunk;
        end
        
        function openFFWFig(obj)
            if isempty(obj.ffwfig) || ~ishghandle(obj.ffwfig)
                obj.ffwfig = figure;
                obj.ffwfig.Position = [28 560 1873 420];
                obj.ffwax = subplot(1,1,1,'parent',obj.ffwfig);
                obj.ffwax.Units = 'normalized';
                obj.ffwax.Position = [.05 .1 .9 .8];
                obj.ffwax.NextPlot = 'add';
                obj.ffwax.YLim = [-600 1280];
            end
            if ~isempty(obj.chunk) && isempty(obj.ffwax.Children)
                obj.ch_lines = plot(obj.chunk');
                for ch = 1:length(obj.channels)
                    obj.ch_lines(ch).Tag = obj.channels{ch};
                    obj.ch_lines(ch).DisplayName = obj.channels{ch};
                end
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

            nextchunk = fread(obj.afid,[length(obj.channels),nextreads],'int16=>double');
            obj.pointer = ftell(obj.afid);
            if isempty(nextchunk)
                % Reached the end of the file
                fprintf('Reached the end of the file\n')
                if obj.pointer ~= obj.filesize
                    error('Filesize and pointer are not in alignment')
                end
                return
            end
            nextchunk = bsxfun(@times, obj.gains, nextchunk);
            
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
            
            % Plot
            obj.openFFWFig
            if isempty(obj.ch_lines) || ~all(isvalid(obj.ch_lines))
                % Not plotted or screwed up
                cla(obj.ffwax);
                obj.ch_lines = plot(obj.ffwax,obj.chunktime, obj.chunk');
                for ch = 1:length(obj.channels)
                    obj.ch_lines(ch).Tag = obj.channels{ch};
                    obj.ch_lines(ch).DisplayName = obj.channels{ch};
                end
            elseif length(obj.ch_lines(1).YData) > obj.chunksamps
                % If a cookie is already plotted, and I just want the next chunk
                switch nextplot
                    case 'append'
                        for ch = 1:length(obj.channels)
                            w = length(obj.ch_lines(ch).XData);                            
                            obj.ch_lines(ch).XData(1:w-obj.chunksamps) = obj.ch_lines(ch).XData(obj.chunksamps+1:w);
                            obj.ch_lines(ch).XData(w-obj.chunksamps+1:end) = obj.chunktime;
                            obj.ch_lines(ch).YData(1:w-obj.chunksamps) = obj.ch_lines(ch).YData(obj.chunksamps+1:w);
                            obj.ch_lines(ch).YData(w-obj.chunksamps+1:end) = obj.chunk(ch,:);
                        end                        
                    case 'replace'
                        cla(obj.ffwax);
                        obj.ch_lines = plot(obj.ffwax, obj.chunktime, obj.chunk');
                        for ch = 1:length(obj.channels)
                            obj.ch_lines(ch).Tag = obj.channels{ch};
                            obj.ch_lines(ch).DisplayName = obj.channels{ch};
                        end
                end
            else
                % Just plot em
                for ch = 1:length(obj.channels)
                    obj.ch_lines(ch).XData = obj.chunktime;
                    obj.ch_lines(ch).YData = obj.chunk(ch,:);
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
            nextcookie = fread(obj.afid,[length(obj.channels),nextreads],'int16=>double');
            obj.pointer = ftell(obj.afid);
            if isempty(nextcookie) 
                % Reached the end of the file
                fprintf('Reached the end of the file\n')
                if obj.pointer ~= obj.filesize
                    error('Filesize and pointer are not in alignment')
                end
                return
            end            
            nextcookie = bsxfun(@times, obj.gains, nextcookie);
            
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

            % plot the cookie
            obj.openFFWFig
            if isempty(obj.ch_lines) || ~all(isvalid(obj.ch_lines)) || length(obj.ch_lines(1).YData) ~= obj.cookiesamps
                cla(obj.ffwax);
                obj.ch_lines = plot(obj.ffwax, obj.cookietime, obj.cookie);
                for ch = 1:length(obj.channels)
                    obj.ch_lines(ch).Tag = obj.channels{ch};
                    obj.ch_lines(ch).DisplayName = obj.channels{ch};
                end
            elseif length(obj.ch_lines(1).YData) == obj.cookiesamps
                % Just change the data
                for ch = 1:length(obj.channels)
                    obj.ch_lines(ch).XData = obj.cookietime;
                    obj.ch_lines(ch).YData = obj.cookie(ch,:);
                end
            else
                error('What is this case?')
            end
            obj.cleanupFigure
        end
        
        function aChunk(obj,varargin)
            if nargin > 1
                relativechunk = varargin{1};
            else
                relativechunk = 1;
            end
            if isempty(obj.chunk)
                % no chunk yet
                obj.nextChunk;
                return                
            elseif isempty(obj.ch_lines) || ~all(isvalid(obj.ch_lines)) 
                % maybe there is a chunk, but it's not plotted correctly
                obj.nextChunk;
                return
            elseif length(obj.ch_lines(1).YData) == obj.chunksamps
                % a chunk is already plotted
                return
            elseif length(obj.ch_lines(1).YData) > obj.chunksamps
                % If a cookie is already plotted, and I just want a chunk
                cla(obj.ffwax);
                startingsamp = round(relativechunk*obj.cookiesamps);
                if startingsamp > obj.cookiesamps-obj.chunksamps+1
                    startingsamp = obj.cookiesamps-obj.chunksamps;
                end
                obj.chunk = obj.cookie(:,startingsamp+1:startingsamp+obj.chunksamps);
                obj.ch_lines = plot(obj.ffwax, obj.chunk');
                for ch = 1:length(obj.channels)
                    obj.ch_lines(ch).Tag = obj.channels{ch};
                    obj.ch_lines(ch).DisplayName = obj.channels{ch};
                end
            else
                % 
                fprintf(1,'What is this case?\n')
            end            
        end
        
        function aCookie(obj,varargin)
            if nargin > 1
                relativecookie = varargin{1};
            else
                relativechunk = 1;
            end
            if isempty(obj.chunk)
                % no chunk yet to be relative to
                obj.nextCookie;
                return
            elseif isempty(obj.ch_lines) || ~all(isvalid(obj.ch_lines))
                % maybe there is a chunk or cookie, but it's not plotted
                % correctly, just move on
                obj.nextCookie;
                return
            elseif length(obj.ch_lines(1).YData) == obj.cookiesamps
                % a cookie is already plotted
                return
            elseif isempty(obj.cookie)
                % There is a chunk, just fill out the rest of the cookie
                obj.cookie = obj.chunk;
                obj.nextCookie; % This assumes default length of 5 seconds
            elseif length(obj.ch_lines(1).YData) < obj.cookiesamps
                % a chunk is plotted, want the surrounding cookie
                cla(obj.ffwax);
                startingsamp = obj.cookiesamps - round(relativechunk*obj.cookiesamps);
                if startingsamp > obj.cookiesamps-obj.chunksamps+1
                    startingsamp = obj.cookiesamps-obj.chunksamps;
                end
                obj.chunk = obj.cookie(:,startingsamp+1:startingsamp+obj.chunksamps);
                obj.ch_lines = plot(obj.ffwax, obj.chunk');
                for ch = 1:length(obj.channels)
                    obj.ch_lines(ch).Tag = obj.channels{ch};
                    obj.ch_lines(ch).DisplayName = obj.channels{ch};
                end
            else
                %
                fprintf(1,'What is this case?\n')
            end
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
            obj.ffwax.XLim = [min(obj.ch_lines(1).XData) max(obj.ch_lines(1).XData)];
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
            obj.channels = split(columnnames);

            bra = ket;
            
            % Read gains
            while bra~='<'
                bra = fread(obj.afid,1,'char');
            end
            gain = zeros(size(obj.channels));
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