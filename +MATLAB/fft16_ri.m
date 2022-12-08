function [out_re, out_im] = fft16_ri(a_re)
    b_re = zeros(1, 16);
    b_im = zeros(1, 16);
    c_re = zeros(1, 16);
    c_im = zeros(1, 16);
    out_re = zeros(1, 16);
    out_im = zeros(1, 16);
    
    for n = 1:4
        [xr0, xi0, xr1, xi1, xr2, xi2, xr3, xi3] ...
            = butterfly_ri(a_re(n), 0, a_re(n+4), 0, a_re(n+8), 0, a_re(n+12), 0);
        b_re(4*n-3:4*n) = [xr0, xr1, xr2, xr3];
        b_im(4*n-3:4*n) = [xi0, xi1, xi2, xi3];
    end
    
    c_re(1:4)   = [ b_re(1),  b_re(2),  b_re(3),  b_re(4)];
    c_im(1:4)   = [ b_im(1),  b_im(2),  b_im(3),  b_im(4)];
    c_re(5:8)   = [ b_re(5),  -b_im(6),  -b_re(7),  b_im(8)];
    c_im(5:8)   = [ b_im(5),  b_re(6),  -b_im(7),  -b_re(8)];
    c_re(9:12)  = [ b_re(9), -b_re(10), b_re(11), -b_re(12)];
    c_im(9:12)  = [ b_im(9), -b_im(10), b_im(11), -b_im(12)];
    c_re(13:16) = [b_re(13), b_im(14), -b_re(15), -b_im(16)];
    c_im(13:16) = [b_im(13), -b_re(14), -b_im(15), b_re(16)];
    
    for n = 1:4
        pr0 = c_re(n);
        pi0 = c_im(n);
        pr1 = c_re(n+4);
        pi1 = c_re(n+4);
        pr2 = c_re(n+8);
        pi2 = c_im(n+8);
        pr3 = c_re(n+12);
        pi3 = c_im(n+12);
        [xr0, xi0, xr1, xi1, xr2, xi2, xr3, xi3] = ...
            butterfly_ri(pr0, pi0, pr1, pi1, pr2, pi2, pr3, pi3);
        out_re(4*n-3:4*n) = [xr0, xr1, xr2, xr3];
        out_im(4*n-3:4*n) = [xi0, xi1, xi2, xi3];
    end
end