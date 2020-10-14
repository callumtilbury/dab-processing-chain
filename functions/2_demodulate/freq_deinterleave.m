function dab_data_deinterleaved = freq_deinterleave(dab_data_raw, interleave_map)
    dab_data_deinterleaved = dab_data_raw(:,interleave_map);
end