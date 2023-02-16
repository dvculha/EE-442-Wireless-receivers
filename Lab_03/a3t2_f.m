function [symbol_up, filtered_tx_signal, filtered_rx_signal, sampled_signal, demapped_bits, BER] = ex3_3_2(rx_filterlen)
    SNR = 8; % dB
    tx_filterlen = 20; % tx_filterlen >= rx_filterlen 14 suffices
    os_factor           = 4;
    
    len  = 1e6;
    % Generate random bitstream
    bitstream = randi([0 1],1,len);
    
    % Convert to QPSK symbols
    bits = 2 * (bitstream - 0.5);
    bits2 = reshape(bits, 2, []);
    
    real_p = ((bits2(1,:) > 0)-0.5)*sqrt(2);
    imag_p = ((bits2(2,:) > 0)-0.5)*sqrt(2);

    symbol = real_p + 1i*imag_p;
    
    % up-sample symbol to signal
    symbol_up = upsample(symbol,os_factor);
    
    % base-band pulse shaping
    rolloff = 0.22;
    pulse = rrc(os_factor,rolloff, tx_filterlen);

    % Shape the symbol diracs with pulse
    filtered_tx_signal = conv(symbol_up,pulse.','full');
    
    % convert SNR from dB to linear
    SNRlin = 10^(SNR/10);
    
    % add AWGN
    rx_signal = filtered_tx_signal + sqrt(1/(2*SNRlin)) * (randn(size(filtered_tx_signal)) + 1i*randn(size(filtered_tx_signal))); 
    
    % base-band pulse shaping
    rolloff = 0.22;
    pulse = rrc(os_factor,rolloff, rx_filterlen);
    
    % filtering
    filtered_rx_signal = conv(rx_signal,pulse.','full');
    
    % downsampling
    % remove 0s
    % (1+tx_filterlen+rx_filterlen:os_factor:end-tx_filterlen-rx_filterlen);
    sampled_signal = filtered_rx_signal(1+tx_filterlen+rx_filterlen:os_factor:end-tx_filterlen-rx_filterlen);
    
    % decode bits
    demapped_bits = demapper(sampled_signal);
    
    % calculate BER
    BER = sum(bitstream ~= demapped_bits.')/len;
    display(BER)
end