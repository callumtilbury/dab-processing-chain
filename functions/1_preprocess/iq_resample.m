function iq_data = iq_resample(iq_data_raw, fs)
    % ---------------------------------------------------------------------    
    % IQ_RESAMPLE: Resamples complex data if Fs != 2.048 MHz
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > iq_data_raw:      Raw IQ data from iq_read function
    %   > fs:               Sampling frequency of IQ data
    %
    %  Outputs
    %   < iq_data_raw:      IQ data at correct Fs (2.048MHz) for COFDM
    %
    % ---------------------------------------------------------------------
    
    if (fs ~= 2.048e6)
        % Resample to 2.048MHZ, if not already
        iq_data = resample(iq_data_raw,2.048e6,fs);
    else
        % Otherwise just return the input
        iq_data = iq_data_raw;
    end
    
end

