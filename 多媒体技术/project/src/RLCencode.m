function RLC_table_encoded = RLCencode(original_zigzagged_channel)
    % mainly for encoding AC
    AC = original_zigzagged_channel(2:64,:);
    [AC_row_count, AC_column_count] = size(AC);
    pixel_count = AC_row_count * AC_column_count;
    zero_count = 0;
    RLC_table_encoded = [];
    epsilon = 1;
    for i = 1 : pixel_count
        % take [-1,1] as zero
        if abs(AC(i)) <= epsilon
            zero_count = zero_count + 1;
        else
            RLC_table_encoded = [RLC_table_encoded;...
                                [zero_count,AC(i)]];
            zero_count = 0;
        end
    end
    RLC_table_encoded = [RLC_table_encoded;...
                        [0,0]];
end