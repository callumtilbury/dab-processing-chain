% ---------------------------------------------------------------------    
% TEST_DQPSK_MAP_DEMAP: DQPSK Map-Demap Inverse test
% ---------------------------------------------------------------------

% Constants
dab_mode = load_dab_constants(1);

% X -> MAP -> DEMAP -> X

X_in = exp(1j*randn([(dab_mode.L - 1), dab_mode.Tu]));
X_out = dqpsk_demap(dqpsk_map(X_in, build_prs(1), dab_mode), dab_mode);

e = X_in - X_out;

fprintf("Max Error = %e\n", max(max(e(:,dab_mode.mask))));

% X -> DEMAP -> MAP -> X

prs = build_prs(1);
X_in_pre    = randn([(dab_mode.L-1), dab_mode.Tu]) + 1j*randn([(dab_mode.L-1), dab_mode.Tu]);
X_in        = [prs; X_in_pre]; 

X_out = dqpsk_map(dqpsk_demap(X_in, dab_mode), build_prs(1), dab_mode);

e = X_in - X_out;

fprintf("Max Error = %e\n", max(max(e(:,dab_mode.mask))));


% ALT: X -> DEMAP -> MAP -> X

X_in    = randn([(dab_mode.L), dab_mode.Tu]) + 1j*randn([(dab_mode.L), dab_mode.Tu]);
X_out = dqpsk_map(dqpsk_demap(X_in, dab_mode), X_in(1,:), dab_mode);

e = X_in - X_out;

fprintf("Max Error = %e\n", max(max(e(:,dab_mode.mask))));