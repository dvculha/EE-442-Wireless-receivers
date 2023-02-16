rng(159)

% Oversampling factor
param.os_factor    = 4;

% SNR
param.SNR          = 6;
param.noAntenna    = 3;
param.receiverMode = 'MaximumRatioCombining'; % Possible values; singleAntenna / AntennaSelect / MaximumRatioCombining
param.noframes = 1;

load pn_sequence_fading
load ber_pn_seq
ber_pn_seq = repmat(ber_pn_seq,param.noframes,1);
signal = repmat(signal,param.noframes,1);
param.data_length = length(ber_pn_seq)/2;    

combined_rxsymbols = receiver_diversity(signal, param);


rxbitstream = demapper(combined_rxsymbols); % Demap Symbols


BER = sum(rxbitstream ~= ber_pn_seq)/length(ber_pn_seq)