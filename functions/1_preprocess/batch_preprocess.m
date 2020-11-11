function [dab_frames, first_prs, frame_count_actual, iq_data_meas] = ...
        batch_preprocess(file_name, file_datatype, frame_count, ...
                        file_offset, dab_mode, fs)
    % ---------------------------------------------------------------------    
    % BATCH_PREPROCESS: Utility for ref_builder to extract multiple DAB
    % frames at once, while also returning some other useful info
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > file_name:        Name of Binary File
    %   > file_datatype:    Format of data values, e.g. 'double'
    %   > frame_count:      Desired number of frames to read
    %                       (Note: The function *might* return less frames
    %                       than frame_count, if the binary file has a
    %                       frame offset. The *correct* count of frames is
    %                       returned in frame_count_actual)
    %   > file_offset:      Offset in binary file
    %   > dab_mode:         Structure containing constants for DAB mode
    %   > fs:               Sampling frequency of IQ data
    %
    %  Outputs
    %   < dab_frames:       Matrix of DAB frames, as
    %                           [frame_count, frame_size]
    %   < first_prs:        Index of the first PRS symbol detection
    %   < frame_count_actual:   The actual number of frames returned
    %   < iq_data_meas:     A copy of the original read in data, without
    %                       being packaged into frames (used as the
    %                       measurement signal)
    %
    % ---------------------------------------------------------------------
    
    %% PRE-ALLOCATION
    dab_frames = zeros(frame_count, dab_mode.Tf);

    %% IQ READ
    % Note: iq_read function is unaware of sampling frequency, but this
    % affects how many samples must be read for each frame
    %  => Read in frame_count * fs/2.048MHz
    iq_data_raw = iq_read(file_name, file_datatype, ...
        ceil(frame_count*fs/2.048e6), file_offset, dab_mode);
    
    %% IQ RESAMPLE
    iq_data = iq_resample(iq_data_raw, fs);
    
    % Return a copy of the measurement signal
    iq_data_meas = iq_data;
    
    %% PRS DETECT
    prs = build_prs(1);
    first_prs = -1;
    
    % Assume that desired frame count will be read
    frame_count_actual = frame_count;
    
    %% Repeatedly extract frames
    for ii = 1:frame_count      
        prs_idx = prs_detect(iq_data, prs, dab_mode);
        
        if (first_prs == -1)
            first_prs = prs_idx;
        end      
       
        %% FRAME EXTRACT
        dab_frames(ii,:) = frame_extract(iq_data, prs_idx, 0, dab_mode);
        
        % Jump ahead by just less than one frame in iq_data
        iq_data = iq_data(prs_idx + dab_mode.Tf - dab_mode.Tnull:end);
        
        % Check if we've reached the end of the available iq_data
        if (size(iq_data, 1) < dab_mode.Tf)
            % Haven't been able to read all of frame_count
            frame_count_actual = ii;
            break
        end
        
    end
        
end