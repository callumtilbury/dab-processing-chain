% ---------------------------------------------------------------------    
% REF_BUILDER: Emulation of the Reference Builder application using 
%               this DAB processing chain
% ---------------------------------------------------------------------
% Constants
dab_mode = load_dab_constants(1);

% File names
perfect.name = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
raw.name = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin";
rtl.name = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin";

% File types
perfect.file_type = "double";
raw.file_type = "short";
rtl.file_type = "short";

% Fs values
perfect.fs = 2.048e6;
raw.fs = 2.5e6;
rtl.fs = 2.048e6;

% Output name
perfect.file_out = "perfect-data-out";
raw.file_out = "raw-data-out";
rtl.file_out = "rtl-data-out";

% File offset
file_offset = 1e6;

% Goal number of frames to process
n_aim = 10;

% File choice
file = perfect;

% Preprocess a set of multiple frames
[frames_in, first_prs, n_actual, original_data] = batch_preprocess(file.name, file.type, n_aim, file_offset, dab_mode, file.fs);
% Check if prs is on odd or even sample
if (mod(first_prs,2) == 1)
    first_prs = first_prs - 1;
end

% Open output files
file_out_id = fopen(file.file_out + ".dabRef","wb");
symbols_out_id = fopen(file.file_out + ".symbRef","wb");

% Prepend with zeros until PRS
zero_offset_vals = zeros(1,2*(first_prs-dab_mode.Tnull-dab_mode.Tg));
fwrite(file_out_id,zero_offset_vals,"double");

%% REFERENCE FILE OUTPUT
% Process the frame
for ii = 1:n_actual
    % Recording -> Demod -> Remod -> Recording
    [tmp_demod, tmp_carriers] = demodulate(frames_in(ii,:), dab_mode);
    tmp_remod = remodulate(tmp_demod, dab_mode);
    tmp_raw = zeros(1,2*dab_mode.Tf);
    tmp_raw(1:2:end) = real(tmp_remod);
    tmp_raw(2:2:end) = imag(tmp_remod);
    fwrite(file_out_id,tmp_raw,"double");
    
    % Symbols
    for jj = 1:dab_mode.L
        tmp_symbols = zeros(1,2*dab_mode.K);
        tmp_symbols(1:2:end) = real(tmp_carriers(jj,dab_mode.mask));
        tmp_symbols(2:2:end) = imag(tmp_carriers(jj,dab_mode.mask));
        fwrite(symbols_out_id,tmp_symbols,"double");
    end
end
% Clean up
fclose(file_out_id);

%% MEASURED FILE OUT
meas_file_out_id = fopen(file.file_out + ".dabMeas", "wb");
tmp_meas = zeros(1,2*length(original_data));
tmp_meas(1:2:end) = real(original_data);
tmp_meas(2:2:end) = imag(original_data);
fwrite(meas_file_out_id, tmp_meas, "double");

fclose(meas_file_out_id);

