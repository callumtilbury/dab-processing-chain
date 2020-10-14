function dab_carriers_remod = dqpsk_map(dab_data_interleaved, prs, dab_mode)
    dab_carriers_remod = zeros(dab_mode.L, dab_mode.Tu);
    dab_carriers_remod(1,:) = prs.';

    for ii = 2:dab_mode.L
        dab_carriers_remod(ii,:) = dab_carriers_remod(ii-1,:) .* dab_data_interleaved(ii,:);
    end
end