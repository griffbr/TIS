%% Demo configuration.

% Determine output mask name.
mask_out = 'TIS_M';

% Determine list of input masks.
mask_list = {'TIS_0','TIS_S','nlc','fst','msg','key','cvos','trc'};

% Misc. initialization.
fig_show = 0;
mask_dir = [pwd,'/seg_masks/'];

%% Run main algorithm.
TISM( mask_out, mask_list, mask_dir, fig_show )