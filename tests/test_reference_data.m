% ---------------------------------------------------------------------    
% TEST_REFERENCE_DATA: Test full chain with reference data
% ---------------------------------------------------------------------

% Constants
dab_mode = load_dab_constants(1);

%% Files

% RTL-SDR
rtl.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/RTL.dabMeas";
rtl.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/RTL.dabRef";

% Perfect Data
perfect.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
perfect.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";

% Raw Data
raw.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabMeas";
raw.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabRef";

%% Actual Test
file = perfect;

X = preprocess(file.dabMeas, "double", 10, 0, 0, dab_mode, 2.048e6);
X_hat = preprocess(file.dabRef, "double", 10, 0, 0, dab_mode, 2.048e6);
X_tilde = remodulate(demodulate(X, dab_mode), dab_mode);

E_R = X_tilde - X_hat;

fprintf("Max Error = %e\n", max(max(E_R)));
fprintf("Error = %.1f%%\n", 100*max(max(E_R))/max(max(X_tilde)));

figure(1);
hold off;
plot(abs(X_tilde));
hold on;
plot(abs(X_hat));
xlabel("Sample Number");
ylabel("Magnitude");
legend("$\mathbf{\tilde{X}}$", "$\mathbf{\hat{X}}$",'Interpreter','latex','FontSize',17);


figure(2);
plot(abs(E_R));
xlabel("Sample Number");
ylabel("Magnitude");

