function dab_symbols_remod = ofdm_mux(dab_carriers_remod)
    % ---------------------------------------------------------------------    
    % OFDM_MUX: Multiplex DAB carriers into OFDM symbols using inverse-FFT
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_carriers: OFDM carriers
    %                       [dab_mode.L x dab_mode.Tu]
    %
    %  Outputs
    %   < dab_symbols_remod: OFDM Symbols extracted from frame
    %                       [dab_mode.L x dab_mode.Tu]
    %
    % ---------------------------------------------------------------------
    dab_symbols_remod = ifft(fftshift(dab_carriers_remod,2),[],2) ...
        .* length(dab_carriers_remod); % Multiply by iFFT length for scaling
end