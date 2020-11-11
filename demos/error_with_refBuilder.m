
% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];
dab_mode = mode1;

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

% Raw Data
raw_data.path = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin";
raw_data.type = "double";
raw_data.Fs = 2.048e6;
raw_data.frame_count = 10;
raw_data.offset = 0;
raw_data.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabMeas";
raw_data.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabRef";
raw_data.dabRef2 = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data_2.dabRef";
raw_data.symbMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.symbMeas";
raw_data.symbRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.symbRef";

% ---------------
% File choice
file = RTL;
% ---------------

% TEMP: For demo
% warning('off','all')


for ii = 1:(file.frame_count-1)
    %% Preprocess
    dab_frame   = preprocess(file.dabMeas, file.type, file.frame_count, file.offset, ii, mode1, file.Fs);
    
    %% Demoduate
    % SYMBOLS UNPACK
    dab_symbols = symbols_unpack(dab_frame, dab_mode);

    % OFDM MUX
    dab_carriers = ofdm_demux(dab_symbols);
    
    % DQPSK DEMAP
    dab_data_raw = dqpsk_demap(dab_carriers, dab_mode);
    
    % FREQ DEINTERLEAVE
    map = build_interleave_map();
    dab_data_deinterleaved = freq_deinterleave(dab_data_raw, map);

    %% DQPSK SNAP
    dab_data_snapped = dqpsk_snap(dab_data_deinterleaved);
    
    %% ERROR CORRECTION (Not yet implemented)
    dab_data = error_correct(dab_data_snapped);
    
    % [dab_data, ~, dab_data_raw] = demodulate(dab_frame, mode1);
    dab_frame_r = remodulate(dab_data, mode1);

    dab_data_interleaved = freq_interleave(dab_data, build_interleave_map(), mode1);
    
    %% Second time
%     dab_data_2      = demodulate(dab_frame_r, mode1);
%     dab_frame_r2    = remodulate(dab_data_2, mode1);
    
    %% DAB RefBuilder
    ref_frame = preprocess(file.dabRef, file.type, file.frame_count, file.offset, ii, mode1, file.Fs);
    
%     %% DAB RefBuilder Second Time
%     ref_frame_2 = preprocess(file.dabRef2, file.type, file.frame_count, file.offset, ii-1, mode1, file.Fs);

    error = ref_frame - dab_frame_r;
    
    fprintf("Max error = %f\n",max(abs(error)));
    
    %% Plots
    figure(1);
    ha(1) = subplot(3,1,1);
    hold off;
    plot(abs(dab_frame_r));
    hold on;
%     plot(abs(dab_frame_r2));
    plot(abs(ref_frame));
%     plot(abs(ref_frame_2));
    legend({'My Chain I', 'RefBuilder I'},'Location','southwest');
    title("DAB frame")
    xlabel("Sample Number");
    ylabel("Signal Magnitude");
    
    ha(2) = subplot(3,1,2);
    plot(abs(error));
    
    ylim([0 max(abs(dab_frame_r))]);
    title("Error Signal: Magnitude")
    xlabel("Sample Number");
    ylabel("Signal Magnitude");
    
    ha(3) = subplot(3,1,3);
    plot(angle(error));
    linkaxes(ha, 'x');
    title("Error Signal: Phase")
    xlabel("Sample Number");
    ylabel("Signal Phase (radians)");
    
    linkaxes(ha, 'x');
    
    counter = 1;
    
    for jj = (mode1.Tnull):mode1.Ts:(mode1.Tf-mode1.Tnull)
        figure(1);
        subplot(3,1,2);
        x_l = xline(jj,'r');
        x_r = xline(jj+mode1.Ts,'r');
        subplot(3,1,3);
        x_l_ = xline(jj,'r');
        x_r_ = xline(jj+mode1.Ts,'r');
        
        z = dab_frame_r(jj+mode1.Tg:jj+mode1.Ts-1);
        z_ = ref_frame(jj+mode1.Tg:jj+mode1.Ts-1);
        er = error(jj+mode1.Tg:jj+mode1.Ts-1);

        %--------------------
        
        figure(5);
        ha5(1) = subplot(2,1,1);
        hold off;
        plot(20*log10(abs(fftshift(fft(z)))),'-o');
        hold on;
        plot(20*log10(abs(fftshift(fft(z_)))),'-o');
        
        title("OFDM symbol: Magnitude")
        xlabel("Frequency Bin (kHz)");
        ylabel("Magnitude (dB)");
        
        ha5(2) = subplot(2,1,2);
        hold off;
        plot(angle(fftshift(fft(z))),'-o');
        hold on;
        plot(angle(fftshift(fft(z_))),'-o');
        
        title("OFDM symbol: Phase")
        xlabel("Frequency Bin (kHz)");
        ylabel("Angle (radians)");
        
        
        xlim([0 2048]);
        linkaxes(ha5,'x');
        
        %--------------------
        
        figure(6);
        ha6(1) = subplot(2,1,1);
        plot(20*log10(abs(fftshift(fft(er)))));
        
        title("FFT(Error Symbol): Magnitude")
        xlabel("Frequency Bin (kHz)");
        ylabel("Magnitude (dB)");
        
        ha6(2) = subplot(2,1,2);
        hold off;
        plot(angle(dab_data_raw(counter,:)),'o');
        hold on;
        plot(angle(dab_data_interleaved(counter,:)),'x');
        
        yline(-pi,'r');
        yline(-pi/2,'r');
        yline(0,'r');
        yline(+pi/2,'r');
        yline(+pi,'r');

        title("DQPSK Values")
        xlabel("Sample Number");
        ylabel("Angle (radians)");
        
        legend({'Raw', 'Snapped'},'Location','southwest');
        
        counter = counter + 1;
        
        
        xlim([0 2048]);
        linkaxes(ha6,'x');
        
        %--------------------
        
        cmd = input("",'s');
        if (cmd == "n")
            break
        end
        
        delete(x_l);
        delete(x_r);
        delete(x_l_);
        delete(x_r_);
    end
    
end