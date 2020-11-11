% ---------------------------------------------------------------------    
% TEST_REMOD_DEMOD: Remod-Demod Inverse test
% ---------------------------------------------------------------------
% Constants
dab_mode = load_dab_constants(1);

% X -> Remod -> Demod -> X
angles = [-3*pi/4, -pi/4, pi/4, 3*pi/4]; % Restrict possible angle values
angles_all = angles(randi(numel(angles), [(dab_mode.L - 1), dab_mode.K]));
X_in = exp(1j*angles_all);
X_out = demodulate(remodulate(X_in, dab_mode), dab_mode);

% Error
e = X_in - X_out;

% Max error
fprintf("Max Error = %e\n", max(max(e)));
