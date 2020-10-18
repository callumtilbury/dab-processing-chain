function iq_data_raw = iq_read(file_name, file_datatype, ...
        frame_count, file_offset, dab_mode)
    % ---------------------------------------------------------------------    
    % IQ_READ: Reads in complex (IQ) data from a binary file
    % ---------------------------------------------------------------------
    % Usage:
    %  Inputs
    %   > file_name:        Name of Binary File
    %   > file_datatype:    Format of data values, e.g. 'double'
    %   > frame_count:      Number of frames to read into iq_data_raw
    %                       Set to inf to read entire file
    %                       (Note: Might read < frame_count, if there is a 
    %                       frame offset in the binary file)
    %   > file_offset:      Offset in binary file
    %   > dab_mode:         Structure containing constants for DAB mode
    %
    %  Outputs
    %   < iq_data_raw:      Complex IQ data
    %
    % ---------------------------------------------------------------------

    % Open file
    file_id = fopen(file_name);
    
    % Offset from beginning of file
    if (file_datatype == "short")
        fseek(file_id, 2*4*file_offset, 'bof'); % 4 bytes per short
    elseif (file_datatype == "double")
        fseek(file_id, 2*8*file_offset, 'bof');  % 8 bytes per double
    end

    % Read in data (x2 because data is cmplx)
    iq_data_all = fread(file_id, 2*dab_mode.Tf*(frame_count+1), file_datatype);
    
    % Close file
    fclose(file_id);

    % Convert data to Complex Doubles
    iq_data_raw = iq_data_all(1:2:end) + 1j*iq_data_all(2:2:end);
    clear data_all;
       
end

