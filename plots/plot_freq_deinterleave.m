% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];

perfect.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", "double", 1, 1e6, 0, mode1, 2.048e6);
raw.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin", "short", 2, 0, 0, mode1, 2.5e6);
rtl.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 2, 0, 0, mode1, 2.048e6);

perfect.name = "Report/Images/plots/dqpsk_demap_perfect";
raw.name =  "Report/Images/plots/dqpsk_demap_raw";
rtl.name =  "Report/Images/plots/dqpsk_demap_rtl";

file = rtl;

s = symbols_unpack(file.z, mode1);
c = ofdm_demux(s);
d = dqpsk_demap(c, mode1);
d_deint = freq_deinterleave(d, build_interleave_map());

d_snap = dqpsk_snap(d_deint);

colour = [0, 0.4470, 0.7410];

figure(1);
plot(angle(d(2,:)), 'o',  'MarkerEdgeColor', colour);
xlim([0 mode1.Tu]);
hold on;
plot(mode1.mask,angle(d_deint(2,:)),'ro');
xlim([0 mode1.Tu]);
legend("dab\_data\_raw","dab\_data\_deint");
xlabel("Carrier Index");
ylabel("Phase [rad]");