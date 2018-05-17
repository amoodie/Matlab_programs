# Matlab and R functions and models repository

This repository contains tools I have written that I frequently use in modeling or calculations. 

It is mostly exceptionally basic functions that either store static but helpful information (e.g., physical constants, color sets) or perform routine operations that are simple but take up a lot of lines of code (i.e., cleans up the workspace).

It also contains a few simple self contained models I have developed.

A summary of _some_ of the functions in here is included. See the file for more documentation.


### categorical2jitterMat.m

`categorical2jitterMat` reshapes data for parallel boxplot-jitterplot.

![jitterexample](./private/jitterplot.png "example of parallel jitter and boxplot") 


### dist2bulk.m

`dist2bulk` calculates the bulk value of a sample given per-class values and a grain size distribution. Output is numeric.
For example, `[bulk] = dist2bulk(dist, val)`


### formatRegression.m

`formatRegression` formats a linearized multivariate regression matrix to a power law regression string.
For example, `formatRegression(beta, {'u_*/w_s', 'Re_p', '1/\alpha'})` returns the string to be formatted with `text` as

![jitterexample](./private/regression.png "regression example")


### get_DSV.m

`get_DSV` is the Dietrich settling velocity (Dietrich, 1982) in m/s for grain size. 
Can handle arbitrary shaped matrix and a Corey shape factor, Power's index and set of physical constants (see `load_conset.m`.


### get_criticalstress.m

`get_criticalstress.m` is the critical stress of grain mobility in Pa.
The result is calculated by the piecewise function fit by Cao, 2006.


### inspire.m

`inspire.m` returns a random inspirational quote when the function is called.
Place it at the beginning of a difficult script to make yourself feel better.


### listing.m
    
`listing.m` gets the listing of all _real_ items in a directory. 
Basically it strips the '.' and '..' folders, with more options.
Optionally will take `'dirsonly'` or `'filesonly'` or if any other string or cell array of strings is given, it returns only files with those extensions.
Returns structure of listing information and filename only listing.


### load_colorSet.m

`load_colorSet.m` holds preset color suites for plotting.


### load_conset.m

`load_conset.m` holds suites of environmental constants for using in modeling in various environments.
For example, 

```
[con] = load_conset('quartz-water')

con = 

  struct with fields:

        g: 9.8100
    rho_f: 1000
    rho_s: 2650
       nu: 1.0040e-06
        R: 1.6500
```


### modelEvalPts.m

`modelEvalPts` calculates evaluation x points xpts from range of xData

`[xpts] = modelEvalPts(xData)` where `xData` is the input x-data for plotting against the model. If `xData` is a matrix, each column is treated as a vector and `xPts` is a matrix of points for each column.
`[xpts] = modelEvalPts(xData, ...)` offers the option to input additional arguments to specify both/either the spacing method and/or the number of points. Spacing options are `'linear'` or `log'` spacing of points; default is linear. Number is any integer > 0.


### sprintsci.m

`sprintsci` prints number in fully formatted scientific notation. 
E.g., `sprintsci(0.0483244)` returns a string `'4.832\times10^{-2}'`.