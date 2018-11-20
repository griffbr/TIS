function [ seg ] = fgSegSVXConsensus( seg )
% Refine initial foreground estimate using supervoxel-based local and
% non-local consensus.
fprintf('Computing final foreground / background segmentation (supervoxel consensus).\n');

switch seg.SVXConsensus
    case 'Both'
% % Consensus both
seg.cur.localConScale = 0.5;
seg.param.nNN = ceil(seg.cur.svNum/100) + 1;
    case 'NLC'
% % Consensus NLC Only
seg.cur.localConScale = 0;
seg.param.nNN = ceil(seg.cur.svNum/100) + 1;
    case 'LC'
% Consensus LC Only
seg.cur.localConScale = 10^6;
seg.param.nNN = 1;
end

%% Calculate nearest neighbor weights for each supervoxel.
if seg.param.nNN > 1;
regionScale = [ ones(1,3)/3 ];
% Apply region weighting.
regionCoord = bsxfun(@times, seg.cur.svRegion, regionScale);
% Find nearest neighbor regions.
[ svNN, svRegionNNDist ] = knnsearch( regionCoord, ...
    regionCoord,'dist','cityblock','k',seg.param.nNN);
svRegionNNDist = svRegionNNDist.^2;
% NN criteria weight is inversely proportional to NN distance.
svRegionNNWeight = min(1./svRegionNNDist, 10^6);
% Self-neighbor weight is relative to all others:
svRegionNNWeight(:,1) = seg.cur.localConScale*sum(svRegionNNWeight(:,2:end)');
% Each row of NN scales should add up to one.
svRegionNNWeightSum = sum(svRegionNNWeight')';
svNNScale = bsxfun(@rdivide, svRegionNNWeight, svRegionNNWeightSum);
end
fprintf('Number of nearest neighbor supervoxels: %g / %g\n',seg.param.nNN,seg.cur.svNum);
if seg.param.nNN>4;
fprintf('svNNScale: %.3g, %.3g, %.3g, %.3g, %.3g, ...\n',mean(svNNScale(:,1:5)));
end

%% Find supervoxel consensus.
svfg = zeros(seg.cur.svNum,1);
seg.cur.SVXCon = zeros(seg.cur.vid_size);
% Find mean value of foreground (1) / background (-1) pixels in each sv.
SVXCon = zeros(seg.cur.vid_size);
SVXCon(seg.cur.fgMask) = 1;
SVXCon(~seg.cur.fgMask) = -1;
for i=1:seg.cur.svNum;
    a = SVXCon(seg.cur.svLocIdx{i});
    svfg(i) = mean(a(:));
end
% Find video-wide consensus from each individual supervoxel-based consensus.
if seg.param.nNN > 1;
    for i=1:seg.cur.svNum;
        seg.cur.SVXCon(seg.cur.svLocIdx{i}) = svNNScale(i,:)*svfg(svNN(i,:));
    end;
else; % Single SVX (local consensus only)
    for i=1:seg.cur.svNum;
        seg.cur.SVXCon(seg.cur.svLocIdx{i}) = svfg(i);
    end;
end;
% Final criteria for foreground segmentation includes the initial measure.
seg.cur.SVXCon_fgCrit = seg.cur.SVXCon + seg.cur.fgSegCrit;

%% Find final output segmentation mask given supervoxel consensus.
for i = 1:seg.cur.vid_size(3)
    % Threshold based foreground selection.
    fgMask = false(seg.cur.vid_size(1:2));
    fgMask(seg.cur.SVXCon_fgCrit(:,:,i) > 0) = true;
    seg.cur.SVXCon_fgMask(:,:,i) = fgMask;
    % Filter using two object hypothesis.
    nClust = 2;
    maskMtx = seg.cur.SVXCon_fgMask(:,:,i);
    costMtx = seg.cur.SVXCon_fgCrit(:,:,i);
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
    seg.cur.SVXCon_fgMask(:,:,i) = maskMtx;
end;

end