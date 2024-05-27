function YCbCr_image = RGB2YCBCR(RGB_image)
    % 定义转换矩阵和偏移量
    origT = [65.481 128.553 24.966;
             -37.797 -74.203 112;
             112 -93.786 -18.214];
    origOffset = [16; 128; 128];
    
    % 将 RGB 图像转换为 double 类型
    RGB_double = double(RGB_image);
    
    % 将 RGB 图像重新映射到 [0, 1] 范围
    RGB_double = RGB_double / 255.0;
    
    % 将 RGB 图像重塑为行向量
    RGB_vector = reshape(RGB_double, [], 3)';
    
    % 进行色彩空间转换
    YCbCr_vector = origT * RGB_vector + origOffset;
    
    YCbCr_vector(1,:) = max(min(YCbCr_vector(1,:), 235), 16);
    YCbCr_vector(2:3,:) = max(min(YCbCr_vector(2:3,:), 240), 16);

    % 将 YCbCr 向量重新映射回 uint8 范围
    YCbCr_vector = round(YCbCr_vector);
    YCbCr_vector = max(min(YCbCr_vector, 255), 0); % 确保值在 [0, 255] 范围内
    
    % 将转换后的 YCbCr 向量重新排列为图像形状
    YCbCr_image = uint8(reshape(YCbCr_vector', size(RGB_image)));
end

