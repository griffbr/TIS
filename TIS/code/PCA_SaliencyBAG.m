function result = PCA_SaliencyBAG(I_RGB,extSaliencyPath)
% Modified to handle different path location.
% Brent Griffin

if (~exist('vl_slic.m','file'))
    fprintf('\nConfiguring vl_slic & IM2COLSTEP\n');
    bindir = mexext;
    if (~strcmp(mexext,'mexw64'))
        fprintf('Note: You are not using Windows 64 bit: Fast im2colstep diabled\n');
    end;
    if strcmp(bindir, 'dll'), bindir = 'mexw32' ; end
    addpath(fullfile(extSaliencyPath,'EXT','vl_slic')) ;
    addpath(fullfile(extSaliencyPath,'EXT','vl_slic',bindir)) ;
    addpath(fullfile(extSaliencyPath,'EXT','IM2COLSTEP')) ;
end


result = PCA_Saliency_Core(I_RGB);
end