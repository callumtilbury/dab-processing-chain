% ---------------------------------------------------------------------    
% SAMPLE_PR_INTEGRATION: Illustration of PR integration for project
% ---------------------------------------------------------------------

% PARAMETERS
d0 = 30; % km
f0 = -2000; % Hz
sigma = 9;
K = 0.2;

% --
% Constants
dab_mode = load_dab_constants(1);

% Use perfect data file
file_name = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
fs=2.048e6; % Sampling rate
freq=188.928e6; % Centre Frequency
nPulses = 192; % Number of Pulses
nmax = 1;

% Test signal
dab_frame = preprocess(file_name, "double", 10, 1e6, 0, dab_mode, fs);

% Axes
interval = length(dab_frame);
dt = 1/fs;
t = 0:dt:(interval-1)*dt;

% Calculate time delay
t0 = floor(d0/3e8*fs*1e3);

% Echo signal
echo = zeros(size(dab_frame));
echo(t0+1:end) = dab_frame(1:end-t0) .* exp(-1j*(f0*fs/((nPulses^3)/4.2))*t(1:end-t0));

% Gaussian Noise signal
noise = sigma*(randn(size(dab_frame)) + 1j*randn(size(dab_frame)));

% Surveillance channel
s_ch = dab_frame + K*echo + noise;

% Create reference from surveillance
r_ch = remodulate(demodulate(s_ch, dab_mode), dab_mode);

tic(); % Start timer

r = transpose(reshape(r_ch,interval/nPulses,nPulses));     % slice signals into pulses and stack in matrix
s = transpose(reshape(s_ch,interval/nPulses,nPulses));     % lines = slow time (doppler), rows = fast time (delay)
R = fft(r,[],2);    % transform pulses into freq. domain
S = fft(s,[],2);

H = S.*conj(R);     % channel impulse response (CIR) in the freq. domain
h = fftshift(ifft(H,[],2),2);   % CIR (t domain) here, we finished calculation of circular correlation per pulse
caf = fftshift(fft(conj(h(:,floor(size(h,2)/2):end)),[],1),1);
caf = 20*log10(abs(caf));
caf = caf-max(max(caf));

toc(); % Stop timer

% ARD plot
figure(2);
hold off;
dopplerScale = (1:size(caf,1))*fs/(nPulses^2);
dopplerScale = dopplerScale - max(dopplerScale)/2; % Center on zero
delayScale = (1:size(caf,2))/fs*3e8/1e3;
scale = [-50,0];
imagesc(delayScale,dopplerScale,caf,scale)
set(gca,'YDir','normal') % Flip Y axis
shading interp; 
xlabel('Bistatic Range [km]', 'FontSize',15);
ylabel('Doppler Shift [Hz]', 'FontSize',15);
cb = colorbar;
ylabel(cb, "Normalised Power [dB]", 'FontSize',15)
hold on;
plot(d0, f0, 'ro', 'MarkerSize', 50, 'LineWidth', 3)

% Display error between surv and reference
e = r_ch - dab_frame;
fprintf("e = %f\n", abs(max(max(e))));

% Calculate Power values
P_s = sum(abs(dab_frame + K*echo).^2)/length(dab_frame);
P_n = sum(abs(noise).^2)/length(noise); % approx 2*sigma^2
% Display SNR
fprintf("SNR = %fdB\n", 10*log10(P_s/P_n));
