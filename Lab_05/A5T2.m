rng(123)
% Oversampling factor
os_factor = 4;

% SNR
SNR = 16;

% Interpolator type
interpolator_type = 'linear';

% transmitter
load task5
data_length = prod(image_size) * 8 / 2; % Number of QPSK data symbols

% convert SNR from dB to linear
SNRlin = 10^(SNR/10);

% add awgn channel
antSig = signal + sqrt(1/(2*SNRlin)) * (randn(size(signal)) + 1i*randn(size(signal)) ); 

% Create phase noise
sigmaDeltaTheta = 0.004;
theta_n = generate_phase_noise_solution(length(antSig), sigmaDeltaTheta);

% Apply phase noise
antSig = antSig.*exp(1j*theta_n);

% Receiver
filtered_rx_signal = matched_filter(antSig, os_factor, 6); % 6 is a good value for the one-sided RRC length (i.e. the filter has 13 taps in total)

% Frame synchronization
[data_idx, theta] = frame_sync(filtered_rx_signal, os_factor); % Index of the first data symbol