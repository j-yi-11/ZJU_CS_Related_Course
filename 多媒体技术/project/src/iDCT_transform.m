function [Y, Cb, Cr] = iDCT_transform(DCT_Y_channel,DCT_Cb_channel,DCT_Cr_channel,length)
    % length = 8;
    [row_Y, column_Y] = size(DCT_Y_channel);
    Y = zeros(row_Y, column_Y);
    for i = 0 : length : (row_Y - length)
        for j = 0 : length : (column_Y - length)
            Y(i+1:i+length,j+1:j+length) = apply_iDCT(DCT_Y_channel(i+1:i+length,j+1:j+length));% idct2
        end
    end
    [row_Cb, column_Cb] = size(DCT_Cb_channel);
    Cb = zeros(row_Cb, column_Cb);
    for i = 0 : length : (row_Cb - length)
        for j = 0 : length : (column_Cb - length)
            Cb(i+1:i+length, j+1:j+length) = apply_iDCT(DCT_Cb_channel(i+1:i+length, j+1:j+length));
        end
    end
    [row_Cr, column_Cr] = size(DCT_Cr_channel);
    Cr = zeros(row_Cr, column_Cr);
    for i = 0 : length : (row_Cr - length)
        for j = 0 : length : (column_Cr - length)
            Cr(i+1:i+length, j+1:j+length) = apply_iDCT(DCT_Cr_channel(i+1:i+length, j+1:j+length));
        end
    end
end

