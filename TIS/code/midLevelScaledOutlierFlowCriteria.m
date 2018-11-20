function [ seg ] = midLevelScaledOutlierFlowCriteria( seg )
% Calculate scaled outliers of flow criteria.

fprintf('Computing scaled outliers for flow criteria.\n');

seg.param.outlierScaleMin = 0.5;

% Miscellaneous video data.
nPxls = seg.cur.vid_size(1)*seg.cur.vid_size(2);

% Initialize varibles.
seg.cur.flowCritScaledOutliers = zeros(seg.cur.vid_size);
seg.cur.flowCritxScale = zeros(seg.cur.vid_size(3),1);
seg.cur.flowCrityScale = zeros(seg.cur.vid_size(3),1);
seg.cur.flowCritMagScale = zeros(seg.cur.vid_size(3),1);
seg.cur.flowCritAngScale = zeros(seg.cur.vid_size(3),1);
seg.cur.flowCritScaledOutScale = zeros(seg.cur.vid_size(3),1);

% Apply frame to frame mean normalization to median deviations for output.
seg.cur.flowCrit_x = zeros(seg.cur.vid_size);
seg.cur.flowCrit_y = zeros(seg.cur.vid_size);
seg.cur.flowCrit_mag = zeros(seg.cur.vid_size);
seg.cur.flowCrit_ang = zeros(seg.cur.vid_size);
for i = 1:seg.cur.vid_size(3);
    seg.cur.flowCrit_x(:,:,i) = abs(seg.cur.flow_x_medDev(:,:,i));
    seg.cur.flowCrit_y(:,:,i) = abs(seg.cur.flow_y_medDev(:,:,i));
    seg.cur.flowCrit_mag(:,:,i) = abs(seg.cur.flow_mag_medDev(:,:,i)); 
    a = seg.cur.flowCrit_mag(:,:,i);
    seg.cur.flowCrit_ang(:,:,i) = abs(seg.cur.flow_ang_medDev(:,:,i)) ...
        * (max(a(:))/180);
end

% Calculate scaled outliers of each flow criteria component frame by frame.
for i = 1:seg.cur.vid_size(3);
    
    seg.cur.flowCritxScale(i) = seg.cur.x{i}.outScale ...
        *(seg.cur.x{i}.outScale>seg.param.outlierScaleMin);
    seg.cur.flowCrityScale(i) = seg.cur.y{i}.outScale ...
        *(seg.cur.y{i}.outScale>seg.param.outlierScaleMin);
    seg.cur.flowCritAngScale(i) = seg.cur.ang{i}.outScale ...
        *(seg.cur.ang{i}.outScale>seg.param.outlierScaleMin);
    seg.cur.flowCritMagScale(i) = seg.cur.mag{i}.outScale ...
        *(seg.cur.mag{i}.outScale>seg.param.outlierScaleMin);
    
    idxOffSet = nPxls * (i-1);
    
    a = seg.cur.x{i}.outIdx + idxOffSet;
    seg.cur.flowCritScaledOutliers(a) = ...
        seg.cur.flowCritScaledOutliers(a) + ...
        seg.cur.flowCrit_x(a) * seg.cur.flowCritxScale(i);
    
    a = seg.cur.y{i}.outIdx + idxOffSet;
    seg.cur.flowCritScaledOutliers(a) = ...
        seg.cur.flowCritScaledOutliers(a) + ...
        seg.cur.flowCrit_y(a) * seg.cur.flowCrityScale(i);
    
    a = seg.cur.ang{i}.outIdx + idxOffSet;
    seg.cur.flowCritScaledOutliers(a) = ...
        seg.cur.flowCritScaledOutliers(a) + ...
        seg.cur.flowCrit_ang(a) * seg.cur.flowCritAngScale(i);
    
    a = seg.cur.mag{i}.outIdx + idxOffSet;
    seg.cur.flowCritScaledOutliers(a) = ...
        seg.cur.flowCritScaledOutliers(a) + ...
        seg.cur.flowCrit_mag(a) * seg.cur.flowCritMagScale(i);
end

end