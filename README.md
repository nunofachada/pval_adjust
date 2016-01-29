### Summary

MATLAB/Octave function for adjusting p-values for multiple comparisons.
Given a set of p-values, returns p-values adjusted using one of several
methods. This is an implementation of the `p.adjust` R function, the
documentation of which can be found at
http://www.inside-r.org/r-doc/stats/p.adjust.

### Usage

```matlab
pc = pval_adjust([0.1 0.3 0.05 0.001 0.1 0.9 0.0004], 'bonferroni')
```

### Correction methods

'holm', 'hochberg', 'hommel', 'bonferroni', 'BH', 'BY', 'fdr', 'sidak' or
'none'.

### License

[MIT License](LICENSE)

