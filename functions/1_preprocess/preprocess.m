function dab_frame = preprocess(file_name,file_datatype,frame_count, ...
                                file_offset, frame_offset, dab_mode, fs)                        
    % ---------------------------------------------------------------------    
    % PREPROCESS: Extracts a DAB frame from a binary file
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > file_name:        Name of Binary File
    %   > file_datatype:    Format of data values, e.g. 'double'
    %   > frame_count:      Number of frames to read into iq_data_raw
    %   > file_offset:      Offset in binary file
    %   > frame_offset:     Frame offset from first phase reference symbol
    %   > dab_mode:         Structure containing constants for DAB mode
    %   > fs:               Sampling frequency of IQ data
    %
    %  Outputs
    %   < dab_frame:         IQ data of a single DAB frame
    %
    % ---------------------------------------------------------------------
    
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