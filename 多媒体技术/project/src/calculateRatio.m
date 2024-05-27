function [ratio, sourceimageSize, savedimageSize] = calculateRatio(sourceimagePath, savedimagePath)
    source_file_info = dir(sourceimagePath);
    sourceimageSize = source_file_info.bytes; 
    disp(['source image size = ' num2str(sourceimageSize) ' B']);
    saved_file_info = dir(savedimagePath);
    savedimageSize = saved_file_info.bytes; 
    disp(['saved image size = ' num2str(savedimageSize) ' B']);
    ratio = 1.0 * sourceimageSize / savedimageSize;
end

