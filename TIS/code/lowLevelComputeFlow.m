function [ flow ] = lowLevelComputeFlow( seg )
% Calculate optical flow by calling Ce Liu's code.

saveFlow_path = [seg.path.trial 'flowData/'];

if exist([saveFlow_path seg.cur.video '_flow.mat']);
    % Load processed flow data if available.
    load([saveFlow_path seg.cur.video '_flow.mat'],'flow');
else;
    % Calculate optical flow.
    addpath(genpath('./external/OpticalFlow/'));
    % Set optical flow parameters.
    alpha = 0.012;
    ratio = 0.75;
    minWidth = 20;
    nOuterFPIterations = 7;
    nInnerFPIterations = 1;
    nSORIterations = 30;
    para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];
    % Convert images.
    fprintf('Starting optical flow calculation for %s.',seg.cur.video);
    video_path = sprintf('%s%s/',seg.path.origIm_in,seg.cur.video);
    [I_h, I_w, I_f, frame_list] = imageFolderInfo(video_path);
    flow = zeros(I_h,I_w,2,length(frame_list));
    fprintf('Optical flow (%g total):',I_f-1);
    for i=1:I_f-1
        im1 = im2double(imread(fullfile(video_path,frame_list{i})));
        im2 = im2double(imread(fullfile(video_path,frame_list{i+1})));
        [flow(:,:,1,i), flow(:,:,2,i), ~] = Coarse2FineTwoFrames(im1, im2, para);
        fprintf('%g.',i);
    end; fprintf('\n');
    flow(:,:,:,end) = flow(:,:,:,end-1);
    flow = permute(flow,[1 2 4 3]);
    % Save data.
    if seg.saveData;
        if exist(saveFlow_path,'dir')~=7; mkdir(saveFlow_path); end
        save([seg.path.trial 'flowData/' seg.cur.video '_flow.mat'],'flow');
    end
end
end