function segOutJaccardIndex(resultDir, maskDir, seg)
% Calculate Jaccard index for foreground segmentation.

% Calculate Jaccard index for each frame and print mean result.
[~, ~, ~, result_frame_list] = imageFolderInfo(resultDir);
[~, ~, I_f, mask_frame_list] = imageFolderInfo(maskDir);
JmeanInd = zeros(1,I_f);
for i=1:I_f
    evalMask = logical(imread([resultDir result_frame_list{i}]));
    GTMask = logical(imread([maskDir mask_frame_list{i}]));
    GTMask = GTMask(:,:,1);
    % Intersection between all sets
    inters = evalMask.*GTMask;
    fp     = evalMask.*(1-inters);
    fn     = GTMask.*(1-inters);
    % Areas of the intersections
    inters = sum(inters(:)); % Intersection
    fpInd  = sum(fp(:)); % False positives
    fnInd  = sum(fn(:)); % False negatives
    % Compute the fraction
    denom = inters + fpInd + fnInd;
    if denom==0; J = 1;
    else; J =  inters/denom; end
    JmeanInd(i) = J;
end
Jmean = mean(JmeanInd);
fprintf('Jaccard index with ground truth is %g\n',Jmean);

if nargin > 2
fileName = [seg.path.trial 'JaccardResult_' date '.txt'];
fileID = fopen(fileName,'a');
fprintf(fileID,sprintf('Jaccard index with ground truth for %s is %g\n',seg.cur.video,Jmean));
fclose(fileID);
end

end