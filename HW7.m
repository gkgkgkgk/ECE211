% Signals HW7 Gavri Kepets
clc;
clear;
close all;

% constants
M = 100;
K = 10;
L = 3;
N = 200;
PdB = [0,-2,-4]; 
VdB = -15; 

% main
[S, A] = valueGenerator(M, N, K, PdB, VdB);

[U, sval, V] = svd(A);
U = U(:, 1:3);
Ps = U*U.'; 
Pn = eye(size(Ps)) - Ps;

R = (1/N)*A*(A.');
[eigvec, eigval0] = eig(R);
[eigval, idx] = sort(diag(eigval0), 'descend');
eigvec = eigvec(:, idx);

figure();
stem(diag(sval));
title("Singular Values");
ylabel("Magnitudes");

% test vectors
sTestVecs = zeros(M, 20); % preallocate
for l = 1:20
    sTestVecs(:, l) = signalGenerator(M, K);
end

testMusic = zeros(20, 1); % preallocate
testMVDR = zeros(20, 1);
for l = 1:20
    testMusic(l) = Smusic(sTestVecs(:, l), Pn);
    testMVDR(l) = Smvdr(sTestVecs(:, l), R);
end

realMusic = zeros(width(S), 1); % preallocate 
realMVDR = zeros(width(S), 1);
for l = 1:width(S)
    realMusic(l) = Smusic(S(:, l), Pn);
    realMVDR(l) = Smvdr(S(:, l), R);
end

fprintf('Median and Maximum of testMusic: %d %d\n', median(testMusic), max(testMusic))
fprintf('Median and Maximum of realMusic: %d %d\n', median(realMusic), max(realMusic))
fprintf('Median and Maximum of testMVDR: %d %d\n', median(testMVDR), max(testMVDR))
fprintf('Median and Maximum of realMVDR: %d %d\n', median(realMVDR), max(realMVDR))


% Functions
function [S, A] = valueGenerator(M, N, K, PdB, VdB)
    S = zeros(M, length(PdB));
    varPdB = (10.^(PdB./10)).';
    varVdB = (10^(VdB/10));
    
    B = sqrt(varPdB).*randn(length(PdB), N)
    v = sqrt(varVdB)*randn(M, N)
    
    for l = 1:length(PdB)
        S(:, l) = signalGenerator(M, K);
    end
    
    A = S*B + v
end

function X = signalGenerator(M, K)
    X = zeros(M, 1);
    r = randperm(M, K);
    X(r) = 1/(sqrt(K));
end

function out = Smusic(s, Pn)
    out = 1/(s.' * Pn *s);
end

function out = Smvdr(s, R)
    out = 1/(s.' * (R^(-1)) * s);
end