%% Demo Configuration
 
% Paths
demo_input.trial = './exampleDirectory/'; % Path for trial input and output data.
demo_input.image = [demo_input.trial 'image/']; % Path for input images.
demo_input.annotation = [demo_input.trial 'outputAnnotation/']; % Path for output annotation.
demo_input.groundTruth = [demo_input.trial 'groundTruth/']; % Path for ground truth annotations.
demo_input.supervoxel = [demo_input.trial 'supervoxel_SWA/']; % Path for pre-processed supervoxels (can use LIBSVX or equivalent).

% Algorithm Settings
demo_input.SVXHierarchyLevel = '06';
demo_input.SVXConsensus = 'Both'; % Options: 'Both', 'LC' (local consensus only), and 'NLC' (non-local consensus only).
% Uncomment 1) or 2) if:
% demo_input.groundTruth = 'None'; % 1) no ground truth annotations are available.
% demo_input.supervoxel = 'TIS0'; % 2) TIS0 is desired algorithm.

% Save Settings (1 yes, 0 no)
demo_input.saveSegmentationVideo = 1; % Original video with output segmentation added.
demo_input.saveProcessData = 1; % Reduces redundant computation if testing different settings.

%% Run main algorithm.
TIS( demo_input );