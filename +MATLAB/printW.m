for N = 1:10
    re = dec2bin(real(W(N))*2^15, 16);
    im = dec2bin(imag(W(N))*2^15, 16);
    fprintf("N: %d || real(W) = %s, imag(W) = %s\n", N-1, re, im);
end