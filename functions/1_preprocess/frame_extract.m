function dab_frame = frame_extract(iq_data, prs_index, frame_offset, dab_mode)
    %FRAME_EXTRACT Summary of this function goes here
    %   Detailed explanation goes here

    % TODO: Account for files that start immediately with prs
    
    start_idx = prs_index - dab_mode.Tg - dab_mode.Tnull + frame_offset*dab_mode.Tf;

    if (start_idx < 1)
        dab_frame = zeros(1 - start_idx, 1);
        dab_frame = [dab_frame;iq_data(1:dab_mode.Tf+start_idx-1)];
    else
        dab_frame = iq_data(start_idx:start_idx+dab_mode.Tf-1);
    end

end

