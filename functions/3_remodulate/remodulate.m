function dab_frame_remod = remodulate(dab_data, dab_mode)
    %% FREQ INTERLEAVE
    interleave_map = build_interleave_map();
    dab_data_interleaved = freq_interleave(dab_data, interleave_map, dab_mode);

    %% DQPSK BUILD
    prs = build_prs();
    dab_carriers_remod = dqpsk_map(dab_data_interleaved, prs, dab_mode);

    %% OFDM MUX
    dab_symbols_remod = ofdm_mux(dab_carriers_remod);

    %% BLOCK PACK
    dab_frame_remod = symbols_pack(dab_symbols_remod, dab_mode);
end