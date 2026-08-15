# Regression baselines

Saved results for the example and reference documents, one directory per CVXR
version. Each `<version>/<data_dir>/` holds the `.RDS` files that document
writes in `save` mode and compares against in `test` mode; `<data_dir>` is the
document's own `data_dir` YAML parameter.

```
static/test_data/
  1.8.2/    63 documents   CVXR 1.8.2
  1.9.1/    64 documents   CVXR 1.9.1 + clarabel 0.11.2   (2026-08-14)
```

## Provenance

**A baseline is only meaningful together with the solver that produced it.**
The assertions in these documents run at `tolerance = 1e-10`, and 51 of them are
`expect_identical`, which is far tighter than the difference a solver version
bump can introduce. `1.9.1/` was generated with **clarabel 0.11.2** — the version
on CRAN when CVXR 1.9.1 was current — deliberately, and not with the newer
0.11.3 that may be installed in the default library. Pair them when you
regenerate or the diffs you see will be Clarabel's, not CVXR's.

Determinism also depends on the project `.Rprofile`, which excludes
MOSEK/GUROBI/CPLEX/SCIP/XPRESS from *automatic* solver selection. Without it,
CVXR picks the highest-priority installed solver, and a machine with commercial
solvers produces baselines that no other machine reproduces. A document that
names a solver explicitly still gets it.

## Regenerating, or adding a version

```r
## from the repository root
source("static/test_harness/set_render_mode.R")   # NOTE: sourcing calls set_params()
set_params("save", testdata_dir = "test_data/<version>")
```

then render the documents, then `set_params("ignore")` before committing so the
published site does not carry harness state.

Two things bite:

* **`dir.create()` in the save chunks is NOT recursive.** `static/test_data/<version>/`
  must exist first, or every document errors on its first save.
* **Select the CVXR being tested through the library path, not by installing over
  the default one.** Point `R_LIBS_USER` at a directory holding that CVXR *and*
  its matching clarabel; everything else falls through to the system library.

Render documents one at a time rather than as a whole site when testing: in
`test` mode a failed expectation errors the render, and a site render aborts at
the first error, so you would see only the earliest failure instead of all of
them.

## What differs between versions

`1.8.2` → `1.9.1` differs in 3 of 63 documents, and the reasons are known and
benign. The measurements, and the analysis of each difference, are recorded in
the CVXR development repository at `notes/docs_regression_baselines.md` — not
repeated here, so there is one owner for those numbers.
