% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];

%% Files

% RTL-SDR
RTL.path = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin";
RTL.type = "double";
RTL.Fs = 2.048e6;
RTL.frame_count = 15;
RTL.offset = 0;
RTL.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/RTL.dabMeas";
RTL.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/RTL.dabRef";
RTL.symbMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/RTL.symbMeas";
RTL.symbRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/RTL.symbRef";
RTL.frame_offset = 0;

% Perfect Data
perfect.path = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
perfect.type = "double";
perfect.Fs = 2.048e6;
perfect.frame_count = 15;
perfect.offset = 0e6;
perfect.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
perfect.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
perfect.symbMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928_symbols.bin";
perfect.symbRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928_symbols.bin";
perfect.frame_offset = 4;

% Raw Data
raw_data.path = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin";
raw_data.type = "double";
raw_data.Fs = 2.048e6;
raw_data.frame_count = 15;
raw_data.offset = 0;
raw_data.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabMeas";
raw_data.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabRef";
raw_data.dabRef2 = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data_2.dabRef";
raw_data.symbMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.symbMeas";
raw_data.symbRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.symbRef";
raw_data.frame_offset = 0;

% ---------------
% File choice
file = RTL;
% ---------------

for ii = 1:(file.frame_count-1)

    %%  RefBuilder Symbol extract
    symbMeas = iq_read(file.symbMeas, file.type, file.frame_count, file.offset, mode1);
    symbRef = iq_read(file.symbRef, file.type, file.frame_count, file.offset, mode1);

    %% My chain
    dabMeas = preprocess(file.dabMeas, file.type, file.frame_count, file.offset, file.frame_offset, mode1, file.Fs);

    [dabMeas_data, dabMeas_carriers, ~] = demodulate(dabMeas, mode1);

    dabRef_symb = dqpsk_map(freq_interleave(dabMeas_data, build_interleave_map(), mode1), build_prs(), mode1);

    figure(1);
    hold off;
    plot(angle(dabMeas_carriers(ii,mode1.mask)), 'x');
    hold on;
    plot(angle(symbMeas(1+(ii-1)*mode1.K:mode1.K*ii)), 'o');
    title("Measurement Signal");
    
    figure(2);
    hold off;
    plot(angle(dabRef_symb(ii,mode1.mask)), 'x');
    hold on;
    plot(angle(symbRef(1+(ii-1)*mode1.K:mode1.K*ii)), 'o');
    title("Reference Signal");
    
    fprintf("%d\n",ii);
    
    pause;
    
end
