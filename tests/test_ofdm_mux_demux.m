% Constants
dab_mode = load_dab_constants(1);

% X -> OFDM Mux -> OFDM Demux -> X
X_in = randn([dab_mode.L, dab_mode.Tu]) + 1j*randn([dab_mode.L, dab_mode.Tu]);
X_out = ofdm_demux(ofdm_mux(X_in));

e = X_in - X_out;

fprintf("Max Error = %e\n", sum(sum(e)));

% X -> OFDM Demux -> OFDM Mux -> X
X_in = randn([dab_mode.L, dab_mode.Tu]) + 1j*randn([dab_mode.L, dab_mode.Tu]);
X_out = ofdm_mux(ofdm_demux(X_in));

e = X_in - X_out;

fprintf("Max Error = %e\n", sum(sum(e)));