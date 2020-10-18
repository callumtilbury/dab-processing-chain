function dab_frame_remod = remodulate(dab_data, dab_mode)
    % ---------------------------------------------------------------------    
    % REMODULATE: 
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_data:         Demodulated data of a DAB frame
    %   > dab_mode:         Structure containing constants for DAB mode
    %
    %  Outputs
    %   > dab_frame_remod:  IQ data of a single DAB frame, with PRS aligned
    %
    % ---------------------------------------------------------------------
    %% FREQ INTERLEAVE
    interleave_map = build_interleave_map();
    dab_data_interleaved = freq_interleave(dab_data, interleave_map, dab_mode);

    %% DQPSK MAP
    prs = build_prs();
    dab_carriers_remod = dqpsk_map(dab_data_interleaved, prs, dab_mode);

    %% OFDM MUX
    dab_symbols_remod = ofdm_mux(dab_carriers_remod);

    %% SYMBOLS PACK
    dab_frame_remod = symbols_pack(dab_symbols_remod, dab_mode);
    
end