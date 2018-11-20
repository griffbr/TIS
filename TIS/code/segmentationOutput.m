function segmentationOutput(seg)
% Save output mask and video.

% Make sure to output supervoxel gerrymandering-based mask if applicable.
if seg.svx; seg.cur.fgMask = seg.cur.SVXCon_fgMask; end

% Save output mask.
segOutSaveMask(seg);

% Evaluate mask against ground truth.
if seg.GT
    resultDir = [seg.path.mask_out seg.cur.video '/'];
    maskDir = [seg.path.groundTruth seg.cur.video '/'];
    segOutJaccardIndex(resultDir, maskDir, seg);
end

% Save output video
if seg.makeVideo;
   segOutAvi(seg); 
end