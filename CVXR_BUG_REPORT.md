# CVXR S7 Bug Report

**CVXR version:** 0.8.0.9032
**R version:** R version 4.5.2 (2025-10-31)
**Date:** 2026-02-17
**Context:** Porting CVXPY documentation examples to R/CVXR for the new documentation website at `/Users/naras/GitHub/cvxr_docs`

---

## Bug 1: DPP re-solve crashes in `apply_parameters`

**Status:** Fixed

**Severity:** High — this is the core DPP feature (parametric re-solve)

**Reproduction:**

```r
library(CVXR)
set.seed(1)
n <- 10; m <- 5
A <- matrix(rnorm(m * n), m, n)
b <- rnorm(m)

x <- Variable(n)
gamma <- Parameter(nonneg = TRUE)
obj <- Minimize(sum_squares(A %*% x - b) + gamma * p_norm(x, 1))
prob <- Problem(obj)

is_dpp(prob)
#> TRUE

value(gamma) <- 1.0
r1 <- psolve(prob)        # OK — returns 3.621952

value(gamma) <- 2.0
r2 <- psolve(prob)        # CRASHES
```

**Error:**

```
Error in param_prog@c_tensor %*% pv :
  requires numeric/complex matrix/vector arguments
```

**Expected:** The second `psolve()` should reuse the cached compilation and solve with the updated parameter value, returning a different optimal value.

**Impact on docs:** The following files were updated after the fix:

- `examples/dpp/tutorial.qmd` — Re-solve timing demo now fully executable
- `examples/solvers/warm-starts.qmd` — Now uses Parameter + re-solve (not problem reconstruction)
- `examples/machine-learning/lasso.qmd` — Uses DPP re-solve
- `examples/machine-learning/ridge.qmd` — Uses DPP re-solve
- `examples/machine-learning/svm.qmd` — Uses DPP re-solve
- `examples/machine-learning/logistic.qmd` — Uses DPP re-solve
- `examples/derivatives/structured-prediction.qmd` — `generate_data()` re-solves work; still `eval = FALSE` due to Bug 4 (derivatives)

---

## Bug 2: `is_dgp()` not exported and limited to Problem objects

**Status:** Fixed — `is_dgp()` now exported and works on expressions

**Severity:** Medium

### 2a. `is_dgp()` is not exported

```r
library(CVXR)
is_dgp
#> Error: object 'is_dgp' not found

# Works only via triple-colon:
x <- Variable(pos = TRUE)
prob <- Problem(Minimize(x), list(x >= 1))
CVXR:::is_dgp(prob)
#> TRUE
```

**Expected:** `is_dgp()` should be exported, like `is_dcp()`, `is_dpp()`, and `is_dqcp()` are.

### 2b. `is_dgp()` has no method for expressions

```r
library(CVXR)
x <- Variable(pos = TRUE)
y <- Variable(pos = TRUE)
CVXR:::is_dgp(x * y)
#> Error: Can't find method for `is_dgp(<CVXR::Multiply>)`.
```

**Expected:** `is_dgp()` should work on expressions, variables, and parameters — not just Problem/Constraint/Objective objects. CVXPY's `expr.is_dgp()` works on any expression.

**Impact on docs:** All DGP examples now use the exported `is_dgp()` directly:

- `examples/dgp/fundamentals.qmd` — Uses `is_dgp()` on expressions
- `examples/dgp/tutorial.qmd` — Uses `is_dgp(problem)`
- `examples/dgp/max-volume-box.qmd` — Uses `is_dgp(problem)`
- `examples/dgp/power-control.qmd` — Uses `is_dgp(problem)`

---

## Bug 3: `is_log_log_affine()`, `is_log_log_convex()`, `is_log_log_concave()` not exported

**Status:** Fixed — all three functions now exported

**Severity:** Low (if `is_dgp()` on expressions is fixed, these become less important)

```r
library(CVXR)
# All three now exported and work directly:
x <- Variable(pos = TRUE)
is_log_log_affine(x)   #> TRUE
is_log_log_convex(x)   #> TRUE
is_log_log_concave(x)  #> TRUE
```

---

## Bug 4: Derivative/sensitivity API not implemented

**Status:** Deferred — not implemented in CVXR at this time

**Severity:** High — entire CVXPY derivatives tutorial cannot be ported

The following functions do not exist in the CVXR namespace at all:

| Function | CVXPY equivalent | Exists in namespace? |
|----------|-----------------|---------------------|
| `backward()` | `problem.backward()` | No |
| `derivative()` | `problem.derivative()` | No |
| `gradient()` | `param.gradient` | No |
| `delta()` | `param.delta` / `var.delta` | No |

The `requires_grad` parameter to `psolve()` is accepted silently but has no effect (no error, no functionality).

```r
library(CVXR)
# None of these exist:
exists("backward", envir = asNamespace("CVXR"))   #> FALSE
exists("derivative", envir = asNamespace("CVXR")) #> FALSE
exists("gradient", envir = asNamespace("CVXR"))   #> FALSE
exists("delta", envir = asNamespace("CVXR"))      #> FALSE
```

**Impact on docs:** All derivative examples are marked `eval = FALSE` with `callout-warning` notes stating the functionality is not implemented:

- `examples/derivatives/fundamentals.qmd` — All derivative/gradient/backward code
- `examples/derivatives/queuing-design.qmd` — Sensitivity analysis code
- `examples/derivatives/structured-prediction.qmd` — Gradient descent training loop
- `examples/dpp/sensitivity-analysis.qmd` — backward/derivative demos

---

## Bug 5: `length_expr()` not implemented

**Status:** Fixed — `length_expr()` now implemented and exported

**Severity:** Low (only affects one DQCP example)

```r
library(CVXR)
# Now works:
x <- Variable(5)
length_expr(x)
```

In CVXPY, `cp.length(x)` computes the index of the last nonzero element of a vector — a quasiconvex atom used in DQCP problems.

**Impact on docs:**

- `examples/dqcp/min-length-ls.qmd` — Now fully executable

---

## Not bugs, but API discrepancies worth noting

These are not bugs per se — they are design choices where the CVXR API differs from what CVXPY users would expect. We worked around all of these in the docs, but they are worth documenting clearly.

### A. `Variable(n, m)` — second positional arg is `name`, not columns

```r
Variable(3, 4)
#> Error: Variable name "4" must be a string.

# Must use:
Variable(c(3, 4))          # OK
Variable(c(3, 3), symmetric = TRUE)  # OK
```

CVXPY uses `cp.Variable((3, 4))` with a tuple, so the R translation is `Variable(c(3, 4))` — but this is a common mistake when porting.

### B. `reshape_expr(x, n, m)` — second arg must be a vector

```r
x <- Variable(25)
reshape_expr(x, 5, 5)
#> Error: order must be "F" or "C".

# Must use:
reshape_expr(x, c(5, 5))  # OK
```

The second positional arg `5` is interpreted as `order`, not as a second dimension.

### C. `norm(expr, "F")` dispatches to `base::norm`, not CVXR

```r
X <- Variable(c(3, 3))
norm(X, "F")
#> Error: invalid 'x': type "object"
```

CVXR does not export a `norm` generic that handles CVXR expressions. Users must use `p_norm(vec(X), 2)` for Frobenius norm, or `cvxr_norm()` which does work.

### D. MIQP requires commercial solvers

Mixed-integer quadratic programs require GUROBI or CPLEX. Free solvers (GLPK_MI, ECOS_BB, HIGHS) all reject MIQP with:

```
Error: Mixed-integer QP (MIQP) is not supported by the selected solver.
```

This is correctly reported but worth noting in the documentation that MIQP is only available with commercial solver licenses.
