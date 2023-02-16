load('task2.mat');
SNRdB = 10;
thr = 25;
% distort signal
in_sig = signal + sqrt( 1 / 10^(SNRdB/10) /2) * (randn(size(signal))+1j*randn(size(signal)));
preamble = preamble_gen_solution(100);
preamble_bpsk = -2*(preamble) + 1;
[start] = detector(preamble_bpsk,in_sig, thr)
