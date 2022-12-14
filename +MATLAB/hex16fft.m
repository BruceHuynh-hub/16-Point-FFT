A = ([13 14 15 16 0 0 0 0 0 0 0 0 0 0 0 0]).^2*10;
F = fft(A);

for n = 1:16
    fprintf("r%X=%04X i%X=%04X\n", n-1, shortTwos(real(F(n))), n-1, shortTwos(imag(F(n))));
end

function n = shortTwos(n)
    n = round(n);
    if n < 0
        n = 2^16 + n;
    end
end