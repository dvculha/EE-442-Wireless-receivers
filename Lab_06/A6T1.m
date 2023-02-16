rng(15)

% Oversampling factor
os_factor    = 4;

% SNR
SNR          = 6;
noAntenna    = 3;
receiverMode = 'MaximumRatioCombining'; % Possible values; singleAntenna / AntennaSelect / MaximumRatioCombining
noframes     = 1;
task         = 2;


load pn_sequence_fading
load ber_pn_seq
ber_pn_seq = repmat(ber_pn_seq,noframes,1);
signal = repmat(signal,noframes,1);
data_length = length(ber_pn_seq)/2;    


symbolsperframe = data_length/noframes;
rxsymbols = zeros(noframes,symbolsperframe);
    
% Loop through all frames
for k=1:noframes
    Frame = signal(k,:);
    
    % Apply Rayleigh Fading Channel
    h = randn(noAntenna,1)+1i*randn(noAntenna,1);
    chanFrame = h * Frame;
    
    % Add White Noise
    SNRlin = 10^(SNR/10);
    noiseFrame = chanFrame + 1/sqrt(2*SNRlin)*(randn(size(chanFrame)) + 1i*randn(size(chanFrame)));

    %
    % Receiver with Single Antenna
    %
    
    for i=1:noAntenna
        % Matched Filter
        filtered_rx_signal(i,:) = matched_filter(noiseFrame(i,:), os_factor, 6); % 6 is a good value for the one-sided RRC length (i.e. the filter has 13 taps in total)

        % Frame synchronization
        [data_idx(i) theta(i) magnitude(i)] = frame_sync(filtered_rx_signal(i,:).', os_factor); % Index of the first data symbol
    end
  

    % Pick correct sampling points of the 1st antenna only
    [rxsymbols(k,:)] = single_solution(filtered_rx_signal,data_idx, os_factor, symbolsperframe, magnitude, theta)  ;             
    
end

combined_rxsymbols = reshape(rxsymbols.',1,noframes*symbolsperframe);
figure
plot(rxsymbols,'.')
