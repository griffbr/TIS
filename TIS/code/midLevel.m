function [ seg ] = midLevel( seg )
% Calculate mid-level data for primary segmentation algorithm.

% Motion and visual saliency outliers.
seg = midLevelScaledOutlierFlowCriteria( seg );
seg = midLevelVisualSaliencyCriteria( seg );

% Final output criteria for foreground segmentation.
seg.cur.fgSegCrit = seg.cur.flowCritScaledOutliers ...
    + seg.cur.visSalFlowCrit ...
    + seg.cur.visSalNRootCrit ...
    + seg.cur.visSalRootCrit;

% Normalize foreground criteria to be in [0,1].
[seg.cur.fgSegCrit, ~] = maxScale(seg.cur.fgSegCrit);

%% Nested functions
    
    function [ dataMtx, scale ] = maxScale (dataMtx)
        scale = 1/max(max(dataMtx));
        scale(scale == inf) = 0;
        vidLength = size(dataMtx,3);
        for k = 1:vidLength;
            dataMtx(:,:,k) = dataMtx(:,:,k) * scale(k);
        end
    end

end