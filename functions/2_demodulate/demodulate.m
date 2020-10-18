function dab_data = demodulate(dab_frame, dab_mode)
    % ---------------------------------------------------------------------    
    % DEMODULATE: 
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_frame:        IQ data of a single DAB frame, with PRS aligned
    %   > dab_mode:         Structure containing constants for DAB mode
    %
    %  Outputs
    %   < dab_data:         Demodulated data of the given DAB frame
    %
    % ---------------------------------------------------------------------

    %% SYMBOLS UNPACK
    dab_symbols = symbols_unpack(dab_frame, dab_mode);

    %% OFDM MUX
    dab_carriers = ofdm_demux(dab_symbols);
    
    %% DQPSK EXTRACT
    dab_data_raw = dqpsk_demap(dab_carriers, dab_mode);
    
    %% FREQ DEINTERLEAVE
    map = build_interleave_map();
    dab_data_deinterleaved = freq_deinterleave(dab_data_raw, map);

    %% DQPSK SNAP
    dab_data_snapped = dqpsk_snap(dab_data_deinterleaved);
    
    %% ERROR CORRECTION
    dab_data = error_correct(dab_data_snapped);

end