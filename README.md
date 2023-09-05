# Stockwell transform library

This is a small library of functions to implement discrete Stockwell transforms
in Python. Note that the discrete Stockwell transform and orthonormal version of
it are "phase-corrected" versions of Morlet wavelets and harmonic wavelets
respectively.

The Stockwell transform has been used in geophysics, and medical imaging.
However, as I discovered in my Master's research, the only difference form
Morlet wavelets or harmonic wavelets is in the phase. This means that there is
no additional benefit over other wavelet methods, unless the phase information
is used in the subsequent analysis.

These are based on the matlab functions created during my Master's research.
