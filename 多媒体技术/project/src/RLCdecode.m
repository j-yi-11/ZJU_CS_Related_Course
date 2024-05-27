function AC = RLCdecode(AC_encoded, column_number)
    % mainly for decoding AC
    [row_count, column_count] = size(AC_encoded);
    % <count, key>
    RLC_table_column_count = column_count / 2;
    RLC_table = reshape(AC_encoded, RLC_table_column_count,2);
    AC_vectorized = zeros(1, 63 * column_number);
    j = 1;
    for i = 1 : RLC_table_column_count
        if RLC_table(i,1) == 0     
            AC_vectorized(j) = RLC_table(i,2);
            j = j + 1;
        else                         
            for k = 1 : RLC_table(i,1)
                AC_vectorized(j) = 0;
                j = j + 1;
            end
            AC_vectorized(j) = RLC_table(i,2);
            j = j + 1;
        end
    end
    AC = reshape(AC_vectorized, 63, column_number); 
end