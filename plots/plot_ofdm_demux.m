% ---------------------------------------------------------------------    
% PLOT_OFDM_DEMUX: Plots a demo of OFDM's demulitplexing
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

% Magnitude of carriers
c_mag = 20*log10(abs(c));

% Axes
f_axis = -1023:1024;
s_axis = 1:76;

% Plot a single symbol
figure(1);
plot(f_axis, c_mag(1,:) - max(c_mag(1,:)))
xlim([f_axis(1) f_axis(end)])
ylim([-180, 20]);
xlabel("Frequency [kHz]",'FontSize',15);
ylabel("Magnitude [dB]",'FontSize',15);

% Plot surface of L symbols
figure(2);
S = surf(f_axis, s_axis, c_mag - max(max(c_mag)));
colormap 'white';
S.FaceLighting = 'flat';
S.EdgeAlpha = 1;
S.EdgeColor = colour;
S.EdgeLighting = 'gouraud';
xlim([f_axis(1) f_axis(end)])
ylim([s_axis(1) s_axis(end)])
xlabel("Frequency [kHz]",'FontSize',15);
ylabel("Symbol Index",'FontSize',15);
zlabel("Magnitude [dB]",'FontSize',15);