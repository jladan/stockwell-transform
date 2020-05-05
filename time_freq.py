"""
Simple implementations of various time frequency transforms.
"""

import numpy as np

# We use some numpy functions so much, that it's useful to have them in this
# module
from numpy import exp, sin, sqrt, pi

def dost_basis(v, b, tau, N):
    """
    Computes the DOST basis vector for a set of parameters
    
    returns:
    --------
    [d1,d2]  
        basis vector of length N, corresponding to parameters v, b, and tau.
        The calculation is done by a linear combination for 'd1' and
        the analytic sum for 'd2'.
    
    NOTES: 
    - for some values of 'b', the analytic sum does not provide the correct values
    - there appears to be a sign or rounding error for d2
    """

    # time index
    k = np.arange(N)

    # calculate basis based on a linear combination 
    #   This is the original definition in Stockwell's paper.
    d1 = np.zeros(N, dtype='complex')
    lower = v - b//2
    for f in range(lower, lower+b):
        d1 += exp(2.j * pi * k * f/N) * np.exp(-2.0j * pi * tau * f/b)
    d1 = d1 * exp(-1j*pi*tau)/sqrt(b)
    
    # calculate the same vector but with analytic sum of the above
    #   Note that this does not work correctly in some cases (eg. b=1)
    d2 = exp(-2j*pi*(k/N - tau/b)*(v-b/2-1/2))
    d2 = d2 - exp(-2j*pi*(k/N - tau/b)*(v+b/2-1/2))
    d2 = d2*1j*exp(-1j*tau*pi) / (sqrt(b)*2*sin(pi*(k/N-tau/b)))

    return d1, d2

def dst(h):
    """
    my own implementation of the Discrete Stockwell Transform
    
    S = dst(h) returns the discrete stockwell transform of the signal H
       This implementation uses a once-folded gaussian window
       S contains both negative and positive frequencies
    """
    N = len(h)
    S = np.zeros((N,N), dtype='complex')

    hhat = np.fft.fft(h)
    hhat = np.hstack((hhat, hhat)) # mimic an N-periodic vector

    # Zero frequency "voice" is the mean sum
    S[N//2, :] = np.sum(h)/N

    for n in range(1, N//2):
        gn = g_window(n, N)
        S[N//2 + n, :] = np.fft.ifft(gn * hhat[n:n+N])
    for n in range(-N//2, 0):
        gn = g_window(n, N)
        S[N//2 + n, :] = np.fft.ifft(gn * hhat[N+n:2*N+n])
    return S

def g_window(n, N):
    """ Create a once-folded gaussian of length N

    This approximates an N-periodic Gaussian bump of width n.
    """
    m = np.arange(N)
    gn = exp(-2*pi**2 * m**2/n**2)
    gn += exp(-2*pi**2 * (m-N)**2/n**2)
    return gn
