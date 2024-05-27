function [image_channel_encoded, symbol_code_struct] = huffman_encode_myself(image_channel_original)
    [r, c] = size(image_channel_original);

    num_pixels = numel(image_channel_original);
    gray_levels = 0:255; 
    count = zeros(1, 256);
    for i = 1:numel(gray_levels)
        count(i) = sum(sum(image_channel_original == gray_levels(i))); 
    end

    positive_indices = find(count > 0); 
    positive_elements_number = length(positive_indices);

    p = zeros(1, positive_elements_number);
    symbol = zeros(1, positive_elements_number);


    for i = 1:positive_elements_number
        index = positive_indices(i);
        p(i) = count(index);
        symbol(i) = index - 1;
    end

    % coding
    N = length(p);
    code = strings(N-1,N);
    reflect = zeros(N-1,N);
    p_SD = p;
    for i=1:N-1 
        M = length(p_SD);
        [p_SD,reflect(i,1:M)] = sort(p_SD,'descend');
        code(i,M) = '1';
        code(i,M-1) = '0';
        p_SD(M-1) = p_SD(M-1)+p_SD(M);
        p_SD(M)=[];
    end

    CODE = strings(1,N);
    for i=1:N
        column = i;
        for m=1:N-1
            [row,column] = find(reflect(m,:)==column);
            CODE(1,i) = strcat(CODE(1,i),code(m,column));
            if column==N+1-m
                column = column-1;
            end
        end
    end
    CODE = reverse(CODE);


    symbol_code_struct = struct();
    for i = 1:length(symbol)
        symbol_code_struct(i).symbol = symbol(i);
        symbol_code_struct(i).code = CODE{i};
    end

    image_channel_encoded = strings(r,c);
    for i = 1:r
        for j = 1:c
            for k = 1:length(symbol_code_struct)
                if image_channel_original(i,j) == symbol_code_struct(k).symbol
                    image_channel_encoded(i,j) = symbol_code_struct(k).code;
                    break
                end
            end
        end
    end
    % fprintf("encode finish\n");
end