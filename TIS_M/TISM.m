function TISM( mask_out, mask_list, mask_dir, fig_show )
% Function for combining output masks using Tukey-Inspired Saliency (TISM).
% Questions? griffb@umich.edu
% 181120

% Misc. initialization.
k_tukey = 1.5;
even_total = 0;
fg_combine_thresh = 0.5;
mask_n = length(mask_list);

% Determine number of videos.
tmp = dir([mask_dir mask_list{1}]);
vid_list = {tmp.name};
vid_list(~[tmp.isdir]) = [];
vid_list(strcmp(vid_list,'.')) = [];
vid_list(strcmp(vid_list,'..')) = [];

% Misc.
output_dir = [mask_dir mask_out];
mask_fg_total = zeros(1,mask_n);
mask_fg_scale = zeros(1,mask_n);
hw_fig = ceil((mask_n+1)^0.5);

% For each video:
for i=1:length(vid_list)
    fprintf('\n%s.',vid_list{i})
    % Determine number of frames.
    tmp = dir([mask_dir mask_list{1} '/' vid_list{i}]);
    frame_list = {tmp.name};
    frame_list(strcmp(frame_list,'.')) = [];
    frame_list(strcmp(frame_list,'..')) = [];
    % Build output directory.
    out_vid_dir = [output_dir '/' vid_list{i}];
    if exist(out_vid_dir,'dir')~=7
        mkdir(out_vid_dir);
    end
    % For each frame:
    for j=1:length(frame_list)-1
        % Find the number of pixels in each mask.
        for k=1:mask_n
            tmp_im = imread([mask_dir mask_list{k} '/' vid_list{i} '/' frame_list{j}]);
            mask_fg_total(k) = sum(tmp_im(:)>0);
        end
        % Find median and outlier threshold based on total fg points.
        Q = quantile(mask_fg_total,[0.25 0.5 0.75]);
        IQR = Q(3)-Q(2);
        O1 = Q(1) - k_tukey * IQR;
        O3 = Q(3) + k_tukey * IQR;
        % Find scale for each mask, normalize scale.
        for k=1:mask_n
            if mask_fg_total(k)>Q(2)
                mask_fg_scale(k) = max(0, (mask_fg_total(k) - O3) / (Q(2)-O3) );
            else
                mask_fg_scale(k) = max(0, (mask_fg_total(k) - O1) / (Q(2)-O1) );
            end
        end
        if even_total
            mask_fg_scale(:) = 1; % For even total.
        end
        mask_fg_scale = mask_fg_scale / sum(mask_fg_scale);
        % Combine mask frame for each input mask.
        tmp_mask = zeros(480,854);
        for k=1:mask_n
            tmp_im = imread([mask_dir mask_list{k} '/' vid_list{i} '/' frame_list{j}]);
            tmp_idx = tmp_im>0;
            tmp_mask(tmp_idx) = tmp_mask(tmp_idx) + mask_fg_scale(k);
        end
        mask_combine = zeros(480,854,'uint8');
        mask_combine(tmp_mask>=fg_combine_thresh)=255;
        % Write the resulting mask to the output directory.
        imwrite(mask_combine, [out_vid_dir '/' frame_list{j}])
        fprintf('.')
    end
    
    % Show mask combination (optional).
    if fig_show
        figure(i)
        subplot(hw_fig,hw_fig,1); imshow(mask_combine); title(sprintf('[%g,%g,%g] pixels',Q));
        for k=1:mask_n
            subplot(hw_fig,hw_fig,k+1); imshow(imread([mask_dir mask_list{k} '/' vid_list{i} '/' frame_list{j}]))
            title(sprintf('%0.2g scale %s %g pixels',mask_fg_scale(k),mask_list{k},mask_fg_total(k)));
        end
        pause(0.01)
    end
end


end

