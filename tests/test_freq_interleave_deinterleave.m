% ---------------------------------------------------------------------    
% TEST_FREQ_INTERLEAVE_DEINTERLEAVE: Freq int/deint Inverse test
% ---------------------------------------------------------------------
% Constants
dab_mode = load_dab_constants(1);

% X -> Interleave -> Deinterleave -> X
X_in = randn([(dab_mode.L - 1), dab_mode.K]) + 1j*randn([(dab_mode.L - 1), dab_mode.K]);
X_out = freq_deinterleave(freq_interleave(X_in, build_interleave_map(), dab_mode), build_interleave_map());

e = X_in - X_out;

fprintf("Max Error = %e\n", max(max(e)));