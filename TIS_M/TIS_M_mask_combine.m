%% Script for combining output mask using Tukey-Inspired Saliency
% Questions? griffb@umich.edu
% 181120

% Misc. initialization.
k_tukey = 1.5;
fig_show = 0;
even_total = 0;
fg_combine_thresh = 0.5;

% Determine output mask trajectory.
% mask_out = 'comb_medfgNum_origNoLearn_k15_thrsh05_9n'
% mask_out = 'comb_medfgNum_orig_k15_thrsh05_8n'

% UV
mask_list = {'nlc','fst','TIS0','SWA06','msg','key','cvos','trc'};
mask_out = 'TIS_M';

% Determine list of input masks.
mask_dir = '/Users/griffb/Dropbox/code/fgbgSeg/1803_ECCV/DAVIS/Results/Segmentations/480p/';
mask_dir = '/Users/griffb/Dropbox/git/GrCoWACV2019_media/DAVIS/Results/Segmentations/480p/';
% mask_list = {'arp', 'nlc', 'fst', 'key'}
% mask_list = {'arp', 'nlc', 'fst'}
% mask_list = {'arp', 'nlc', 'fst', 'key','TIS','SWA06'}
% mask_list = {'arp', 'nlc', 'fst', 'TIS','SWA06'}
% mask_list = {'arp', 'nlc', 'fst', 'TIS','SWA06','fseg','lmp','msg','key','cvos','trc'}
% mask_list = {'TIS'}
% mask_list = {'arp', 'nlc', 'fst', 'TIS','SWA06','fseg','lmp','msg','key','cvos','trc'}
% mask_list = {'nlc', 'fst', 'TIS0','SWA06','msg','key','cvos','trc'}


% Supervised list. (one-shot, annotation provided on first frame)
% mask_list = {'onavos','osvos','msk','sfls','ctn','vpn','plm','bvs','fcp','jmp','hvs','sea'}
% mask_list = {'onavos','osvos','msk','sfls','ctn','vpn'} % 6 n, 85 J, 83 F
% mask_list = {'onavos','osvos','msk','sfls','ctn','vpn','plm','bvs','fcp','jmp','hvs','sea'} % 84 J, 81 F
% mask_list = {'onavos','osvos','msk'} % 3n, 85J, 83F
% mask_list = {'onavos','osvos','msk','sfls'} % 4n, 85.1J, 83.3F
% mask_list = {'onavos','osvos','msk','sfls','ctn'} % 5n, 85.6J, 83.3F
% mask_list = {'onavos','osvos','msk','sfls','ctn','vpn','plm'} % 7n, 85.1J, 82.5F
% mask_list = {'onavos','osvos','msk','sfls','ctn','arp','lvo'} % 7nS, 85.5J, 82.6F
% mask_list = {'onavos','osvos','msk','sfls','arp','lvo'} % 6nS, 85.7J, 83.3F
% mask_list = {'onavos','osvos','msk','sfls','lvo'} % 5nS2 85.4J, 83.4F
% mask_list = {'onavos','osvos','msk','sfls','arp'} % 5nS, 85.9J, 83.7F

% Original one-shot
% mask_list = {'msk','ctn','vpn','bvs','fcp','jmp','hvs','sea'} % 8 n, 79 J, 76 F
% mask_list = {'msk','ctn','vpn','bvs','fcp','jmp','hvs'} % 7 n, 81 J, 77 F
% mask_list = {'msk','ctn','vpn','bvs','fcp','jmp'} % 6 n, 81 J, 78 F
% mask_list = {'msk','ctn','vpn','bvs','fcp','jmp','hvs','sea','arp', 'nlc', 'fst', 'TIS0','SWA06','fseg','lmp','msg','key','cvos','trc'} % 83J, 78F
% mask_list = {'bvs','fcp','jmp','hvs','sea','nlc', 'fst', 'TIS0','SWA06','msg','key','cvos','trc'} % 13nR, 


% Original, no one-shot
% mask_list = {'arp', 'nlc', 'fst', 'TIS','SWA06','fseg','lmp','msg','key','cvos','trc'} % 11 n, 80 J, 74 F
% mask_list = {'arp', 'nlc', 'TIS','SWA06','fseg','lmp'} % 6 n, 80 J, 74 F
% mask_list = {'arp', 'nlc', 'TIS','SWA06','fseg','lmp', 'fst'} % 7 n, 80 J 74 F


% mask_list = {'arp', 'nlc', 'fst', 'TIS','SWA06','msg','key','cvos','trc'} % 9 n, 78 J, 72 F

% Need to redo validation set results.
mask_list = {'onavos','osvos','msk','sfls','arp'} % 5nS, 85.9J, 83.7F
mask_list = {'onavos','osvos','msk','sfls','arp','osvoss','cinm','osmn','pml','rgmp','favos'} % 11n_RTV 88.0J, 86.5F
mask_list = {'onavos','osvos','msk','sfls','arp','osvoss','cinm','pml','rgmp','favos'} % 10n_RTV 88.0, 86.3F
mask_list = {'onavos','osvos','msk','arp','osvoss','cinm','pml','rgmp','favos'} % 9n_RTV 88.3J, 86.7F
mask_list = {'onavos','osvos','msk','arp','osvoss','cinm','rgmp','favos'} % 8n_RTV 88.4J, 86.8F
mask_list = {'onavos','osvos','msk','osvoss','cinm','rgmp','favos'} % 7n_RTV 88.0J, 86.8F
mask_list = {'onavos','osvos','osvoss','cinm','rgmp','favos'} % 6n_RTV 87.9J, 87.2F
mask_list = {'onavos','osvoss','cinm','rgmp','favos'} % 5n_RTV 88.1 J, 87.5 F

mask_list = {'onavos','osvos','msk','sfls','arp','osvoss','cinm','osmn','pml','rgmp','favos','ctn','vpn','bvs','fcp','jmp','hvs','sea','pdb', 'nlc', 'fst', 'TIS0','SWA06','fseg','lmp','msg','key','cvos','trc'}
% 29n_RTV, 87.2F, 84.6F

mask_list = {'onavos','osvos','msk','sfls','arp','osvoss','cinm','osmn','pml','rgmp','favos','ctn','vpn','bvs','fcp','jmp','hvs','sea','pdb', 'nlc', 'fst', 'TIS0','SWA06','fseg','lmp','msg','key','cvos','trc','ofl'}
% 30n_RTV, 87.1F, 84.4F

%% WACV results

% RTV
mask_list = {'onavos','osvos','msk','sflu','cut','lvo','sfls','arp','osvoss','cinm','osmn','pml','rgmp','favos','ctn','vpn','bvs','fcp','jmp','hvs','sea','pdb', 'nlc', 'plm','fst', 'TIS0','SWA06','fseg','lmp','msg','key','cvos','trc','ofl'}
% 34n_RTV, 86.7J, 83.8F
mask_out = 'comb_medfgNum_orig_k15_thrsh05_34n_RTV'


% RT
mask_list = {'ofl','msk','ctn','vpn','bvs','fcp','jmp','hvs','sea','arp', 'nlc', 'fst', 'TIS0','SWA06','fseg','lmp','msg','key','cvos','trc'}
mask_out = 'comb_medfgNum_orig_k15_thrsh05_20n_RT'
% 20n_RT, 83.3J, 78.5F



% RV
mask_list = {'cut','nlc','fst','TIS0','SWA06','msg','key','cvos','trc','bvs','fcp','jmp','hvs','sea'}
mask_out = 'comb_medfgNum_orig_k15_thrsh05_14n_RV'
% 14n_RV, 76.5J, 71.2F

% TV
mask_list = {'pdb','arp','lvo','fseg','lmp','sflu','cut','nlc','fst','TIS0','SWA06','msg','key','cvos','trc'}
mask_out = 'comb_medfgNum_orig_k15_thrsh05_15n_TV'
% 15n_TV, 81.8J, 76.6F

% TV5
mask_list = {'pdb','arp','lvo','fseg','lmp'}
mask_out = 'Limited_5_TV'
% 

% UV5
mask_list = {'cut','fst','nlc','TIS0','SWA06'}
mask_out = 'Limited_5_UV'

% RV5
mask_list = {'bvs','fcp','jmp','hvs','sea'}
mask_out = 'Limited_5_RV'

% % RTV
% mask_list = {'TIS0_V_fig','onavos','osvos','msk','sflu','cut','lvo','sfls','arp','osvoss','cinm','osmn','pml','rgmp','favos','ctn','vpn','bvs','fcp','jmp','hvs','sea','pdb', 'nlc', 'plm','fst', 'SWA06','fseg','lmp','msg','key','cvos','trc','ofl'}
% % 34n_RTV, 86.7J, 83.8F
% mask_out = 'fig_34n_RTV'

mask_list = {'onavos','osvoss','cinm','rgmp','favos','nlc','msg','key','cvos','trc'}
mask_out = 'TISM_10_BEST_WORST'

mask_list = {'nlc','msg','key','cvos','trc'}
mask_out = 'TISM_5_WORST'

mask_list = {'onavos','osvoss','cinm','rgmp','favos','nlc','msg','key','cvos','trc'}
mask_out = 'TISM_10_BEST_WORST'

mask_list = {'onavos','osvoss','cinm','key','cvos','trc'}
mask_out = 'TISM_6_BEST_WORST'

mask_list = {'onavos','osvoss','cinm','rgmp','favos','cut','nlc','fst','TIS0','SWA06','msg','key','cvos','trc','bvs','fcp','jmp','hvs','sea'}
mask_out = 'TISM_5_BEST_14RV'

mask_list = {'onavos','osvoss','cinm','cut','nlc','fst','TIS0','SWA06','msg','key','cvos','trc','bvs','fcp','jmp','hvs','sea'}
mask_out = 'TISM_3_BEST_14RV'

mask_n = length(mask_list)
% gt_set = 'trainval';
gt_set = 'val';

% Determine number of videos.
if strcmp(gt_set,'trainval')
tmp = dir([mask_dir mask_list{1}]);
vid_list = {tmp.name};
vid_list(~[tmp.isdir]) = [];
vid_list(strcmp(vid_list,'.')) = [];
vid_list(strcmp(vid_list,'..')) = [];
else
    vid_list = {'blackswan',
    'bmx-trees',
    'breakdance',
    'camel',
    'car-roundabout',
    'car-shadow',
    'cows',
    'dance-twirl',
    'dog',
    'drift-chicane',
    'drift-straight',
    'goat',
    'horsejump-high',
    'kite-surf',
    'libby',
    'motocross-jump',
    'paragliding-launch',
    'parkour',
    'scooter-black',
    'soapbox'};
end

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
%         mask_fg_scale = mask_fg_scale.^2;
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
        display 'test'
%         truesize
        pause(0.01)
    end
end

% Evaluate new mask Mean J and F.
[ eval ] = demo_eval_your_method_function( mask_out, mask_dir, gt_set )

% Write results to file.
out_file = ['results_WACV.txt'];
f = fopen(out_file,'a');
fprintf(f,'\n=========================\n');
fprintf(f,[' mask_out: ' mask_out '\n Mask components: ']);
for k=1:mask_n; fprintf(f,' %s',mask_list{k}); end
fprintf(f,['\n Even total: ' num2str(even_total)]);
fprintf(f,['\n Combine threshold: ' num2str(fg_combine_thresh)]);
fprintf(f,['\n Tukey number: ' num2str(k_tukey)]);
fprintf(f,['\n Mean J: ' num2str(mean(eval.J.mean))]);
fprintf(f,['\n Mean F: ' num2str(mean(eval.F.mean))]);
fprintf(f,'\n=========================\n\n');
fclose(f);




if 0
    %% Temp code for display in paper
    fprintf('/n/n/ntesting!!!!!!!!! making test output figures/n/n/n');
    figure(1);
    h = 2; w = 1;
    x0=10;
    y0=10;
    width=854;
    height=480;
    linewidth = 3;
    maize = [255 203 5]./255; blue = [0 39 76]./255;
    
    if 1
        image_path = ['/Users/griffb/Dropbox/git/GrCoWACV2019_media/DAVIS/JPEGImages/480p/' vid_list{i} '/00047.jpg']
        tempMtx = imread(image_path);
        tempIdx = logical(mask_combine);
        tempMtx(tempIdx) = tempMtx(tempIdx) + 150;
        imwrite(tempMtx,['segImage.png'])
    end
    

        
        figure(2);
%         subplot(h,w,3); cla; hold on;
        a = mask_fg_total;
%         ylim = [0 50000]
        bin_width = 2000
        histogram(a(:),'FaceColor',maize,'BinWidth',bin_width); hold on;
        plot([Q(1) Q(1)],ylim,'-','linewidth',linewidth,'Color', blue); 
        plot([Q(3) Q(3)],ylim,'-','linewidth',linewidth,'Color', blue);
%         plot([0 0],ylim,'-','linewidth',linewidth,'Color', blue);
        plot([O1 O1],ylim,'--','linewidth',linewidth,'Color', blue);
        plot([O3 O3],ylim,'--','linewidth',linewidth,'Color', blue);
        histogram(a(:),'FaceColor',maize,'BinWidth',bin_width);
%         xlim([-20 20])
        set(gca,'YTickLabel',[]);
%         set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        hold off;
%         title(sprintf('\alpha = %.2g',seg.cur.mag{fr}.outScale));
        set(gcf,'units','points','position',[x0,y0,width,height])
        set(gca,'FontSize',22)
        set(gca,'fontname','times')
        
        if 1
    name = 'test'
            print([name '_hist'],'-dpdf','-bestfit')
        end
%         figure('rend','painters','pos',[10 10 900 600])
end