function [y,cb,cr] = sampling(image_YCbCr)
    % 4:2:0
    [h,w,~] = size(image_YCbCr);
    % y分量不压缩
    y = double(image_YCbCr(:,:,1)); 
    % cb分量每个2×2小方块都取左上角
    cb = double(image_YCbCr(1:2:h-1,1:2:w-1,2)); 
    % cr分量每个2×2小方块都取左下角
    cr = double(image_YCbCr(2:2:h,2:2:w,3));     
end