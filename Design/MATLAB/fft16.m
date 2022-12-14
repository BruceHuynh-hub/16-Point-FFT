function out = fft16(in)
    b = zeros(1, 16);
    c = zeros(1, 16);
    out = zeros(1, 16);
    
    for n = 1:4
        % 0, 1, 2, 3 <-- 0, 4, 8, 12
        b(4*n-3:4*n) = butterfly([in(n), in(n+4), in(n+8), in(n+12)]);
    end
    
    W = exp(-1j*2*pi/16*(0:9));
    
    c(1:4) = b(1:4);
    c(5:8) = b(5:8) .* W((0:3) + 1);
    c(9:12) = b(9:12) .* W((0:3)*2 + 1);
    c(13:16) = b(13:16) .* W((0:3)*3 + 1);
    
    for n = 1:4
        % 0, 4, 8, 12 <-- 0, 4, 8, 12
        out(n:4:n+12) = butterfly([c(n), c(n+4), c(n+8), c(n+12)]);
    end
end