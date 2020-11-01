% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];

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
frame = preprocess(file.name, file.type, 2, file.offset, 0, mode1, file.fs);

d1 = demodulate(frame, mode1);
r1 = remodulate(d1, mode1);
d2 = demodulate(r1, mode1);
r2 = remodulate(d2, mode1);

e = r2 - r1;

fprintf("Max Error = %e\n", max(max(e)));
