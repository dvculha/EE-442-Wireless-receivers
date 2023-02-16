SNR_range = -6:2:12;
L = 1e4;

rng(123)

% Initialize
BER_list_Gray = zeros(size(SNR_range));
BER_list_NonGray = zeros(size(SNR_range));
    
% Gray mapping (Symbols, normalized)
GrayMap = 1/sqrt(2) * [(-1-1j) (-1+1j) ( 1-1j) ( 1+1j)];

% Non-Gray mapping (Symbols, normalized)
NonGrayMap = 1/sqrt(2) * [( 1-1j) ( 1+1j) (-1+1j) (-1-1j)];
    
for ii = 1:numel(SNR_range) 
    % Convert SNR from dB to linear
    SNRlin = 10^(SNR_range(ii)/10);
    
    % Generate source bitstream
    source = randi([0 1],L,2);
       
    % Map input bitstream using Gray mapping
    mappedGray = GrayMap(bi2de(source, 'left-msb')+1).';
    if ii == 1
        mappedGray_record = mappedGray;
    end
      
    % Add AWGN
    mappedGrayNoisy = add_awgn_solution(mappedGray, SNRlin);
        
    % Demap
    [~,ind] = min((ones(L,4)*diag(GrayMap) - diag(mappedGrayNoisy)*ones(L,4)),[],2);
    demappedGray = de2bi(ind-1, 'left-msb');
    if ii == 1
        demappedGray_record = demappedGray;
    end
        
    % BER calculation for Gray mapping
    BER_list_Gray(ii) = mean(source(:) ~= demappedGray(:));
        
    % Map input bitstream using non-Gray mapping
    mappedNonGray = NonGrayMap(bi2de(source, 'left-msb')+1).';
    if ii == 1
        mappedNonGray_record = mappedNonGray;
    end
          
    % Add AWGN
    mappedNonGrayNoisy = add_awgn_solution(mappedNonGray, SNRlin);
        
    % Demap
    [~,ind] = min((ones(L,4)*diag(NonGrayMap) - diag(mappedNonGrayNoisy)*ones(L,4)),[],2);
    demappedNonGray = de2bi(ind-1, 'left-msb');
    if ii == 1
        demappedNonGray_record = demappedNonGray;
    end
        
    % BER calculation for Gray mapping
    BER_list_NonGray(ii) = mean(source(:) ~= demappedNonGray(:));
end

% graphical ouput
figure;
semilogy(SNR_range, BER_list_Gray, 'bx-' ,'LineWidth',3);
hold on
semilogy(SNR_range, BER_list_NonGray, 'r*--','LineWidth',3);
xlabel('SNR (dB)')
ylabel('BER')
legend('Gray Mapping', 'Non-Gray Mapping')
grid on