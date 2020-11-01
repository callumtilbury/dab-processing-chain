% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];


X_in = randn([mode1.L, mode1.Tu]) + 1j*randn([mode1.L, mode1.Tu]);
X_out = symbols_unpack(symbols_pack(X_in, mode1), mode1);

e = X_in - X_out;

fprintf("Max Error = %e\n", sum(sum(e)));