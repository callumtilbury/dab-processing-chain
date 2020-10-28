function dab_data_deinterleaved = freq_deinterleave(dab_data_raw, interleave_map)
    % ---------------------------------------------------------------------    
    % FREQ_DEINTERLEAVE: Deinterleave OFDM components for each symbol
    % within a DAB frame
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_data_raw:             Raw DQPSK data,
    %                                   [(dab_mode.L - 1) x dab_mode.Tu]
    %   > interleave_map:           Deinterleave map
    %                               (Note: the interleave and deinterleave
    %                               functions use the same interleaving
    %                               map, which can be generated using the
    %                               misc/build_interleave_map.m function)
    %
    %  Outputs
    %   < dab_data_deinterleaved:   Deinterleaved DQPSK data
    %                                   [dab_mode.L x dab_mode.K]
    %
    % ---------------------------------------------------------------------
    dab_data_deinterleaved = dab_data_raw(:,interleave_map);
end