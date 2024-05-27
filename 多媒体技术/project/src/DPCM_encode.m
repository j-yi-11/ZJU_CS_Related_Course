function DC_encoded = DPCM_encode(original_signal)
    % mainly for DC
    data = original_signal(1,:);
    [row_number,column_number] = size(data);
    signal_predicted = zeros(1,column_number);
    signal_reconstructed = zeros(1,column_number);
    errors = zeros(1,column_number);
    DC_encoded = zeros(1,column_number);
    signal_predicted(1) = data(1);
    signal_predicted(2) = data(1);
    signal_reconstructed(1) = data(1);
    DC_encoded(1) = data(1);
    for i = 2 : column_number
        if i ~= 2 
            signal_predicted(i) = (signal_reconstructed(i-1) + signal_reconstructed(i-2))/2;
        end
        errors(i) = data(i) - signal_predicted(i);
        DC_encoded(i) = 2 * floor((255 + errors(i))/2) - 256 + 1;    
        signal_reconstructed(i) = signal_predicted(i) + DC_encoded(i);        
    end
end