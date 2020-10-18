function prs_idx = prs_detect(iq_data, prs, dab_mode)
    % ---------------------------------------------------------------------    
    % PRS_DETECT: Detects a phase reference symbol in provided IQ data
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > iq_data:      IQ data correctly sampled at Fs = 2.048e6
    %   > prs:          Symbol values to detect in iq_data
    %                   (Note: Use misc/build_phase_reference.m)
    %   > dab_mode:     Structure containing constants for DAB mode
    %
    %  Outputs
    %   < prs_idx:      Index of first phase reference symbol in iq_data
    %
    % ---------------------------------------------------------------------
    
    % Move through iq_data, in steps of dab_mode.Tu/2
    % i.e. Advance 1/2 window length on each iteration
    for ii = 1:dab_mode.Tu/2:length(iq_data)
        % Apply matched filter in frequency domain,
        %   using a window length of dab_mode.Tu
        MF_out = conj(prs) .* fftshift(fft(iq_data(ii:ii+dab_mode.Tu-1)));   
        % Bring back to time
        mf_out = abs(ifft(MF_out));
        % Find max value of mf_out
        [peak_val,peak_idx] = max(mf_out);
        
        % Check if a peak truly exists by comparing the max to the mean
        %   AND if it is in the first half of the window
        if (peak_val > 50*mean(abs(mf_out)) && peak_idx < dab_mode.Tu/2)
            % If so, the phase reference index has been found
            prs_idx = ii + peak_idx - 1;
            break
        end

    end
        
end

