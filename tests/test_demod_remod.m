% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];

colour = [0, 0.4470, 0.7410];

perfect.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", "double", 1, 1e6, 0, mode1, 2.048e6);
raw.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin", "short", 2, 0, 0, mode1, 2.5e6);
rtl.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 2, 0, 0, mode1, 2.048e6);

perfect.name = "Report/Images/plots/dqpsk_demap_perfect";
raw.name =  "Report/Images/plots/dqpsk_demap_raw";
rtl.name =  "Report/Images/plots/dqpsk_demap_rtl";

file = raw;

d = demodulate(file.z, mode1);
r = remodulate(d, mode1);
d2 = demodulate(r, mode1);
r2 = remodulate(d2, mode1);

e = r2 - r;

fprintf("Sum of Errors = %f\n", sum(sum(e)));