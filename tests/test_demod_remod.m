% Constants
dab_mode = load_dab_constants(1);

colour = [0, 0.4470, 0.7410];

perfect.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", "double", 1, 1e6, 0, dab_mode, 2.048e6);
raw.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin", "short", 2, 0, 0, dab_mode, 2.5e6);
rtl.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 2, 0, 0, dab_mode, 2.048e6);

perfect.name = "Report/Images/plots/dqpsk_demap_perfect";
raw.name =  "Report/Images/plots/dqpsk_demap_raw";
rtl.name =  "Report/Images/plots/dqpsk_demap_rtl";

file = raw;

d = demodulate(file.z, dab_mode);
r = remodulate(d, dab_mode);
d2 = demodulate(r, dab_mode);
r2 = remodulate(d2, dab_mode);

e = r2 - r;

fprintf("Sum of Errors = %f\n", sum(sum(e)));