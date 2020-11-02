% Constants
dab_mode = load_dab_constants(1);

X_in = randn([dab_mode.L, dab_mode.Tu]) + 1j*randn([dab_mode.L, dab_mode.Tu]);
X_out = symbols_unpack(symbols_pack(X_in, dab_mode), dab_mode);

e = X_in - X_out;

fprintf("Max Error = %e\n", sum(sum(e)));