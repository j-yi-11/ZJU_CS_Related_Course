function [encoded_image_channel] = RLC_encode(original_image_channel)
    [rows, cols] = size(original_image_channel);
    encoded_image_channel = [];
    % fprintf("encode [r, c] = [%d, %d]\n", rows, cols);
    index = 1;
    for row = 1 : rows
        count = 1;
        for col = 2 : cols
            if original_image_channel(row, col) == original_image_channel(row, col-1)
                count = count + 1;
            else
                encoded_image_channel(index) = count;
                encoded_image_channel(index + 1) = original_image_channel(row, col - 1);
                index = index + 2;
                count = 1;
            end
        end
        encoded_image_channel(index) = count;
        encoded_image_channel(index + 1) = original_image_channel(row, cols);
        index = index + 2;
    end
end




