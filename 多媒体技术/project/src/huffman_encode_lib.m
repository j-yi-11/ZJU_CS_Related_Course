function [data_encoded,dictionary_encoded] = huffman_encode_lib(original_data)
    [m,n] = size(original_data);
    reshaped_data = reshape(original_data, 1, m*n);     
    table = tabulate(reshaped_data(:));     
    dictionary_encoded = huffmandict((table(:,1)),(table(:,3) ./ 100));  
    data_encoded = uint8(huffmanenco(reshaped_data,dictionary_encoded));   
end