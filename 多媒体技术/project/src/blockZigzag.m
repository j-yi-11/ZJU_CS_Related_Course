function zigzagged_channel_block_vectorized = blockZigzag(channel_block)
    zigzag_table=[
        1 2 9 17 10 3 4 11;
        18 25 33 26 19 12 5 6;
        13 20 27 34 41 49 42 35; 
        28 21 14 7 8 15 22 29;
        36 43 50 57 58 51 44 37;
        30 23 16 24 31 38 45 52;
        59 60 53 46 39 32 40 47;
        54 61 62 55 48 56 63 64];
    
    channel_block_vectorized = reshape(channel_block',1,64);
    zigzag_table_vectorized = reshape(zigzag_table',1,64); 
    zigzagged_channel_block_vectorized = channel_block_vectorized(zigzag_table_vectorized); 
end