
os_factor = 4;
SNR = 10;

load ./task4

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

cum_err = 0;
diff_err = zeros(1,data_length);
epsilon  = zeros(1,data_length);

for i=1:data_length
    
     idx_start  = data_idx+(i-1)*os_factor;
     idx_range  = idx_start:idx_start+os_factor-1;
     segment    = filtered_rx_signal(idx_range);
    
     % Estimate timing error epsilon

     % Chose best sampling point
     
     % Interpolate linear

     data(i) = ...;
     
end

image_decoder(demapper(data), image_size);