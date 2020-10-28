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
        fseek(file_id, 2*4*file_offset, 'bof'); % 4 bytes per short (x2 for cmplx)
    elseif (file_datatype == "double")
        fseek(file_id, 2*8*file_offset, 'bof');  % 8 bytes per double (x2 for cmplx)
    end

    % Read in data (x2 for cmplx)
    %   Note: Read in one extra frame here to extract enough *full* frames
    data_from_file = fread(file_id, 2*dab_mode.Tf*(frame_count+1), file_datatype);
    
    % Close file
    fclose(file_id);

    % Convert data to Complex Doubles
    iq_data_raw = data_from_file(1:2:end) + 1j*data_from_file(2:2:end);
    clear data_all;
       
end

