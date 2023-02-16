% load shaped symbols
load ./task3.mat
%

SNR           = 10;
rx_filter_len = 2000; % length of receive filter
os_factor     = 400;  % oversampling factor

data_length = prod(image_size) * 8 / 2;

% convert SNR from dB to linear
SNRlin = 10^(SNR/10);

% add awgn channel
rx_signal = signal + sqrt(1/(2*SNRlin)) * (randn(size(signal)) + 1i*randn(size(signal)) ); 

rolloff = 0.22;

[filtered_rx_signal, pulse] = shaped_filtered_detection(rx_signal, rolloff, rx_filter_len, os_factor);

% find start of data frame
beginning_of_data = frame_sync(filtered_rx_signal, os_factor); % Index of the first data symbol

% decode image
image = image_decoder(demapper(filtered_rx_signal(beginning_of_data : os_factor : beginning_of_data + os_factor * (data_length - 1))), image_size);

