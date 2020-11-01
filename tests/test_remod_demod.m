% Constants
mode1.K         = 1536;
mode1.L         = 76;
mode1.Tnull     = 2656;
mode1.Tu        = 2048;
mode1.Tg        = 504;
mode1.Ts        = mode1.Tu + mode1.Tg;
mode1.Tf        = mode1.Tnull + mode1.L * mode1.Ts;
mode1.mask      = [257:1024,1026:1793];

% X -> Remod -> Demod -> X
angles = [-3*pi/4, -pi/4, pi/4, 3*pi/4];
angles_all = angles(randi(numel(angles), [(mode1.L - 1), mode1.K]));
X_in = exp(1j*angles_all);

X_out = demodulate(remodulate(X_in, mode1), mode1);

e = X_in - X_out;

fprintf("Max Error = %e\n", max(max(e)));
