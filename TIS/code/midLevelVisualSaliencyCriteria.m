function [ seg ] = midLevelVisualSaliencyCriteria( seg )
% Calculate visual saliency criteria.

% Calculate visual saliency.
saveSaliency_path = [seg.path.trial 'visualSaliency/' seg.cur.video];
if ~exist([saveSaliency_path])
    fprintf('Computing visual saliency.\n');
    addpath('./external/PCA_Saliency_CVPR2013');
    if exist(saveSaliency_path,'dir')~=7; mkdir(saveSaliency_path); end
    calcSaliencyBAG([seg.path.origIm_in seg.cur.video],saveSaliency_path,'./external/PCA_Saliency_CVPR2013');
end

fprintf('Computing visual saliency criteria.\n');

visSalVid = zeros(seg.cur.vid_size);
[~, ~, ~, frame_list] = imageFolderInfo(saveSaliency_path);
for i = 1:seg.cur.vid_size(3);
    visSalVid(:,:,i) = imread([saveSaliency_path '/' frame_list{i}]);
end

seg.param.root = 1/3;
seg.param.minVSFlowScale = 0.5;

% Miscellaneous video data.
nPxls = seg.cur.vid_size(1)*seg.cur.vid_size(2);

% Initialize varibles.
seg.cur.visSalFlowCrit = zeros(seg.cur.vid_size);
seg.cur.visSalRootCrit = zeros(seg.cur.vid_size);
seg.cur.visSalNRootCrit = zeros(seg.cur.vid_size);

visSalVidRoot = (visSalVid.^0.5)./(255^0.5);
visSalVidNRoot = (visSalVid.^seg.param.root)./(255^seg.param.root);

flowCrit = zeros(seg.cur.vid_size);
for i = 1:seg.cur.vid_size(3);
    flowCrit(:,:,i) = ...
          seg.cur.flowCrit_x(:,:,i) * max(seg.cur.x{i}.outScale,seg.param.minVSFlowScale) ...
        + seg.cur.flowCrit_y(:,:,i) * max(seg.cur.y{i}.outScale,seg.param.minVSFlowScale) ...
        + seg.cur.flowCrit_mag(:,:,i) * max(seg.cur.mag{i}.outScale,seg.param.minVSFlowScale) ...
        + seg.cur.flowCrit_ang(:,:,i) * max(seg.cur.ang{i}.outScale,seg.param.minVSFlowScale);
end

VSFlow = visSalVid.*flowCrit/255;
VSRootFlow = visSalVidRoot.*flowCrit;
VSNRootFlow = visSalVidNRoot.*flowCrit;

seg.cur.visSalFlowCrit = VSFlow;
seg.cur.visSalRootCrit = VSRootFlow;
seg.cur.visSalNRootCrit = VSNRootFlow;