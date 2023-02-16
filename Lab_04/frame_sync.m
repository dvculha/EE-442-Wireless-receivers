
function beginning_of_data = frame_sync(rx_signal, L)

% Frame synchronizer.
% rx_signal is the noisy received signal, and L is the oversampling factor (L=1 in chapter 2, L=4 in all later chapters).
% The returned value is the index of the first data symbol in rx_signal.

if (rx_signal(1) == 0),
    warning('Signal seems to be noise-free. The frame synchronizer will not work in this case.');
    
end

detection_threshold = 15;
frame_sync_length = 100;

% Calculate the frame synchronization sequence and map it to BPSK: 0 -> +1, 1 -> -1
frame_sync_sequence = 1 - 2*lfsr_framesync(frame_sync_length);

% When processing an oversampled signal (L>1), the following is important:
% Do not simply return the index where T exceeds the threshold for the first time. Since the signal is oversampled, so will be the
% peak in the correlator output. So once we have detected a peak, we keep on processing the next L samples and return the index
% where the test statistic takes on the maximum value.
% The following two variables exist for exactly this purpose.
current_peak_value = 0;
samples_after_threshold = L;

corVal = [];
for i = L * frame_sync_length + 1 : length(rx_signal)
    r = rx_signal(i - L * frame_sync_length : L : i - L); % The part of the received signal that is currently inside the correlator.
    c = frame_sync_sequence' * r;
    T = abs(c)^2 / abs(r' * r);
    
    corVal = [corVal T]; 
    
    if (T > detection_threshold || samples_after_threshold < L)
        samples_after_threshold = samples_after_threshold - 1;
        if (T > current_peak_value)
            beginning_of_data = i;
            current_peak_value = T;
        end
        if (samples_after_threshold == 0)
            %display(['Frame starts at ',num2str(beginning_of_data),'th symbol'])
            %plot(corVal,'r-')
            %xlabel('Offset [symbols]')
            %ylabel('Normalized autocorrelation')
            %grid on
            return;
        end
    end
    
end

error('No synchronization sequence found.');
end




function output = lfsr_framesync(output_length)
% A linear feedback shift register (LFSR) which outputs a PN sequence of length output_length.
% The current LFSR has a period length of 255, but the polynomial can easily be changed for a longer one.

% The implementation of this shift register is not very efficient, bit operations would be faster.
% But this version is more readable, so who cares...

% feed back polynomial
% this one here means:
% x^0 + x^2 + x^3 + x^4 + x^8
% The term x^8 is only implicitly given by the length of the polynomial
polynomial = [1 0 1 1 1 0 0 0]';

% All memories are initialized with ones
state = ones(size(polynomial));

output = zeros(output_length, 1);

for i = 1:output_length,
    output(i) = state(1);
    feedback = mod(sum(state .* polynomial), 2);
    state = circshift(state, -1);
    state(end) = feedback;
end
end
