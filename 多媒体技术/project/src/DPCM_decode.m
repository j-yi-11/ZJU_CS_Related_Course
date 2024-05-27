function signal_reconstructed = DPCM_decode(DC_encoded)
    % mainly for DC
    [row_number,column_number] = size(DC_encoded);
    signal_predicted = zeros(1,column_number);
    signal_reconstructed = zeros(1,column_number);
    signal_predicted(1) = DC_encoded(1);
    signal_predicted(2) = DC_encoded(1);
    signal_reconstructed(1) = DC_encoded(1);
    for i = 2 : column_number
        if i ~= 2
            signal_predicted(i) = (signal_reconstructed(i-1) + signal_reconstructed(i-2))/2;
        end
        signal_reconstructed(i) = signal_predicted(i) + DC_encoded(i);        
    end
    signal_reconstructed = double(uint8(signal_reconstructed));
end
