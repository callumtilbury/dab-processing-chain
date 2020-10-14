function dab_frame_remod = symbols_pack(dab_symbols_remod, dab_mode)
    dab_frame_remod = zeros(dab_mode.Tf,1);
    % Data elements in null symbol are zero, so just skip it
    t_idx = dab_mode.Tnull + 1;

    % Go through each block
    for b = 1:dab_mode.L
        % Guard interval
        dab_frame_remod(t_idx:t_idx+dab_mode.Tg-1) = dab_symbols_remod(b,dab_mode.Tu-dab_mode.Tg+1:dab_mode.Tu);
        % Block content
        dab_frame_remod(t_idx+dab_mode.Tg:t_idx+dab_mode.Tg+dab_mode.Tu-1) = dab_symbols_remod(b,:);
        % Jump ahead by one block length
        t_idx = t_idx + dab_mode.Ts;
    end
    
    dab_frame_remod = dab_frame_remod;%.';
end