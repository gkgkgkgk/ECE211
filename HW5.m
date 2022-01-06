clc;
clear;
close all;
%% q3

fp = [12e3, 15e3];
fs = [10e3, 16e3];
rp = 1.5;
rs = 30;
[n, wn] = ellipord(2*pi * fp, 2 * pi * fs, rp, rs, 's');
[z, p, k] = ellip(n, rp, rs, wn, 's');
[b, a] = zp2tf(z, p , k);

figure();
zplane(z, p);
title("Pole-Zero Plot Q3");

figure();
% n is the lowest order elliptic filter that could be made
% nVal is a boolean value that verifies that 2*n is the filter order
nVal = (2 * n == length(p));
disp(nVal);

f = 2 * pi* linspace(0, 20000, 1000);
h = freqs(b, a, f);

l = -30+zeros(1, 1000); l2 = zeros(1, 1000); l3 = -1.5+zeros(1, 1000);

subplot(2,1,1);
plot(f,20*log10(abs(h)), f, l,'--', f, l2, '--', f, l3, '--');
legend({'|H|', '-30dB Stopband', '0dB Passband', '1.5dB Passband'});
title("|H| (db)");
ylim([-60,1]); 

subplot(2,1,2);
plot(f, rad2deg(unwrap(angle(h))));
title("Frequency (degrees)");

% The overdesign here is that it reaches 30dB attenuation faster than
% specifications require (found by plugging in n-1 into the filter)

%% q4

fp = [12e3 15e3];
fs = [10e3 16e3];
rp =1.5;
rs=30; 
fsamp = 40e3; 
[nd,wnd] = ellipord(fp/(fsamp/2),fs/(fsamp/2),rp,rs);
[zd,pd,kd] = ellip(nd,rp,rs,wnd); 
[bd,ad] = zp2tf(zd,pd,kd); 

% 2 * nd is 2 less than 2* n, so nd < n by 1.
disp(2 * nd);

figure();
zplane(zd, pd);
f = 2 * pi * linspace(0, fsamp/2, 1000);
h = freqz(bd, ad, 1000);
title("Pole-Zero Plot Q4");

figure();
subplot(2,1,1);
plot(f,20*log10(abs(h)));
title("|H| (db)");
ylim([-60,1]); 

subplot(2,1,2);
plot(f, rad2deg(unwrap(angle(h))));
title("Frequency (degrees)");