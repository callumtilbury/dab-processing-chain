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
hold off;
plot(d_deint(2,:), 'bo', 'MarkerFaceColor', colour, 'MarkerSize', 7);
hold on;
plot(d_snap(2,:),'rx', 'LineWidth', 4, 'MarkerSize',20);

x = 10/sqrt(2);
plot([0 x],[0 x],'--r');
plot([0 x],[0 -x],'--r');
plot([0 -x],[0 x],'--r');
plot([0 -x],[0 -x],'--r');
grid on;
xline(0,'k',"Im");
yline(0,'k',"Re");
axis([-1.2 1.2 -1.2 1.2]);

figure(2);
hold off;
plot(angle(d_deint(2,:)), 'o', 'MarkerFaceColor', colour, 'MarkerEdgeColor', colour);
xlim([0 1536]);
xlabel("Carrier Index");
ylabel("Phase [rad]");
yline(     pi,'k');
yline(   pi/2,'k');
yline(      0,'k');
yline(-  pi/2,'k');
yline(-    pi,'k');

figure(3);
plot(d_snap(2,47:50),'o', 'MarkerFaceColor', colour, 'MarkerSize', 8);
grid on;
xline(0,'k',"Im");
yline(0,'k',"Re");
axis([-1 1 -1 1]);