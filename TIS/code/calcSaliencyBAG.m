function calcSaliencyBAG(inputLocation,outputDir,extSaliencyPath,startIdx)
% Modified to handle additional types of images.
% Brent Griffin

if (~exist('startIdx','var'))
    startIdx=1;
end

if (~isdir(outputDir) || ~exist(outputDir,'dir'))
    error('outputDir is not a directory or does not exist');
end
if (isdir(inputLocation))
    fileList=dir([inputLocation '/*.png']);
    fileList= [fileList; dir([inputLocation '/*.jpg'])];
    fileList= [fileList; dir([inputLocation '/*.ppm'])];
    IN_DIR=inputLocation;
    NumOfFiles=size(fileList,1);
else
    [IN_DIR,base_name,ext] = fileparts(inputLocation);
    fileList.name = [base_name ext];
    NumOfFiles=1;
end

fprintf('Visual Saliency (%g total):',NumOfFiles);
for imIndx=startIdx:NumOfFiles
    [~,base_name,ext] = fileparts(fileList(imIndx).name);
    frameCurrent = imread([IN_DIR '/' base_name ext]);
    if (size(frameCurrent,3)==1)
        fprintf('\nNote: Grayscale image treated as colored\n');
        frameCurrent=repmat(frameCurrent,[1 1 3]);
    end
    strng = sprintf('%i.',imIndx);
    fprintf(strng);
    
    frameSaliencyMap  = PCA_SaliencyBAG(frameCurrent,extSaliencyPath);

    imwrite(frameSaliencyMap, [outputDir '/' base_name '.png'],'png');
end; fprintf('\n');
end