function decoded_image_channel = RLC_decode(encoded_image_channel, original_size)
    decoded_image_channel = zeros(original_size);
    index = 1;
    [rows, cols] = size(decoded_image_channel);
    fprintf("decode [r, c] = [%d, %d]\n", rows, cols);
    for row = 1 : rows
        col = 1;
        while ((col <= cols) && (index <= length(encoded_image_channel)))
            count = encoded_image_channel(index);
            % fprintf("count = %d\n", count);
            % decoded_image_channel(row, col : col+count-1) = encoded_image_channel(index + 1);
            for j = col : col + count - 1
                decoded_image_channel(row, j) = encoded_image_channel(index + 1);
            end
            col = col + count;
            % fprintf("col = %d\n", col);
            index = index + 2;
        end
        % fprintf("index = %d\n", index);
    end
end

