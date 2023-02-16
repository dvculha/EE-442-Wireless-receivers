rng(112);
rx_filterlen = 20;
[symbol_up, filtered_tx_signal, filtered_rx_signal, sampled_signal, demapped_bits, BER] = a3t2_f(rx_filterlen);