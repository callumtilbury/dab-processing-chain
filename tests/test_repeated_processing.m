% Constants
dab_mode = load_dab_constants(1);

perfect.name = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
rtl.name = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin";
raw.name = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin";

perfect.type = "double";
rtl.type = "short";
raw.type = "short";

perfect.fs = 2.048e6;
rtl.fs = 2.048e6;
raw.fs = 2.5e6;

perfect.offset = 1e6;
rtl.offset = 0;
raw.offset = 0;

%%
file = perfect;

% X -> Remod -> Demod -> X
frame = preprocess(file.name, file.type, 2, file.offset, 0, dab_mode, file.fs);

d1 = demodulate(frame, dab_mode);
r1 = remodulate(d1, dab_mode);
d2 = demodulate(r1, dab_mode);
r2 = remodulate(d2, dab_mode);

e = r2 - r1;

fprintf("Max Error = %e\n", max(max(e)));
