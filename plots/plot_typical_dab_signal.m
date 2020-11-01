% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];


z = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", ...
                "double", 0.25, 1e6, mode1);

fs = 2.048e6;
dt = 1/fs * 1e3;
t = 0:dt:(length(z)-1)*dt;
            
plot(t, abs(z))
% title("Perfect DAB signal showing several frames");
xlabel("Time [ms]")
ylabel("Magnitude")
xlim([t(1) t(end)])

% exportgraphics(gcf,'vectorfig.pdf','ContentType','vector')