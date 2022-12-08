function x = butterfly(p)
    %W = exp(-1j*2*pi*(0:3)/4);
    x(1) = p(1) + p(2) + p(3) + p(4);
    x(2) = p(1) - 1j*p(2) - 1*p(3) + 1j*p(4);
    x(3) = p(1) - p(2) + p(3) - p(4);
    x(4) = p(1) + 1j*p(2) - 1*p(3) - 1j*p(4);
end