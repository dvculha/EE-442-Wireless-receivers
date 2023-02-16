function [bit_out, noisy_signal] = awgn_channel(signal, image_size, SNR)
    
    % Convert SNR from dB to linear
    SNRlin = 10^(SNR/10);
    
    % Add AWGN
    noisy_signal = signal + sqrt(1/(2*SNRlin)) * (randn(size(signal)) + 1i*randn(size(signal)) );   
    
    % Demap
    bit_out = demapper(noisy_signal);
    
    % Decode and shown image
    image = image_decoder(bit_out, image_size);
    
end
