function segOutAvi( seg )
% Make video showing segmentation with original video.

% Initialization
frame_rate = 30;
movie_name = seg.cur.video;
video_out_path = [seg.path.trial 'segmentationVideo/'];
if exist(video_out_path)~=7; mkdir(video_out_path); end
vidMask = seg.cur.fgMask;
orig_path = [seg.path.origIm_in movie_name '/'];
vidName = [video_out_path movie_name '_maskMovie'];

% Make video for mask.
if exist([vidName '.avi'])==0; initVid;
    fprintf('Making video for video mask.\n');
    [~, ~, ~, frame_list] = imageFolderInfo(orig_path);
    for frameNum=1:seg.cur.vid_size(3)
        tempMtx = imread([orig_path frame_list{frameNum}]);
        tempIdx = logical(vidMask(:,:,frameNum)); tempMtx(tempIdx) = tempMtx(tempIdx) + 150;
        writeVideo(vidObj,tempMtx);  
    end; close(vidObj); 
end;

%% Nested functions.

    function initVid;
        vidObj = VideoWriter(vidName,'Uncompressed AVI'); 
        vidObj.FrameRate = frame_rate; open(vidObj);
    end
    
end