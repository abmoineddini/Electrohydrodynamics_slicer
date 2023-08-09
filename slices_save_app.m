function []= slices_save_app(movelist_all, z_slices,delay)
% Amirbahador Moineddini
% 23/08/2021
% This Function will save each layer as a image

hold on;
axis([-Inf Inf -Inf Inf z_slices(1) z_slices(end)])
delay = delay*1000;
% movelist_all = movelist_all(~any(cellfun('isempty', A), 2), :);
%assignin('base','Movelist',movelist_all);
for i = 2: size(movelist_all,2)
    close all
    mlst_all = movelist_all{i};
    name = num2str(z_slices(i));
    namevid = VideoWriter(name+"Video","MPEG-4"); %open video file
    namevid.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
    open(namevid)
    
    hold on
    if delay >0
        if ~isempty(mlst_all)
            for j = 1:size(mlst_all,1)-1
                plot(mlst_all(j:j+1,1),mlst_all(j:j+1,2),'k','LineWidth',1)
                pause(delay)
                xlim([0 2600]);
                ylim([0 2600]);
                view(2);
                frame = getframe();
                writeVideo(namevid, frame);
            end
        else
            frame = [];
        end  
    else
        if ~isempty(mlst_all)
            plot(mlst_all(:,1),mlst_all(:,2),'k','LineWidth',1)
            xlim([0 2600]);
            ylim([0 2600]);
            view(2);
            frame = getframe();
        else
            frame = [];
        end
    end
    set(gca,'XTick',[], 'YTick', [])
    hold off
    export_fig(name, '-dpng');
    writeVideo(namevid, frame);
    close(namevid)
end   
end