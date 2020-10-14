function dab_symbols_remod = ofdm_mux(dab_carriers_remod)
    dab_symbols_remod = length(dab_carriers_remod) .* ifft(fftshift(dab_carriers_remod,2),[],2);
end