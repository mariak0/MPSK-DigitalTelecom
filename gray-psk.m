% Function to generate M-PSK constellation symbols
generate_symbols = @(M) exp(1j * (2 * pi * (0:M-1) / M + pi/M));

% Function to perform Gray coding for M-PSK
gray_coding = @(symbols, M) mod(floor(symbols / 2) + mod(symbols, 2) * M / 2, M);

% Modulation orders
M_values = [8, 16];

% Loop through each modulation order
for M = M_values
    % Generate symbols without Gray coding
    symbols = generate_symbols(M);

    % Plot constellation without Gray coding
    figure;
    scatter(real(symbols), imag(symbols), 'o');
    title(['M-PSK Constellation (M = ' num2str(M) ') without Gray Coding']);
    xlabel('In-Phase');
    ylabel('Quadrature');
    grid on;
    axis equal;

    % Generate symbols with Gray coding
    gray_symbols = gray_coding(0:M-1, M);
    gray_symbols = generate_symbols(M) .* exp(1j * (pi/M * (gray_symbols')));

    % Plot constellation with Gray coding
    figure;
    scatter(real(gray_symbols), imag(gray_symbols), 'o');
    title(['M-PSK Constellation (M = ' num2str(M) ') with Gray Coding']);
    xlabel('In-Phase');
    ylabel('Quadrature');
    grid on;
    axis equal;
end
