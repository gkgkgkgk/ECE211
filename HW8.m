% Signals HW8 Gavri Kepets
clc;
clear;
close all;

%% q1

a = 0.544;
N = 10^6;
r = randn(N, 1);

U = rand(N, 1);
x = a * tan(pi .* U);

s = (3/5)*trnd(5, N,1);

figure();
plot(r);
title("Gaussian Distribution");
xlabel("Count");
ylabel("Value");
yline(4);
yline(-4);

subtitle("Fraction of time the absolute value > 4: "+ sum(abs(r) >4)/N);

figure();
plot(x);
title("Cauchy Distribution");
xlabel("Count");
ylabel("Value");
yline(4);
yline(-4);

subtitle("Fraction of time the absolute value > 4: "+ sum(abs(x) >4)/N);


figure();
plot(s);
title("Student Distribution");
xlabel("Count");
ylabel("Value");
yline(4);
yline(-4);

subtitle("Fraction of time the absolute value > 4: "+ sum(abs(s) >4)/N);

%% q2

N = 10^5;
m0 = 5;
num = [2 0.2 -0.84];
den = [1 -0.95 0.9];
noise = randn(N, 1);
x = filter(num, den, noise);

Nlen = 1000;
h = impz(num, den, Nlen);
r = conv(h, flipud(h));
r = r(Nlen:Nlen+m0);

%% q3
figure();
zplane(num, den);
title("Pole-Zero Plot for Filter");

%% q4

c = x(1:m0+1);
r = x(1:N);
A = toeplitz(c, r);

%% q5

R = 1/(N-m0)*A*(A'); % from HW 7
[eigvec, eigval] = eig(R);
[sortedEigVals, inc] = sort(diag(eigval), 'descend');
Q = eigvec(:, inc);

%% q6

[s_est, w] = pwelch(x, hamming(512), 256, 512);
s_est = mag2db(s_est/mean(s_est));
H = freqz(num, den, length(w));
S = abs(H).^2;
S = mag2db(S/mean(S));

figure();
plot(w/pi, s_est);
hold on
plot(w/pi, S);
hold off
title("Normalized Estimate and PSD of x");
legend("s_{est}", "S_x")
xlabel("Digital Frequency")
ylabel("PSD (dB)")

%% q7
[z, p, k] = tf2zpk(num, den);
[M, I] = max(S);
fprintf("Angle of the pole: %.3f. W at max S: %.3f\n", angle(p(1)), w(I))

%% q8

c = flip(x(1:m0+1));
r = x(m0+1: N);
A = toeplitz(c, r);
[U, S, ~] = svd(A, 'econ');
%A = diag(s);

%% q9

QU = abs(Q'*U)
err = QU-eye(m0+1, m0+1);
errmax = max(abs(err(:)));
fprintf("errmax = %f\n", errmax);
