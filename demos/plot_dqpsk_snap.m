% ---------------------------------------------------------------------    
% PLOT_DQPSK_SNAP: Plots a demo of DQPSK snapping functionality
% ---------------------------------------------------------------------
% Constants
dab_mode = load_dab_constants(1);

% File locations
perfect.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", "double", 1, 1e6, 0, dab_mode, 2.048e6);
raw.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin", "short", 2, 0, 0, dab_mode, 2.5e6);
rtl.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 2, 0, 0, dab_mode, 2.048e6);

% Choose which file to use
file = rtl;

% Plot colour
colour = [0, 0.4470, 0.7410];

% --

% Symbols
s = symbols_unpack(file.z, dab_mode);

% Carriers
c = ofdm_demux(s);

% DQPSK data, unsnapped
d = dqpsk_demap(c, dab_mode);

% DQPSK data, deinterleaved, unsnapped
d_deint = freq_deinterleave(d, build_interleave_map());

% SNAPPED
d_snap = dqpsk_snap(d_deint);

% Plot data before and after snapping
figure(1);
hold off;
plot(d_deint(2,:), 'bo', 'MarkerFaceColor', colour, 'MarkerSize', 7);
hold on;
plot(d_snap(2,:),'rx', 'LineWidth', 4, 'MarkerSize',20);

% Draw lines to show snapping points
x = 10/sqrt(2);
plot([0 x],[0 x],'--r');
plot([0 x],[0 -x],'--r');
plot([0 -x],[0 x],'--r');
plot([0 -x],[0 -x],'--r');
grid on;
xline(0,'k',"Im");
yline(0,'k',"Re");
axis([-1.2 1.2 -1.2 1.2]);

% Plot data across carrier indices
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

% --