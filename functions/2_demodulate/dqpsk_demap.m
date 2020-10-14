function dab_data_raw = dqpsk_demap(dab_carriers, dab_mode)
    dab_data_raw = zeros(dab_mode.L,dab_mode.Tu);

    % First carrier is phase reference symbol
    for ii = 2:dab_mode.L
        dab_data_raw(ii,dab_mode.mask) = dab_carriers(ii,dab_mode.mask) ./ dab_carriers(ii-1,dab_mode.mask);
    end
end