function [dab_data, dab_data_raw] = demodulate(dab_frame, dab_mode)
    % TEMP!!!
    % dab_frame = cast(dab_frame, 'single');

    %% SYMBOLS UNPACK
    dab_symbols = symbols_unpack(dab_frame, dab_mode);
    % dab_symbols = cast(dab_symbols, 'single');
    class(dab_symbols);
    
    %% OFDM MUX
    dab_carriers = ofdm_demux(dab_symbols);
    class(dab_carriers);
    
    %% DQPSK EXTRACT
    dab_data_raw = dqpsk_demap(dab_carriers, dab_mode);
    class(dab_data_raw);
    
    %% FREQ INTERLEAVE
    dab_data_deinterleaved = freq_deinterleave(dab_data_raw, build_interleave_map());
    class(dab_data_deinterleaved);

    %% DQPSK SNAP
    dab_data_snapped = dqpsk_snap(dab_data_deinterleaved);
    class(dab_data_snapped);
    
    %% ERROR CORRECTION
    dab_data = error_correct(dab_data_snapped);
    class(dab_data);
%     hold on;
%     plot(dab_data(2,:), 'ro', 'MarkerSize',10,'MarkerFaceColor','r');
%     xlim([0.7071063 0.7071072]);
%     ylim([0.7071063 0.7071072]);
%     pause

end