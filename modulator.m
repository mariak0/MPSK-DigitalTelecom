function [st] = modulator(sm, M, T_symbol, T_sample, T_c, E_s)
    N = length(sm);
    samples = T_symbol / T_sample;
    st = zeros(N, samples);

    % Calculate Es^1/2 * gT(t)
    Esgt = sqrt(E_s / T_symbol);

    for i = 1:N
        a = sm(i) * 2 * pi / M;  % Adjust the scaling factor
        % For each sm(i), calculate its samples
        for t = 1:samples
            st(i, t) = Esgt * cos(a * t / T_c);
        end
    end
end
