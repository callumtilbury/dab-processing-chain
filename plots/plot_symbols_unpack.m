% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];


z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", ...
                "double", 1, 1e6, 0, mode1, 2.048e6);

s = symbols_unpack(z, mode1);

fs = 2.048e6;
dt = 1/fs * 1e3;
t = 0:dt:(length(z)-1)*dt;

figure(10);
nn = 7;
hold off;
data = abs(z(1:nn*mode1.Tu));
t_ = 0:dt:(length(data)-1)*dt;
plot(t_, data);
hold on;
for jj = mode1.Tnull:mode1.Ts:(nn*mode1.Ts)
    xline(jj*dt,'r');
    xline((jj+mode1.Tg)*dt,'b');
end
xlim([t_(1) t_(end)]);
xlabel("Time [ms]");
ylabel("Magnitude");


% for ii = 1:3
%     figure(ii);
%     plot(t(1+(ii-1)*2048:ii*2048), abs(s(ii,:)));
%     xlabel("Time [ms]")
%     ylabel("Magnitude")
%     xlim([t(1+(ii-1)*2048) t(ii*2048)])
%     ylim([0 130])
% end
% exportgraphics(gcf,'vectorfig.pdf','ContentType','vector')