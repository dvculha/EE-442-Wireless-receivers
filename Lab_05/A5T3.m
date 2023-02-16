rng(21)

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
% TODO 1:

%5.5 antSig[n] = antSig[n]*exp(j theta[n]
antSig = antSig.*exp(1i*theta_n);

% Receiver
filtered_rx_signal = matched_filter(antSig, os_factor, 6); % 6 is a good value for the one-sided RRC length (i.e. the filter has 13 taps in total)

% Frame synchronization
[data_idx, theta] = frame_sync_solution(filtered_rx_signal, os_factor); % Index of the first data symbol
data_idxInit = data_idx;

payload_data = zeros(data_length, 1); % The payload data symbols
payload_data_no_filter = zeros(data_length, 1); % The payload data symbols

eps_hat = zeros(data_length, 1);     % Estimate of the timing error
theta_hat = zeros(data_length+1, 1);   % Estimate of the carrier phase
theta_hat_no_filter = zeros(data_length+1, 1);

theta_hat(1) = theta;
theta_hat_no_filter(1) = theta;


% Loop over the data symbols with estimation and correction of the timing
% error and phase
for k = 1 : data_length
    
    % timing estimator
    eps_hat(k) = timing_estimator(filtered_rx_signal(data_idx : data_idx + os_factor - 1), k == 1);
    opt_sampling_inst = eps_hat(k) * os_factor;
    
    switch interpolator_type
        case 'none'
            payload_data(k) = filtered_rx_signal(data_idx + round(opt_sampling_inst));
            
        case 'linear'
            y = filtered_rx_signal(data_idx + floor(opt_sampling_inst) : data_idx + floor(opt_sampling_inst) + 1);
            payload_data(k) = linear_interpolator(y, opt_sampling_inst - floor(opt_sampling_inst));
            
        case 'cubic'
            y = filtered_rx_signal(data_idx + floor(opt_sampling_inst) - 1 : data_idx + floor(opt_sampling_inst) + 2);
            payload_data(k) = cubic_interpolator(y, opt_sampling_inst - floor(opt_sampling_inst));
            
        otherwise
            error('Unknown interpolator_type.');
    end
    
    % Phase estimation    
    %TODO 2 : viterbi - viterbi on payload data
    %5.6 - 5.8
    % L = (-1,0,1,2,3,4)
    deltaTheta = 1/4*angle(-payload_data(k)^4) + pi/2*(-1:4);

     % Unroll phase
    [~, ind] = min(abs(deltaTheta - theta_hat_no_filter(k)));
    theta_no_filter = deltaTheta(ind);
   
    [~, ind] = min(abs(deltaTheta - theta_hat(k)));
    theta = deltaTheta(ind);
   
    theta_hat_no_filter(k+1) = mod(theta_no_filter, 2*pi);

    % Lowpass filter phase
    theta_hat(k+1) = mod(0.01*theta + 0.99*theta_hat(k), 2*pi);
    
    % Phase correction
    payload_data_no_filter(k) = payload_data(k) * exp(-1j * theta_hat_no_filter(k+1));   % ...and rotate the current symbol accordingly
    payload_data(k) = payload_data(k) * exp(-1j * theta_hat(k+1));
    
    data_idx = data_idx + os_factor;

    
  end

% Plot phase
figure(1),
subplot(1,2,1)
plot(theta_n(data_idxInit:os_factor:end), 'r','linewidth',3)
hold on
plot(theta_hat_no_filter, 'b-')
a = axis;
a(3:4) = [0,2*pi];
axis(a)
set(gca,'ytick',0:pi/4:2*pi)
grid on;
legend("Reference Phase Noise","Estimated Phase Noise w/o Filtering")
title("Phase Estimate w/o Filtering")

% Plot phase
subplot(1,2,2)
plot(theta_n(data_idxInit:os_factor:end), 'r','linewidth',3)
hold on
plot(theta_hat, 'b-')
a = axis;
a(3:4) = [0,2*pi];
axis(a)
set(gca,'ytick',0:pi/4:2*pi)
grid on;
legend("Reference Phase Noise","Estimated Phase Noise w/ Filtering")
title("Phase Estimate w/ Filtering")
% Draw image
figure(3)
subplot(1,2,1)
image_no_filter = image_decoder(demapper(payload_data_no_filter), image_size);
imshow(image_no_filter/255);
title("Recovered Image w/o Filtering")

subplot(1,2,2)
image = image_decoder(demapper(payload_data), image_size);
imshow(image/255);
title("Recovered Image w/ Filtering")