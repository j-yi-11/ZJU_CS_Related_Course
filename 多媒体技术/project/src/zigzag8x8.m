function zigzagged_channel = zigzag8x8(quantified_channel)
    Zigzag_table=[
        1 2 9 17 10 3 4 11;
        18 25 33 26 19 12 5 6;
        13 20 27 34 41 49 42 35; 
        28 21 14 7 8 15 22 29;
        36 43 50 57 58 51 44 37;
        30 23 16 24 31 38 45 52;
        59 60 53 46 39 32 40 47;
        54 61 62 55 48 56 63 64];
    zigzag_table_vectorized = reshape(Zigzag_table',1,64);
    length = 8;

    [row, column] = size(quantified_channel);
    zigzagged_channel_vectorized = zeros(1, numel(quantified_channel));

    index = 0;
    for i = 0 : length : row-length
        for j = 0 : length : column-length
            channel_block = quantified_channel(i+1:i+length,j+1:j+length);
            zigzagged_channel_block_vectorized = blockZigzag(channel_block);
            zigzagged_channel_vectorized(index*length^2+1:index*length^2+length^2) = zigzagged_channel_block_vectorized;
            index = index + 1;
        end
    end    
    
    [a,b] = size(zigzagged_channel_vectorized);
    zigzagged_channel = reshape(zigzagged_channel_vectorized',length*length,a*b/(length*length));
end

