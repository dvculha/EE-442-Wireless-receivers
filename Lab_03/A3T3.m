rng(123)
rx_filterlen_array  = [2 5 7 10 15 20];
for i = 1:length(rx_filterlen_array)
    rx_filterlen = rx_filterlen_array(i);
    [~, ~, ~, ~, ~, BER] = a3t2_f_sol(rx_filterlen);
    ber(i) = BER;
end

target = 7e-3;

best_length = rx_filterlen_array(find(ber - target<0, 1));
display(best_length)

figure
semilogy(rx_filterlen_array,ber,'o-');