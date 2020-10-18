function dab_frame = frame_extract(iq_data, prs_index, frame_offset, dab_mode)
    % ---------------------------------------------------------------------    
    % FRAME_EXTRACT: Extract a single frame from given iq_data and prs indx
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > iq_data:      IQ data correctly sampled at Fs = 2.048e6
    %   > prs_index:	Index of first phase reference symbol
    %   > frame_offset:	Frame offset from first phase reference symbol
    %   > dab_mode:     Structure containing constants for DAB mode
    %
    %  Outputs
    %   < dab_frame:    IQ data of a single DAB frame
    %
    % ---------------------------------------------------------------------
    
    % Extracted frame should include PRS' guard interval, & the null symbol
    start_idx = prs_index - dab_mode.Tg - dab_mode.Tnull + frame_offset*dab_mode.Tf;

    % If gone too far back, pad the front of the returned frame with zeros
    if (start_idx < 1)
        % start_idx is negative, so (1-start_idx) is positive
        dab_frame = zeros(1 - start_idx, 1);
        dab_frame = [dab_frame;iq_data(1:dab_mode.Tf+start_idx-1)];
    else
        % Otherwise simply extract the frame
        dab_frame = iq_data(start_idx:start_idx+dab_mode.Tf-1);
    end

end