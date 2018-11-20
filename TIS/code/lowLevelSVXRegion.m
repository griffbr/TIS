function [ seg ] = lowLevelSVXRegion( seg, reg )
% Calculate supervoxel region data prior to primary algorithm.

if exist([seg.path.trial 'SVXRegionData/' seg.cur.video '_' seg.path.svx_hier '_SVXRegion.mat']);
    % Load supervoxel region data if it is available.
    load([seg.path.trial 'SVXRegionData/' seg.cur.video '_' seg.path.svx_hier '_SVXRegion.mat'],'svLAB','svLocIdx','svNum');
else;
    fprintf('Calculating video-wide supervoxel regions.\n');
    
    % Miscellaneous video data.
    nPxls = seg.cur.vid_size(1)*seg.cur.vid_size(2)*seg.cur.vid_size(3);
    two_nPxls = 2*nPxls;
    % Initialize variables.
    svIds = unique(seg.cur.svMapVid); svNum = length(svIds);
    svLocIdx = {}; svLAB = zeros(svNum,3);
    % Find region and criteria information for all sv.
    fprintf('SVX (%g total): ',svNum);
    modNum = round(svNum/20);
    for i=1:svNum;
        if mod(i,modNum)==0; fprintf('%g.',i); end;
        % Find sv indexed values.
        svLocIdx{i} = find(seg.cur.svMapVid == svIds(i));
        % Find mean supervoxel LAB values as region coordinates.
        lab_l = reg.labVid(svLocIdx{i});
        lab_a = reg.labVid(svLocIdx{i} + nPxls);
        lab_b = reg.labVid(svLocIdx{i} + two_nPxls);
        ylab_l = mean(lab_l); ylab_a = mean(lab_a); ylab_b = mean(lab_b);
        svLAB(i,:) = [ylab_l ylab_a ylab_b];
    end; fprintf('\n');
    % Region sv coordinate (use non-weighted region scale).
    seg.cur.svRegion = svLAB;
    
    % Save supervoxel region data.
    if seg.saveData;
    if exist([seg.path.trial 'SVXRegionData/'],'dir')~=7; mkdir([seg.path.trial 'SVXRegionData/']); end
    save([seg.path.trial 'SVXRegionData/' seg.cur.video '_' seg.path.svx_hier '_SVXRegion.mat'],...
        'svLAB','svLocIdx','svNum');
    end
end;
seg.cur.svRegion = svLAB; seg.cur.svLocIdx = svLocIdx; seg.cur.svNum = svNum;
end