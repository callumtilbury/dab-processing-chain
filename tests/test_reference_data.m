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
rtl.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/RTL.dabMeas";
rtl.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/RTL-SDR/RTL.dabRef";

% Perfect Data
perfect.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";
perfect.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/Perfect Data/DAB_7A_188.928.bin";

% Raw Data
raw.dabMeas = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabMeas";
raw.dabRef = "/Volumes/clmtlbry-4/UCT/IV/S/EEE4022S/Data/DAB_data/raw data/DAB_data.dabRef";

%% Actual Test
file = rtl;

X = preprocess(file.dabMeas, "double", 10, 0, 0, mode1, 2.048e6);
X_hat = preprocess(file.dabRef, "double", 10, 0, 0, mode1, 2.048e6);
X_tilde = remodulate(demodulate(X, mode1), mode1);

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

