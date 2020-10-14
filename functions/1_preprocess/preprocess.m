function dab_frame = preprocess(file_name,file_datatype,frame_count,file_offset, frame_offset, dab_mode, fs)
    %% IQ READ
    iq_data_raw = iq_read(file_name, file_datatype, frame_count, file_offset, dab_mode);
    
    %% IQ RESAMPLE
    iq_data = iq_resample(iq_data_raw, fs);
    
    %% PRS DETECT
    prs = build_prs();
    prs_idx = prs_detect(iq_data, prs, dab_mode);
    
    %% FRAME EXTRACT
    dab_frame = frame_extract(iq_data, prs_idx, frame_offset, dab_mode);
    
end