% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];

% file_in = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
% file_in = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin";
% file_in = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin";
% file_in = "raw_data_out.dabRef";
file_in = "DAB_data/CPT_data/dabcapture.bin";

file_out = "cpt-data_data_out";
file_type = "double";
fs = 2.048e6;

n_aim = 1;
file_offset = 0;

[frames_in, first_prs, n_actual, original_data] = batch_preprocess(file_in, file_type, n_aim, file_offset, mode1, fs);

if (mod(first_prs,2) == 1)
    first_prs = first_prs - 1;
end

file_out_id = fopen(file_out + ".dabRef","wb");
zero_offset_vals = zeros(1,2*(first_prs-mode1.Tnull-mode1.Tg));
fwrite(file_out_id,zero_offset_vals,"double");

for ii = 1:n_actual
    tmp_out = remodulate(demodulate(frames_in(ii,:), mode1), mode1);
    tmp_raw = zeros(1,2*mode1.Tf);
    tmp_raw(1:2:end) = real(tmp_out);
    tmp_raw(2:2:end) = imag(tmp_out);
    fwrite(file_out_id,tmp_raw,"double");
end

fclose(file_out_id);

mychain_data = iq_read(file_out + ".dabRef", "double", n_aim, 0, mode1);

meas_file_out_id = fopen(file_out + ".dabMeas", "wb");
tmp_meas = zeros(1,2*length(original_data));
tmp_meas(1:2:end) = real(original_data);
tmp_meas(2:2:end) = imag(original_data);
fwrite(meas_file_out_id, tmp_meas, "double");

fclose(meas_file_out_id);

figure(1);
hold off;
plot(abs(original_data));
hold on;
plot(abs(mychain_data));


