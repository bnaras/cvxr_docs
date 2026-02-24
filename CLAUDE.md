## New website for `cvxr_docs`

- `CVXPY` is a well-established library. Source:  `/Users/naras/GitHub/cvxpy` branch claude.
- `CVXR` is the current (old) R implementation. Source: `/Users/naras/GitHub/CVXR` branch claude
- Old `CVXR` has a number of examples here. Source `/Users/naras/GitHub/cvxr_docs` branch claude.
- New `CVXR` is installed in R currently and is a massive update.
- We now haven initial quarto website here

## TASK

- We would like smaller font size maybe
- We want ggplots for everything, e.g. robust kalman example
- Some code sections were made not executable---this has to be revisited because the older version unintentionally dropped some features
- Notice the testing infrastructure---it has to be kept intact. For now we use `ignore`. 
- Make sure the `cvxr` logo is not dropped

## Update

1. Revert all the changes made from previous commit because `axes` indexing
   was wrong in `CVXR`.  Now it is `axes=1` for rows, `axes=2` for
   columns, exactly like `apply()` in R. The new version is currently
   installed in R.
2. The examples ported from have `Balasubramanian Narasimhan` as
   the sole author. They should state that it is from CVXPY
   developers.
3. With that in mind, **deeply and thoroughly analyze** and present a
   plan to modify everything in this site. This includes function
   documentation etc. 
   
   
