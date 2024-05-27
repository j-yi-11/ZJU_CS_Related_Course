function dct_coefficients = apply_DCT(imageBlock)
    [block_rows, block_cols] = size(imageBlock);
    dct_coefficients = zeros(block_rows, block_cols);
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
    dct_coefficients = tmp*imageBlock*tmp';
end

