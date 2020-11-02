function dab_frame_remod = symbols_pack(dab_symbols_remod, dab_mode)
    % ---------------------------------------------------------------------    
    % SYMBOLS_PACK: Pack dab_mode.L x symbols into a single DAB frame
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_symbols_remod:    IQ data in dab_mode.L x symbols
    %                               [dab_mode.L x dab_mode.Tu]
    %   > dab_mode:             Structure containing constants for DAB mode
    %
    %  Outputs
    %   < dab_frame_remod:  IQ data of a single DAB frame, with PRS aligned
    %                           [1 x dab_mode.Tf]
    %
    % ---------------------------------------------------------------------
    
    % Pre-allocate
    dab_frame_remod = zeros(1,dab_mode.Tf);
    % Data elements in null symbol are zero, so just skip it
    t_idx = dab_mode.Tnull + 1;

    % Go through each symbol
    for l = 1:dab_mode.L
        % Guard interval is last Tg values
        lth_guard = dab_symbols_remod(l, end - dab_mode.Tg + 1 : end);
        % Full Symbol = Guard + Original Symbol
        lth_symbol = [lth_guard, dab_symbols_remod(l,:)];

        % Add this symbol to the output frame
        dab_frame_remod(t_idx : t_idx + dab_mode.Ts - 1) = lth_symbol;
   
        % Jump ahead by one symbol length
        t_idx = t_idx + dab_mode.Ts;
    end

end