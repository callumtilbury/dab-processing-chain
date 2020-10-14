function dab_carriers = ofdm_demux(dab_symbols)
    % Extract symbols using FFT
    dab_carriers = fftshift(fft(dab_symbols,[],2),2) ./ length(dab_symbols);
end