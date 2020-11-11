% ---------------------------------------------------------------------    
% PLOT_FREQ_DEINTERLEAVE: Plots a demo of the Frequnecy Deinterleaving
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

% DQPSK Data
d = dqpsk_demap(c, dab_mode);

% Deinterleaved data
d_deint = freq_deinterleave(d, build_interleave_map());

% Plot data before and after deinterleaving
figure(1);
plot(angle(d(2,:)), 'o',  'MarkerEdgeColor', colour);
xlim([0 dab_mode.Tu]);
hold on;
plot(dab_mode.mask,angle(d_deint(2,:)),'ro');
xlim([0 dab_mode.Tu]);
legend("dab\_data\_raw","dab\_data\_deint");
xlabel("Carrier Index");
ylabel("Phase [rad]");

% --