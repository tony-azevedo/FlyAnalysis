a(:,:,1) =[

   373   310
   300   356
   193   313
    74   217
    ]

a(:,:,2) = [

   373   310
   300   356
   193   313
    10   190
    ]



%%
    

%define video file
output_video = [init.figpath '\' filename(1:end-4) '_combined.avi'];

if init.make_movie == 1
    writerObj = VideoWriter(output_video,'Motion JPEG AVI');
% writerObj.Quality = 100;
writerObj.FrameRate = fps;
open(writerObj);
end

fig1 = figure(1);clf;hold all;set(fig1,'color', 'w', 'position', [50 50 800 800]);
set(gcf,'Renderer','painters');% Setting the Renderer property to zbuffer or Painters works around limitations of getframe with the OpenGL® renderer on some Windows systems.

%% Create a set of frames and write each frame to the file.
clear frame_diffs;
for pp = 2:length(mov)-1
    frame_diffs(pp) = sum(mov(pp).cdata(:) - mov(pp-1).cdata(:));
end
frame_diffs(1:3) = mean(frame_diffs); %%weird onset transient
frame_diffs = (frame_diffs-min(frame_diffs(20:end)))/max(frame_diffs(20:end));
fly_movement = zeros(1,length(voltage));
for jj = 1:length(frame_diffs)-1
fly_movement(vid_incs(jj):vid_incs(jj+1)) = frame_diffs(jj);
end

extra = fs;
frame_extra = 0;
frame_vec =(1:length(frame_diffs))/fps;
start = vid_incs(1)-extra;
finish = vid_decs(end)+extra;if finish<length(voltage); finish = length(voltage)-2*extra;end
frame_count = 1;
run_vid_incs = vid_incs;
offset = 8;
bottom = mean(voltage(voltage~=0));
time_vec = (1:length(voltage))/fs;
linesize = 1;

for kk = 1:round(((finish-start-2*extra)/fs)*fps)
    s1 = subplot(4,5, [1:10]);hold all; box off;
    
    if kk == 1
        window = time_vec(start-extra:floor(start+1/fps*fs+extra));
        this_voltage = voltage(start-extra:floor(start+1/fps*fs)+extra);
        this_fly_movement= 10*fly_movement(start-extra:floor(start+1/fps*fs)+extra)+bottom+offset;
        
        h=plot(window, this_voltage, 'k', 'linewidth', linesize);
        h.YDataSource = 'this_voltage';
        h.XDataSource = 'window';
        
        hhh=plot(window, this_fly_movement, 'b', 'linewidth', linesize);
        hh.YDataSource = 'this_fly_movement';
        hhh.XDataSource = 'window';
        
        hhhh = plot([window(extra) window(extra)], [-100 0],'c', 'linewidth', linesize);
        hhhh.XDataSource = 'window';
        hhhh.YDataSource = 'window';
    end
    
    try window = time_vec(start-extra:floor(start+1/fps*fs+extra));
    catch; window = time_vec(start-extra:end);end
    
    this_voltage = voltage(start-extra:floor(start+1/fps*fs)+extra);
    this_fly_movement= 10*fly_movement(start-extra:floor(start+1/fps*fs)+extra)+bottom-offset-7;
    refreshdata([h hhh hhhh],'caller');
    
    ylabel('V_m (mV)','fontsize', 11); xlabel('time (s)', 'fontsize', 11);
    set(gca,'fontsize', 11);
    ylim([-60 -30]);
    title(filename, 'interpreter', 'none', 'fontsize', 11);
    
    if any(any(bsxfun(@eq, window(1:extra)*fs-1, run_vid_incs))) %%look for vid_incs
        s2 = subplot(4,5,11:20);
        set(gca,'nextplot','replacechildren');
        imshow(mov(frame_count).cdata);
        if mod(frame_count,30) == 0 ;xlabel(['frame ' num2str(frame_count)]);end
        run_vid_incs(frame_count) = [0];%% erase frame if already shown
        frame_count = frame_count+1;
    end
    
    start = start+floor(1/fps*fs)+1;
    if init.make_movie == 1;frame = getframe(fig1); writeVideo(writerObj,frame);end
    if init.make_tifs == 1;export_fig(fig1,[this_exposure_path '\tifs\' filename(1:end-2) '_' num2str(kk) '.tif'], '-tif','-nocrop');end
end

if init.make_movie == 1;close(writerObj);end
close(fig1); 

fig2 = figure(2);clf;hold all;set(fig2,'color', 'w', 'position', [50 50 800 800]);
set(gcf,'Renderer','painters');% Setting the Renderer property to zbuffer or Painters works around limitations of getframe with the OpenGL® renderer on some Windows systems.

plot(time_vec(extrapads+1:end-extrapads), voltage(extrapads+1:end-extrapads), 'k', 'linewidth', linesize);
plot(time_vec(extrapads+1:end-extrapads), 10*fly_movement(extrapads+1:end-extrapads)+bottom+offset, 'b', 'linewidth', linesize);
ylabel('V_m (mV)','fontsize', 11); xlabel('time (s)', 'fontsize', 11);
ylim([-60 -30]);

if init.make_pdf == 1
export_fig(fig2,[init.figpath '\' filename(1:end-4) '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
end
    