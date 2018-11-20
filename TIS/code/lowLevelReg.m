function [ reg, seg ] = lowLevelReg( seg )
% Calculate initial region data from original RGB and LAB color space.

fprintf('Computing LAB color space for video.\n');

% RGB color space.
[~, ~, ~, frame_list] = imageFolderInfo(seg.cur.video_path);
origVid = zeros([seg.cur.vid_size 3]);
for frameNum=1:seg.cur.vid_size(3);
    origVid(:,:,frameNum,:) = imread(sprintf('%s%s',...
        seg.cur.video_path,frame_list{frameNum}));
end;
% LAB color space.
labVid = rgb2lab(permute(origVid,[1 2 4 3]));
reg.labVid = normalizeVideo(permute(labVid,[1 2 4 3]));

    function vid = normalizeVideo( vid )
        % Normalize between 0 and 1.
        oneTemp = vid(:,:,:,1); oneMin = min(oneTemp(:)); oneRng = range(oneTemp(:));
        twoTemp = vid(:,:,:,2); twoMin = min(twoTemp(:)); twoRng = range(twoTemp(:));
        thrTemp = vid(:,:,:,3); thrMin = min(thrTemp(:)); thrRng = range(thrTemp(:));
        vid(:,:,:,1) = (oneTemp - oneMin)/oneRng;
        vid(:,:,:,2) = (twoTemp - twoMin)/twoRng;
        vid(:,:,:,3) = (thrTemp - thrMin)/thrRng;
    end

end