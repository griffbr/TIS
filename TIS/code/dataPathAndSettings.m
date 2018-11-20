function [ seg ] = dataPathAndSettings( demo_input )

% Set up data paths and directory information for segmentation.
seg.path.trial = demo_input.trial;
seg.path.origIm_in = demo_input.image;
seg.path.mask_out = demo_input.annotation;
seg.path.groundTruth = demo_input.groundTruth;
% Supervoxel paths.
seg.path.svx_in = demo_input.supervoxel;
seg.path.svx_hier = demo_input.SVXHierarchyLevel;
% Collect folder information for entire image directory:
input_dir = dir(seg.path.origIm_in);
isub = [input_dir(:).isdir];
nameFolds = {input_dir(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
seg.path.data_list = nameFolds;

% Switch for MSVO and ground truth annotation.
switch demo_input.supervoxel;
    case 'TIS0'
        seg.svx = 0;
    otherwise
        seg.svx = 1;
end
switch demo_input.groundTruth
    case 'None';
        seg.GT = 0;
    otherwise
        seg.GT = 1;
end

% Other settings.
seg.saveData = demo_input.saveProcessData;
seg.SVXConsensus = demo_input.SVXConsensus;
seg.makeVideo = demo_input.saveSegmentationVideo;