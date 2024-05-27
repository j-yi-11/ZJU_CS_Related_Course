function [DCT_Y_channel,DCT_Cb_channel,DCT_Cr_channel] = DCT_transform(imgY,imgCb,imgCr,length)
    % length = 8;
    [row_Y, column_Y] = size(imgY);
    DCT_Y_channel = zeros(row_Y, column_Y);
    for i = 0 : length : (row_Y - length)
        for j = 0 : length : (column_Y - length)
            DCT_Y_channel(i+1:i+length,j+1:j+length) = apply_DCT(imgY(i+1:i+length,j+1:j+length));%  dct2
        end
    end
    [row_Cb, column_Cb] = size(imgCb);
    DCT_Cb_channel = zeros(row_Cb, column_Cb);
    for i = 0 : length : (row_Cb - length)
        for j = 0 : length : (column_Cb - length)
            DCT_Cb_channel(i+1:i+length, j+1:j+length) = apply_DCT(imgCb(i+1:i+length, j+1:j+length));
        end
    end
    [row_Cr, column_Cr] = size(imgCr);
    DCT_Cr_channel = zeros(row_Cr, column_Cr);
    for i = 0 : length : (row_Cr - length)
        for j = 0 : length : (column_Cr - length)
            DCT_Cr_channel(i+1:i+length, j+1:j+length) = apply_DCT(imgCr(i+1:i+length, j+1:j+length));
        end
    end
end

