function [dab_frames, first_prs, n_actual, iq_data_meas] = batch_preprocess(file_name,file_datatype, frame_count,file_offset, dab_mode, fs)
    %% MEMORY ALLOCATION
    dab_frames = zeros(frame_count, dab_mode.Tf);

    %% IQ READ
    iq_data_raw = iq_read(file_name, file_datatype, ceil(frame_count*fs/2.048e6), file_offset, dab_mode);
    
    %% IQ RESAMPLE
    iq_data = iq_resample(iq_data_raw, fs);
    iq_data_meas = iq_data;
    
    %% PRS DETECT
    prs = build_prs();
    first_prs = -1;
     
    for ii = 1:frame_count      
        prs_idx = prs_detect(iq_data, prs, dab_mode);
        
        if (first_prs == -1)
            first_prs = prs_idx;
        end      
       
        %% FRAME EXTRACT
        dab_frames(ii,:) = frame_extract(iq_data, prs_idx, 0, dab_mode);

        iq_data = iq_data(prs_idx + dab_mode.Tf - dab_mode.Tnull:end);
        
        if (size(iq_data, 1) < dab_mode.Tf)
            n_actual = ii;
            break
        end
        
    end
        
end