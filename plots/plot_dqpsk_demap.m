% ---------------------------------------------------------------------    
% PLOT_DQPSK_DEMAP: Plots a demo of DQPSK outputs
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

% Plot carriers for 1st symbol
figure(1);
    plot(c(1,dab_mode.mask),'bo',   'MarkerFaceColor', colour, ...
                            'MarkerSize',7);
grid on;
xline(0,'k',"Im");
yline(0,'k',"Re");
m = max(abs(c(1,dab_mode.mask))) * 1.1;
axis([-m m -m m]);

% Plot carriers for 2nd symbol
figure(2);
plot(c(2,dab_mode.mask),'bo',   'MarkerFaceColor', colour, ...
                            'MarkerSize',7);
grid on;
xline(0,'k',"Im");
yline(0,'k',"Re");
m = max(abs(c(2,dab_mode.mask))) * 1.1;
axis([-m m -m m]);

% Plot differential phase between carriers
figure(3);
plot(c(2,dab_mode.mask) ./ c(1,dab_mode.mask), ...
                    'bo', 'MarkerFaceColor', colour, ...
                            'MarkerSize',7);
grid on;
xline(0,'k',"Im");
yline(0,'k',"Re");
m = max(abs(c(2,dab_mode.mask) ./ c(1,dab_mode.mask))) * 1.1;
axis([-m m -m m]);

% --