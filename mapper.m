function [sm] = mapper(x, M, isGray)
    N = length(x);
    b = ceil(log2(M));
    rem = mod(N, b);
    
    if (rem ~= 0) 
       % Pad with leading zeros
       x = [zeros(b-rem, 1); x];
    end
    
    % Transform bits to dec 
    sm = bi2de(reshape(x, b, [])', 2, 'left-msb');
    
    % Encode to gray
    if (isGray == 1)
        sm = bin2gray(sm, 'psk', M);
    end
end
