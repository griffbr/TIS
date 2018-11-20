function [ seg ] = foregroundSeg( seg )
% Calculate mask for foreground segmentation.
fprintf('Computing initial foreground / background segmentation (TISO).\n');

% Initialize miscellaneous variables.
seg.cur.fgMask = false(seg.cur.vid_size); 
seg.cur.critThresh = zeros(seg.cur.vid_size(3),1);

for i=1:seg.cur.vid_size(3);
    % Find initial foreground mask estimate based on mean and standard deviation.
    fgMask = false(seg.cur.vid_size(1:2));
    c = seg.cur.fgSegCrit(:,:,i); d = std(c(:));
    thresh = mean(c(:)) + d;
    % Apply 0.5 threshold discount at mask position of previous frame.
    prevMaskBoost = zeros(seg.cur.vid_size(1:2));
    if i>1
        a = find(seg.cur.fgMask(:,:,i-1));
        prevMaskBoost(a) = 0.5*thresh;
    end
    fgMask(seg.cur.fgSegCrit(:,:,i) + prevMaskBoost > thresh) = true;
    
    % Filter mask using single object hypothesis assumption.
    nClust = 1; maskMtx = fgMask;
    costMtx = seg.cur.fgSegCrit(:,:,i);
    % Find connected objects and sort them by value.
    CC = bwconncomp(maskMtx);
    if CC.NumObjects>nClust;
        clusterValue = zeros(CC.NumObjects,1);
        for j = 1:CC.NumObjects
            clusterValue(j) = sum(costMtx(CC.PixelIdxList{j}));
        end
        sortedClusterCosts = sort(clusterValue);
        expensiveSegCCIdx = find( clusterValue < sortedClusterCosts(end-nClust+1) );
        for j = 1:length(expensiveSegCCIdx);
            maskMtx(CC.PixelIdxList{expensiveSegCCIdx(j)}) = false;
        end
    end
    fgMask = maskMtx; seg.cur.fgMask(:,:,i) = fgMask;
end

if seg.svx;
    % Normalize MSVO output to be between [0,1].
    for i=1:seg.cur.vid_size(3);
        a = seg.cur.fgSegCrit(:,:,i);
        seg.cur.fgSegCrit(:,:,i) = seg.cur.fgSegCrit(:,:,i) ./ max(a(:)); end
    % Run supervoxel-based gerrymandering from TIS0 output.
    seg = fgSegSVXConsensus( seg );
end