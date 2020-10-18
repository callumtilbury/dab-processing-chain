function dab_carriers = ofdm_demux(dab_symbols)
    % ---------------------------------------------------------------------    
    % OFDM_DEMUX: Demultiplex OFDM symbols into DAB carriers using FFT
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_symbols:  Symbols extracted from frame
    %                       [dab_mode.L x dab_mode.Tu]
    %
    %  Outputs
    %   < dab_carriers: OFDM carriers
    %                       [dab_mode.L x dab_mode.Tu]
    %
    % ---------------------------------------------------------------------    
    % Extract symbols using FFT
    dab_carriers = fftshift(fft(dab_symbols,[],2),2) ...
        ./ length(dab_symbols); % Divide by FFT length for proper scaling
end