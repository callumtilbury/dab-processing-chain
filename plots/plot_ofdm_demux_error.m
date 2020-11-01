% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];


z = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", "double", 1, 1e6, mode1);
% z = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 1, 1e6, mode1);

prs = prs_detect(z, build_prs(), mode1);

% z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", "double", 2, 1e6, 0, mode1, 2.048e6);
% z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin", "short", 2, 0, 0, mode1, 2.5e6);
% z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 2, 0, 0, mode1, 2.048e6);

dab_mode = mode1;

% Read symbols from each frame
s = zeros(dab_mode.L, dab_mode.Tu);

% Start after null & first guard interval
% Note: If misaligned _earlier_ is okay, but cannot be later! (Because
% of cyclic guard interval with cyclic prefix)
ii = prs + 1;

for l = 1:dab_mode.L
    % Read symbol
    s(l,:) = z(ii:ii+dab_mode.Tu-1);
    % Jump ahead 1 symbol, incl. guard
    ii = ii + dab_mode.Ts;
end

c = ofdm_demux(s);
c_mag = 20*log10(abs(c));

d = dqpsk_demap(c, mode1);

f_axis = -1023:1024;
s_axis = 1:76;

figure(1);
plot(f_axis, c_mag(1,:) - max(c_mag(1,:)))
xlim([f_axis(1) f_axis(end)])
ylim([-180, 20]);
xlabel("Frequency [kHz]",'FontSize',15);
ylabel("Magnitude [dB]",'FontSize',15);

figure(2);
plot(f_axis, angle(c(1,:)),'o')
xlim([f_axis(1) f_axis(end)])
xlabel("Frequency [kHz]",'FontSize',15);
ylabel("Phase [rad]",'FontSize',15);
% 
colour = [0, 0.4470, 0.7410];

fig = figure(3);
% fig.Renderer='Painters';
S = surf(f_axis, s_axis, c_mag - max(max(c_mag)));
colormap 'white';
% S.FaceColor = 'blue';
S.FaceLighting = 'flat';
S.EdgeAlpha = 1;
S.EdgeColor = colour;
S.EdgeLighting = 'gouraud';
xlim([f_axis(1) f_axis(end)])
ylim([s_axis(1) s_axis(end)])
% zlim([-140 5]);
xlabel("Frequency [kHz]",'FontSize',15);
ylabel("Symbol Index",'FontSize',15);
zlabel("Magnitude [dB]",'FontSize',15);

figure(4);
plot(d(2,:),'o')

% print -dpdf surf.pdf

% fs = 2.048e6;
% dt = 1/fs * 1e3;
% t = 0:dt:(length(z)-1)*dt;
% 
% exportgraphics(gcf,'vectorfig.pdf','ContentType','image')
% exportgraphics(gcf,'vectorfig.png','ContentType','image')