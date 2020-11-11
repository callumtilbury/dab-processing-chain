% ---------------------------------------------------------------------    
% PLOT_MF_DEMO: Plots a demo of the MF functionality
% ---------------------------------------------------------------------
% Constants
dab_mode = load_dab_constants(1);

% File locations
perfect.z = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin", "double", 1, 1e6, dab_mode);
raw.z = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.bin", "short", 2, 0, dab_mode);
raw.z = iq_resample(raw.z, 2.5e6); % Raw data not sampled at 2.048MHz
rtl.z = iq_read("/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/DAB.bin", "short", 2, 0, dab_mode);

% Choose which file to use
file = rtl;

% Time axis
fs = 2.048e6;
dt = 1/fs * 1e3;
t = 0:dt:(length(file.z)-1)*dt;

% Phase Reference
prs = build_prs(1);

% Plot full signal
figure(3);
plot(abs(iq_data));

% Move through iq_data, in steps of dab_mode.Tu/2
% i.e. Advance 1/2 window length on each iteration
for ii = 1:dab_mode.Tu/2:length(iq_data)
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

        figure(3);
        xline(ii, 'r');
        xline(ii+dab_mode.Tu, 'r');
        
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

        % If so, the phase reference index has been found
        prs_idx = ii + peak_idx - 1;
        break
    end

end