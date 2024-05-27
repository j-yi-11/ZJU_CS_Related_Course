function RGB_image = YCBCR2RGB(YCbCr_image)
    % 定义转换矩阵和偏移量
    origT = [65.481 128.553 24.966;
             -37.797 -74.203 112;
             112 -93.786 -18.214];
    origOffset = [16; 128; 128];
    % 定义逆转换矩阵和偏移量
    invT = inv(origT);
    invOffset = -1 * origOffset;

    % 将 YCbCr 图像转换为 double 类型
    YCbCr_double = double(YCbCr_image);

    % 将 YCbCr 图像重塑为行向量
    YCbCr_vector = reshape(YCbCr_double, [], 3)';

    % 进行色彩空间逆转换
    RGB_vector = invT * (YCbCr_vector + invOffset);

    % 将转换后的 RGB 向量重新映射到 [0, 1] 范围
    RGB_vector = max(min(RGB_vector, 1), 0);

    % 将 RGB 值重新映射到 [0, 255] 范围，并四舍五入取整
    RGB_vector = round(RGB_vector * 255);

    % 将转换后的 RGB 向量重新排列为图像形状
    RGB_image = uint8(reshape(RGB_vector', size(YCbCr_image)));
end

