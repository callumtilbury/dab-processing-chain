% ---------------------------------------------------------------------    
% PLOT_TYPICAL_DAB_SIGNAL: Plots some frames of a DAB signal
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

% Axes
fs = 2.048e6;
dt = 1/fs * 1e3;
t = 0:dt:(length(file.z)-1)*dt;

% Plot sample DAB signal
plot(t, abs(file.z))
xlabel("Time [ms]")
ylabel("Magnitude")
xlim([t(1) t(end)])

% --