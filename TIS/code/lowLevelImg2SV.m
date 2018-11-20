function [ seg ] = lowLevelImg2SV( seg )
% Calculate SVX map given directory of SVX images.

% Find current directory for specific video.
SVX_dir = dir(seg.path.svx_in);
isub = [SVX_dir(:).isdir];
names_SVXVid = {SVX_dir(isub).name}';
names_SVXVid(ismember(names_SVXVid,{'.','..'})) = [];
SVX_cur_dir = [seg.path.svx_in char(seg.cur.video) '/' seg.path.svx_hier '/'];
% Find list of images given specific video and hierarchy information.
SVX_hier_cur_dir = dir(SVX_cur_dir);
isub = [SVX_hier_cur_dir(:).isdir];
names_SVXImage = {SVX_hier_cur_dir(~isub).name}';
% Create SVX map and ID's.
num_frames = length(names_SVXImage);
size_frame = size(imread([SVX_cur_dir char(names_SVXImage(1))]));
imCur = uint8(zeros([size_frame num_frames]));
for i=1:num_frames
    imCur(:,:,:,i) = imread([SVX_cur_dir char(names_SVXImage(i))]);
end
imCur = uint32(imCur);
SVX_map_large = uint32(zeros([size_frame(1:2) num_frames]));
% shift 8: 1->256, shift 16: 1->65536
SVX_map_large(:,:,:) = imCur(:,:,1,:) + bitshift(imCur(:,:,2,:),8) + bitshift(imCur(:,:,3,:),16); 
% Rescale SVX map.
SVX_map = uint32(zeros(seg.cur.vid_size));
for i=1:num_frames
    SVX_map(:,:,i) = imresize(SVX_map_large(:,:,i),seg.cur.vid_size(1:2),'nearest');
end
seg.cur.svMapVid = SVX_map;
