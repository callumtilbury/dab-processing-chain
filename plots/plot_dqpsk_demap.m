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
% raw.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin", "short", 2, 0, 0, mode1, 2.5e6);
rtl.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 2, 0, 0, mode1, 2.048e6);

raw.z = preprocess("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabMeas", "double", 2, 0, 0, mode1, 2.048e6);

perfect.name = "Report/Images/plots/dqpsk_demap_perfect";
raw.name =  "Report/Images/plots/dqpsk_demap_raw";
rtl.name =  "Report/Images/plots/dqpsk_demap_rtl";

file = raw;

s = symbols_unpack(file.z, mode1);
c = ofdm_demux(s);
d = dqpsk_demap(c, mode1);

colour = [0, 0.4470, 0.7410];

% figure(1);
%     plot(c(1,mode1.mask),'bo',   'MarkerFaceColor', colour, ...
%                             'MarkerSize',7);
% grid on;
% xline(0,'k',"Im");
% yline(0,'k',"Re");
% m = max(abs(c(1,mode1.mask))) * 1.1;
% axis([-m m -m m]);
% 
% exportgraphics(gcf, file.name + "-1.pdf");
% 
% figure(2);
% plot(c(2,mode1.mask),'bo',   'MarkerFaceColor', colour, ...
%                             'MarkerSize',7);
% grid on;
% xline(0,'k',"Im");
% yline(0,'k',"Re");
% m = max(abs(c(2,mode1.mask))) * 1.1;
% axis([-m m -m m]);
% 
% exportgraphics(gcf, file.name + "-2.pdf");
% 
% figure(3);
% plot(c(2,mode1.mask) ./ c(1,mode1.mask), ...
%                     'bo', 'MarkerFaceColor', colour, ...
%                             'MarkerSize',7);
% grid on;
% xline(0,'k',"Im");
% yline(0,'k',"Re");
% m = max(abs(c(2,mode1.mask) ./ c(1,mode1.mask))) * 1.1;
% axis([-m m -m m]);
% 
% exportgraphics(gcf, file.name + "-2over1.pdf");


% for ii = 2:6
%     figure(ii);
%     plot(d(ii,:), 'bo', 'MarkerFaceColor', colour, ...
%                                     'MarkerSize',7);
%     grid on;
%     xline(0,'k',"Im");
%     yline(0,'k',"Re");
%     m = 1.8;
%     axis([-m m -m m]);
% 
% %     exportgraphics(gcf, "Report/Images/plots/dqpsk_demap_sample-" + ii + ".pdf");
%     
% end 