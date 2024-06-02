% Function to generate M-PSK constellation symbols
generate_symbols = @(M) exp(1j * (2 * pi * (0:M-1) / M + pi/M));

% Function to perform Gray coding for M-PSK
gray_coding = @(symbols, M) mod(floor(symbols / 2) + mod(symbols, 2) * M / 2, M);

% Function to calculate theoretical BER for M-PSK modulation
calculate_theoretical_BER = @(EbNo, M) 0.5 * erfc(sqrt(EbNo * log2(M)) * sin(pi/M));

% Function to calculate theoretical SNR for M-PSK modulation
calculate_theoretical_SNR = @(EbNo, M) EbNo * log2(M);

% Desired BER
desired_BER = 1e-6;

% Eb/No values (in dB)
EbNo_dB = 0:1:20;
EbNo = 10.^(EbNo_dB / 10); % Convert to linear scale

% Modulation orders
M_values = [8, 16];

% Loop through each modulation order
for M = M_values
    % Generate symbols without Gray coding
    symbols = generate_symbols(M);

    % Generate symbols with Gray coding
    gray_symbols = generate_symbols(M) .* exp(1j * (pi/M * (gray_coding(0:M-1, M)')));

    % Calculate theoretical BER
    theoretical_BER = calculate_theoretical_BER(EbNo, M);

    % BER calculation for uncoded M-PSK
    BER_uncoded = zeros(size(EbNo));
    for i = 1:length(EbNo)
        noise = 1/sqrt(2) * (randn(1, length(symbols)) + 1j * randn(1, length(symbols))); % AWGN noise
        received_symbols = symbols + sqrt(EbNo(i)) * noise;
        [~, min_indices] = min(abs(received_symbols - symbols.'), [], 1);
        errors = sum(min_indices ~= (0:M-1));
        BER_uncoded(i) = errors / (length(symbols));
    end

    % BER calculation for Gray coded M-PSK
    BER_gray = zeros(size(EbNo));
    for i = 1:length(EbNo)
        noise = 1/sqrt(2) * (randn(1, length(gray_symbols)) + 1j * randn(1, length(gray_symbols))); % AWGN noise
        received_symbols = gray_symbols + sqrt(EbNo(i)) * noise;
        [~, min_indices] = min(abs(received_symbols - symbols.'), [], 1);
        errors = sum(min_indices ~= gray_coding(0:M-1, M));
        BER_gray(i) = errors / (length(gray_symbols));
    end

    % Plot BER curves
    figure;
    semilogy(EbNo_dB, BER_uncoded, 'bo-', 'LineWidth', 1.5);
    hold on;
    semilogy(EbNo_dB, BER_gray, 'rs-', 'LineWidth', 1.5);
    semilogy(EbNo_dB, theoretical_BER, 'k--', 'LineWidth', 1.5);
    grid on;
    xlabel('Eb/No (dB)');
    ylabel('BER');
    title(['Bit Error Rate (BER) for M-PSK Modulation (M = ' num2str(M) ')']);
    legend('Uncoded', 'Gray Coded', 'Theoretical');
    ylim([1e-6 1]);
    xlim([0 20]);
    hold off;
end

% Loop through each modulation order
for M = M_values
    % Generate symbols without Gray coding
    symbols = generate_symbols(M);

    % Generate symbols with Gray coding
    gray_symbols = generate_symbols(M) .* exp(1j * (pi/M * (gray_coding(0:M-1, M)')));

    % Calculate theoretical BER
    theoretical_BER = calculate_theoretical_BER(EbNo, M);

    % Calculate theoretical SNR
    theoretical_SNR = calculate_theoretical_SNR(EbNo, M);

    % SNR calculation for uncoded M-PSK
    SNR_uncoded = 10*log10(1./(theoretical_BER*(2/log2(M))));

    % SNR calculation for Gray coded M-PSK
    SNR_gray = 10*log10(1./(theoretical_BER*(2/log2(M))));

    % Plot SNR curves
    figure;
    plot(EbNo_dB, SNR_uncoded, 'bo-', 'LineWidth', 1.5);
    hold on;
    plot(EbNo_dB, SNR_gray, 'rs-', 'LineWidth', 1.5);
    plot(EbNo_dB, theoretical_SNR, 'k--', 'LineWidth', 1.5);
    grid on;
    xlabel('Eb/No (dB)');
    ylabel('SNR (dB)');
    title(['Signal-to-Noise Ratio (SNR) for M-PSK Modulation (M = ' num2str(M) ')']);
    legend('Uncoded', 'Gray Coded', 'Theoretical');
    xlim([0 20]);
    hold off;

    fprintf('Modulation Order M = %d\n', M);
    fprintf('----------------------------------------------------\n');
    fprintf('Eb/No (dB)\tUncoded SNR (linear)\tUncoded SNR (dB)\tGray Coded SNR (linear)\tGray Coded SNR (dB)\n');
    for i = 1:length(EbNo_dB)
        fprintf('%8.2f\t\t%12.6f\t\t%10.2f\t\t%16.6f\t\t%14.2f\n', EbNo_dB(i), 10^(SNR_uncoded(i)/10), SNR_uncoded(i), 10^(SNR_gray(i)/10), SNR_gray(i));
    end
    fprintf('\n');
end



