function iq_data = iq_resample(iq_data_raw, fs)
    %IQ_RESAMPLE Summary of this function goes here
    %   Detailed explanation goes here
    
    % Resample to 2.048MHZ if not already
    if (fs ~= 2.048e6)
        iq_data = resample(iq_data_raw,2.048e6,fs);
    else
        iq_data = iq_data_raw;
    end
    
end

