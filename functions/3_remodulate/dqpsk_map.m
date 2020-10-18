function dab_carriers_remod = dqpsk_map(dab_data_interleaved, prs, dab_mode)
    % ---------------------------------------------------------------------    
    % DQPSK_MAP: Map DQPSK data to DAB carriers
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > dab_data_interleaved: Deinterleaved DQPSK data
    %                               [dab_mode.L x dab_mode.Tu]
    %   > prs:                  Phase reference symbol
    %                            Used as a reference for the *differential*
    %                             phase modulation
    %   > dab_mode:             Structure containing constants for DAB mode
    %
    %  Outputs
    %   < dab_carriers_remod: DAB carriers, [dab_mode.L x dab_mode.Tu]
    %
    % ---------------------------------------------------------------------
    
    % Pre-allocate
    dab_carriers_remod = zeros(dab_mode.L, dab_mode.Tu);
    
    % First carrier is the phase reference symbol (transposed)
    dab_carriers_remod(1,:) = prs.';

    for ii = 2:dab_mode.L
        % Carriers are modulated using the interleaved data multiplied by
        % the phase of the previous carrier (*Differential*-QPSK)
        dab_carriers_remod(ii,:) = dab_carriers_remod(ii-1,:) ...
                                .* dab_data_interleaved(ii,:);
    end
end