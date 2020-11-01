% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];

% X -> MAP -> DEMAP -> X

X_in = exp(1j*randn([(mode1.L - 1), mode1.Tu]));
X_out = dqpsk_demap(dqpsk_map(X_in, build_prs(), mode1), mode1);

e = X_in - X_out;

fprintf("Max Error = %e\n", max(max(e(:,mode1.mask))));

% X -> DEMAP -> MAP -> X

prs = build_prs();
X_in_pre    = randn([(mode1.L-1), mode1.Tu]) + 1j*randn([(mode1.L-1), mode1.Tu]);
X_in        = [prs.'; X_in_pre]; 

X_out = dqpsk_map(dqpsk_demap(X_in, mode1), build_prs(), mode1);

e = X_in - X_out;

fprintf("Max Error = %e\n", max(max(e(:,mode1.mask))));


% ALT: X -> DEMAP -> MAP -> X

X_in    = randn([(mode1.L), mode1.Tu]) + 1j*randn([(mode1.L), mode1.Tu]);
X_out = dqpsk_map(dqpsk_demap(X_in, mode1), X_in(1,:), mode1);

e = X_in - X_out;

fprintf("Max Error = %e\n", max(max(e(:,mode1.mask))));