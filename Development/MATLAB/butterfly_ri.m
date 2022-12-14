function [xr0, xi0, xr1, xi1, xr2, xi2, xr3, xi3] = ...
    butterfly_ri(pr0, pi0, pr1, pi1, pr2, pi2, pr3, pi3)
    %W = exp(-1j*2*pi*(0:3)/4);
    %x0 = p0 + p1 + p2 + p3;
    xr0 = pr0 + pr1 + pr2 + pr3;
    xi0 = pi0 + pi1 + pi2 + pi3;
    
    %x1 = p0 - 1j*p1 - 1*p2 + 1j*p3;
    xr1 = pr0 + pi1 - pr2 - pi3;
    xi1 = pi0 - pr1 - pi2 + pr3;
    
    %x2 = p0 - p1 + p2 - p3;
    xr2 = pr0 - pr1 + pr2 - pr3;
    xi2 = pi0 - pi1 + pi2 - pi3;
    
    %x3 = p0 + 1j*p1 - 1*p2 - 1j*p3;
    xr3 = pr0 - pi1 - pr2 + pi3;
    xi3 = pi0 + pr1 - pi2 - pr3;
end