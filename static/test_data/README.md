# Regression baselines

Saved results for the example and reference documents, one directory per CVXR
version. Each `<version>/<data_dir>/` holds the `.RDS` files that document
writes in `save` mode and compares against in `test` mode; `<data_dir>` is the
document's own `data_dir` YAML parameter.

```
static/test_data/
  1.8.2/    63 documents   CVXR 1.8.2
  1.9.1/    64 documents   CVXR 1.9.1 + clarabel 0.11.2   (2026-08-14)
  1.9.2/    65 documents   CVXR 1.9.2 + clarabel 0.11.3   (2026-08-22)
```

`1.9.2/` is the set the documents check against: every `.qmd` carries
`testdata_dir: test_data/1.9.2` as of 2026-08-25. It holds 83 `.RDS`, one more
than `1.9.1/` — the extra is `dgp_not_a_gp/not_a_gp1.RDS`, added 2026-08-25
with the `examples/dgp/when-its-not-a-gp.qmd` example, generated under the same
CVXR 1.9.2 + clarabel 0.11.3 pairing and verified by a `test` pass. `1.9.1/`
has no counterpart for it, so that set is now one document short of the
documents in the tree.

Of the 82 shared with `1.9.1/`, the last to be generated was
`dqcp_concave_fractional/concave_fractional1.RDS`, written 2026-08-22
after the document pinned `solver = "SCS"`: with the default solver that
example (`maximize sqrt(x)/exp(x)`) errors with "Max iterations hit during
bisection" — **CVXPY 1.9.1 and 1.9.2 fail identically with their default**,
and CVXR 1.9.1 was the outlier for succeeding. The cause is that bisection's
feasibility subproblems become marginally infeasible near the optimal ratio,
where Clarabel ends in `NumericalError` instead of certifying; SCS and ECOS
certify cleanly. The document now says so.

Verified after generation: a `test` pass against `1.9.2/` renders clean —
71/72 in the bulk run plus the regenerated document individually (its two
`expect_equal` at 1e-10 observed passing in the rendered output). A baseline
set that has not been checked against itself has not been checked.

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
benign. `1.9.1` → `1.9.2` differs more widely — chiefly because 1.9.2 aligns
SCS's acceleration defaults with CVXPY's, which moves numbers at the ~1e-5
level across every SCS document, against assertions written at
`tolerance = 1e-10`. Two further differences are structural rather than drift:

* `dqcp_hypersonic_shape` — the `1.9.1` baseline records **1.3**; the truth is
  **0.14589815**. A DQCP canonicalization fix in 1.9.2 corrected it, so the old
  baseline was recording a wrong answer.
* `linear-program` and `quadratic-program` — `dual_value` changed shape from a
  bare `numeric(n)` to an `n x 1` matrix. This is a FIX: 1.9.1 returned
  `value()` as `n x 1` and duals as a plain vector, which was internally
  inconsistent; 1.9.2 makes duals follow the same 2-D convention. (CVXPY
  returns `(n,)` for both, because numpy is 1-D-native and CVXR is not.)

The measurements, and the analysis of each difference, are recorded in the CVXR
development repository at `notes/docs_regression_baselines.md` and
`notes/docs_baseline_diff_1.9.1_vs_1.9.2.md` — not repeated here, so there is
one owner for those numbers.
