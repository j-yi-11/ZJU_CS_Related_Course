function izigzag_channel = izigzag8x8(DC_AC_channel,resize_width)
    % mainly for DC AC channel
    length = 8;
    DC_AC_channel_vectorized = reshape(DC_AC_channel,resize_width*length,[]);
    DC_AC_channel_vectorized = DC_AC_channel_vectorized';
    [row_DC_AC, column_DC_AC] = size(DC_AC_channel_vectorized);
    izigzag_channel = zeros(length*row_DC_AC, uint16(column_DC_AC/length));
    for i = 0 : row_DC_AC - 1
        for j = 0 : length^2 : column_DC_AC - length^2
            channel_block = DC_AC_channel_vectorized(i+1,j+1:j+length^2);
            izigzag_block = iblockZigzag(channel_block);
            izigzag_channel(length*i+1:length*i+length,...
                            j/length+1:j/length+length) = izigzag_block;
        end
    end
end