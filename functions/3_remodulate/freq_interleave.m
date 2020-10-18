function dab_data_interleaved = freq_interleave(dab_data, interleave_map, dab_mode)
    % ---------------------------------------------------------------------    
    % FREQ_INTERLEAVE: Interleave OFDM components for each symbol
    % within a DAB frame
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_data:                 Uninterleaved snapped DQPSK data
    %                               (output of the demodulator block)
    %                                   [dab_mode.L x dab_mode.K]
    %   > interleave_map:           Interleave map
    %                               (Note: the interleave and deinterleave
    %                               functions use the same interleaving
    %                               map, which can be generated using the
    %                               misc/build_interleave_map.m function)
    %   > dab_mode:         Structure containing constants for DAB mode
    %
    %  Outputs
    %   < dab_data_interleaved:     Interleaved DQPSK data
    %                                   [dab_mode.L x dab_mode.Tu]
    %
    % ---------------------------------------------------------------------

    % Pre-allocate
    dab_data_interleaved = zeros(dab_mode.L,dab_mode.Tu);
    
    % Use interleave map
    dab_data_interleaved(:,interleave_map) = dab_data;
end