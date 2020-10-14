function dab_symbols = symbols_unpack(dab_frame, dab_mode)
    % Read symbols from each frame
    dab_symbols = zeros(dab_mode.L, dab_mode.Tu);
    
    % Start after null & first guard interval
    % Note: Misaligned _earlier_ is ok, but cannot be later!!
    ii = dab_mode.Tnull + dab_mode.Tg;
    for l = 1:dab_mode.L
        % Read symbol
        dab_symbols(l,:) = dab_frame(ii:ii+dab_mode.Tu-1);
        % Jump ahead 1 symbol, incl. guard
        ii = ii + dab_mode.Ts;
    end

end