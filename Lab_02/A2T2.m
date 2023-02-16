load('task2.mat');
SNRdB = 10;
% distort signal
in_sig = signal + sqrt( 1 / 10^(SNRdB/10) /2) * (randn(size(signal))+1j*randn(size(signal)));
%generate preamble bits
preamble = preamble_gen_solution(100);
%map preamble using BPSK
preamble_bpsk = -2*(preamble) + 1;

%correlate signal with preamble
[out_sig, out_sig_norm] = correlator(preamble_bpsk, in_sig);

%plot correlator output
plot(abs(out_sig)),hold on
plot(abs(out_sig_norm))
legend("correlator output","normalized correlator output")


