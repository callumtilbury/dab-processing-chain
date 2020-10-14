function dab_data_interleaved = freq_interleave(dab_data, interleave_map, dab_mode)
    dab_data_interleaved = zeros(dab_mode.L,dab_mode.Tu);
    
    dab_data_interleaved(:,interleave_map) = dab_data;
end