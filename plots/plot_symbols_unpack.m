% ---------------------------------------------------------------------    
% PLOT_SYMBOLS_UNPACK: Plots a demo of symbol unpacking functionality
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

% Axes
fs = 2.048e6;
dt = 1/fs * 1e3;
t = 0:dt:(length(z)-1)*dt;

% Plot symbols with lines superimposed
figure(1);
nn = 7;
hold off;
data = abs(file.z(1:nn*dab_mode.Tu));
t_ = 0:dt:(length(data)-1)*dt;
plot(t_, data);
hold on;
for jj = dab_mode.Tnull:dab_mode.Ts:(nn*dab_mode.Ts)
    xline(jj*dt,'r');
    xline((jj+dab_mode.Tg)*dt,'b');
end
xlim([t_(1) t_(end)]);
xlabel("Time [ms]");
ylabel("Magnitude");

% --