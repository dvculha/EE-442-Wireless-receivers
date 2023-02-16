
rng(32);
% Set parameters
SNR = 10;
os_factor = 4;

% Load image file
load task4.mat

data_length = prod(image_size) * 8 / 2; % Number of QPSK data symbols

% convert SNR from dB to linear
SNRlin = 10^(SNR/10);

% add awgn channel
rx_signal = signal + sqrt(1/(2*SNRlin)) * (randn(size(signal)) + 1i*randn(size(signal)) ); 

% Matched filter
filtered_rx_signal = matched_filter(rx_signal, os_factor, 6); % 6 is a good value for the one-sided RRC length (i.e. the filter has 13 taps in total)

% Frame synchronization
data_idx = frame_sync(filtered_rx_signal, os_factor); % Index of the first data symbol

data = zeros(1,data_length);
data2 = zeros(1,data_length);

cum_err = 0;
diff_err = zeros(1,data_length);
epsilon  = zeros(1,data_length);

for i=1:data_length
    
    idx_start  = data_idx+(i-1)*os_factor;
    idx_range  = idx_start:idx_start+os_factor-1;
    segment    = filtered_rx_signal(idx_range);
    
    % Estimate timing error epsilon
    % TODO
    
    % X(f) = sum of (x[k]* (-j)^k)
    % since (-j)^k only takes values 1 -1j -1 1j
    % for each sample, it contains 4 new terms
    diff_err(i) = [1 -1j -1 1j]*abs(segment).^2;
    
    
    cum_err     = cum_err + diff_err(i);
    epsilon(i)  = -angle(cum_err)/(2*pi);
     
    y_hat = linear_interpolation_solution(epsilon(i), filtered_rx_signal, os_factor, idx_start);
    data(i) = y_hat;
     
     
end

image = image_decoder(demapper(data), image_size);

figure;
plot(1:data_length, epsilon)
imshow(image)
