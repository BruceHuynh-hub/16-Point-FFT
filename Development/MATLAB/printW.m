W = exp(-1j*2*pi/16*(0:9));
for N = 1:10
    re = dec2bin(real(W(N))*2^15, 16);
    im = dec2bin(imag(W(N))*2^15, 16);
    %re = round(real(W(N))*2^15);
    %im = round(imag(W(N))*2^15);
    
    %fprintf("N: %d || real(W) = %6d, imag(W) = %6d\n", N-1, re, im);
    fprintf("N: %d || real(W) = %s, imag(W) = %s\n", N-1, re, im);
end