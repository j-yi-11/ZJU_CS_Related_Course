function image_block = apply_iDCT(dct_coefficients)
    [block_rows, block_cols] = size(dct_coefficients);
    % fprintf("[block_rows, block_cols] = [%d, %d]\n",block_rows, block_cols);
    image_block = zeros(block_rows, block_cols);
    tmp = zeros(block_rows, block_cols);
    N = block_rows;
    for i = 0 : block_rows-1
        for j = 0 : block_cols-1
            if i == 0
                c_i = sqrt(1/N);
            else
                c_i = sqrt(2/N);
            end
            tmp(i+1,j+1) = c_i*cos((j+0.5)*pi*i/N);
        end
    end
    image_block = tmp'*dct_coefficients*tmp;
end
