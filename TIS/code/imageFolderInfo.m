function [ I_h, I_w, I_f, frame_list ] = imageFolderInfo( input_path_subdir )
% Returns information on an image directory.

% Collect images.
input_dir = dir(input_path_subdir);
frame = 0; frame_list = [];
for i=1:length(input_dir)
    if ~isempty(strfind(input_dir(i,1).name, '.png')) || ...
            ~isempty(strfind(input_dir(i,1).name, '.ppm')) || ...
            ~isempty(strfind(input_dir(i,1).name, '.bmp')) || ...
            ~isempty(strfind(input_dir(i,1).name, '.jpg'))
        frame = frame + 1;
        frame_list{frame,1} = input_dir(i,1).name;
    end
end

if ~isempty(frame_list)
    first_frame = imread(fullfile(input_path_subdir,frame_list{1}));
    [I_h, I_w, ~] = size(first_frame);
else
    disp('No frames (png, ppm, bmp, jpg) in the folder!');
end

I_f = length(frame_list);

end

