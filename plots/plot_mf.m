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

% iq_data = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", "double", 3, 2e6, mode1);
% iq_data = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 1, 1e6 + 5000, mode1);
iq_data_raw = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin", "short", 10, 0, mode1);
iq_data = iq_resample(iq_data_raw, 2.5e6);

fs = 2.048e6;
dt = 1/fs * 1e3;
t = 0:dt:(length(z)-1)*dt;

prs = build_prs();
% 
% figure(3);
% plot(abs(iq_data));

for jj = 0:10:3000
    iq_data = circshift(iq_data, jj);

    % Move through iq_data, in steps of dab_mode.Tu/2
    % i.e. Advance 1/2 window length on each iteration
    for ii = 1:dab_mode.Tu/2:length(iq_data)
    %     figure(3);
    %     line = xline(ii, 'r');

        mf_data_in = iq_data(ii:ii+dab_mode.Tu-1);

        % Apply matched filter in frequency domain,
        %   using a window length of dab_mode.Tu
        MF_out = conj(prs) .* fftshift(fft(mf_data_in));   
        % Bring back to time
        mf_out = abs(ifft(MF_out));
        % Find max value of mf_out
        [peak_val,peak_idx] = max(mf_out);

        % Check if a peak truly exists by comparing the max to the mean
        %   AND if it is in the first half of the window
        if (peak_val > 50*mean(abs(mf_out)) && peak_idx < dab_mode.Tu/2)

            figure(1);
            subplot(2,1,1);
            plot(abs(mf_data_in));
            xlim([0 2048]);
            xlabel("Sample Number")
            ylabel("Magnitude")

            subplot(2,1,2);
            hold off;
            plot(abs(mf_out));
            hold on;
            plot(peak_idx,peak_val, 'ro');
            xlim([0 2048]);
            ylim([0 peak_val*1.1]);
            xlabel("Sample Number")
            ylabel("Magnitude")

            pause;
            % If so, the phase reference index has been found
            prs_idx = ii + peak_idx - 1;
            break
        end

        delete(line);

    end

end