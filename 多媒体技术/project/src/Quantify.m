function [quantified_Y_channel,quantified_Cb_channel,quantified_Cr_channel] = Quantify(original_Y_channel,original_Cb_channel,original_Cr_channel,length)
    LumiTable=[
        16 11 10 16 24 40 51 61 ;
        12 12 14 19 26 58 60 55 ;
        14 13 16 24 40 57 69 56 ;
        14 17 22 29 51 87 80 62 ;
        18 22 37 56 68 109 103 77;
        24 35 55 64 81 104 113 92;
        49 64 78 87 103 121 120 101;
        72 92 95 98 112 100 103 99];
    ChromiTable=[
        17 18 24 47 99 99 99 99 ;
        18 21 26 66 99 99 99 99 ;
        24 26 56 99 99 99 99 99 ;
        47 66 99 99 99 99 99 99 ;
        99 99 99 99 99 99 99 99 ;
        99 99 99 99 99 99 99 99 ;
        99 99 99 99 99 99 99 99 ;
        99 99 99 99 99 99 99 99];    
    % length = 8;
    [Y_row, Y_column] = size(original_Y_channel);
    quantified_Y_channel = zeros(Y_row, Y_column);
    for i = 1 : Y_row/length
        for j = 1 : Y_column/length
            for k = 1 : length
                for t = 1 : length
                    quantified_Y_channel(length*(i-1)+k, length*(j-1)+t) = ...
                        round(original_Y_channel(length*(i-1)+k, length*(j-1)+t) / LumiTable(k, t));
                end
            end
        end
    end
    [Cb_row, Cb_column] = size(original_Cb_channel);
    quantified_Cb_channel = zeros(Cb_row, Cb_column);
    for i = 1 : Cb_row/length
        for j = 1 : Cb_column/length
            for k = 1 : length
                for t = 1 : length
                    quantified_Cb_channel(length*(i-1)+k, length*(j-1)+t) = ...
                        round(original_Cb_channel(length*(i-1)+k, length*(j-1)+t) / ChromiTable(k, t));
                end
            end
        end
    end
    [Cr_row, Cr_column] = size(original_Cr_channel);
    quantified_Cr_channel = zeros(Cr_row, Cr_column);
    for i = 1 : Cr_row/length
        for j = 1 : Cr_column/length
            for k = 1 : length
                for t = 1 : length
                    quantified_Cr_channel(length*(i-1)+k, length*(j-1)+t) = ...
                        round(original_Cr_channel(length*(i-1)+k, length*(j-1)+t) / ChromiTable(k, t));
                end
            end
        end
    end    
end

