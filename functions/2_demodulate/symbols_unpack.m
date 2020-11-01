function dab_symbols = symbols_unpack(dab_frame, dab_mode)
    % ---------------------------------------------------------------------    
    % SYMBOLS_UNPACK: Unpack frame into dab_mode.L x symbols
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_frame:        IQ data of a single DAB frame, with PRS aligned
    %                           [1 x dab_mode.Tf]
    %   > dab_mode:         Structure containing constants for DAB mode
    %
    %  Outputs
    %   < dab_symbols:      IQ data in dab_mode.L symbols (i.e. 'chunks')
    %                           [dab_mode.L x dab_mode.Tu]
    %
    % ---------------------------------------------------------------------    
    % Read symbols from each frame
    dab_symbols = zeros(dab_mode.L, dab_mode.Tu);
    
    % Start after null & first guard interval
    % Note: If misaligned _earlier_ is okay, but cannot be later! (Because
    % of cyclic guard interval with cyclic prefix)
    idx = dab_mode.Tnull + dab_mode.Tg + 1;
    
    for l = 1:dab_mode.L % In total, read L symbols
        % Read symbol
        dab_symbols(l,:) = dab_frame(idx:idx+dab_mode.Tu-1);
        % Jump ahead 1 symbol, incl. guard
        idx = idx + dab_mode.Ts;
    end

end