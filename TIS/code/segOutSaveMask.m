function segOutSaveMask(seg)
% Save foreground segmentation mask as png's in specified folder.

output_path = [seg.path.mask_out seg.cur.video];

% Write images.
if exist(output_path,'dir')~=7; mkdir(output_path); end
for i=1:seg.cur.vid_size(3)
    imwrite(seg.cur.fgMask(:,:,i), sprintf('%s/%05i.png',output_path,i-1));
end;