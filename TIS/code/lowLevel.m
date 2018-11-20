function [ seg ] = lowLevel( seg )
% Process low-level features of video.

% Miscellaneous initialization.
seg.cur.video = seg.path.data_list{seg.cur.data_i};
seg.cur.video_path = [seg.path.origIm_in seg.cur.video '/'];
[a, b, c] = imageFolderInfo(seg.cur.video_path);
seg.cur.vid_size = [a, b, c];
seg.cur.HIENum = seg.path.svx_hier;

seg.param.WOk = 1.5;

% Calculate low-level foreground criteria for entire video.
[seg] = lowLevelfgCrit( seg ); 

if seg.svx;
% Obtain low-level supervoxel region data for entire video.
[ reg, seg ] = lowLevelReg( seg );
seg = lowLevelImg2SV( seg );
seg = lowLevelSVXRegion( seg, reg );
end

end