function image_channel_decoded = huffman_decode_myself(image_channel_encoded, symbol_code_struct)
    % decode
    [r, c] = size(image_channel_encoded);
    image_channel_decoded = zeros(r, c);
    for i = 1:r
        for j = 1:c
            code = image_channel_encoded(i, j);
            for k = 1:length(symbol_code_struct)
                if strcmp(code, symbol_code_struct(k).code)
                    image_channel_decoded(i, j) = symbol_code_struct(k).symbol;
                    break;
                end
            end
        end
    end
    % fprintf("decode finish\n");
end