## Canonical solver-capabilities table — single source of truth, sourced by
## index.qmd and examples/solvers/using-other-solvers.qmd so the two pages can
## never drift apart. Each page supplies its own knitr::kable() styling; this
## file only defines the data frame `solver_tbl`.
##
## Provenance: the capability values are those of the dedicated solver page
## (examples/solvers/using-other-solvers.qmd), the authoritative reference.
## Columns: Solver, R Package (HTML links), LP, QP, SOCP, SDP, EXP, MIP.

check <- "\U2713"

solver_tbl <- tibble::tibble(
    Solver = c("CLARABEL", "SCS", "MOSEK", "ECOS", "ECOS_BB",
               "GUROBI", "GLPK", "GLPK_MI", "HIGHS",
               "CVXOPT", "OSQP", "CPLEX", "PIQP", "SCIP", "XPRESS"),
    `R Package` = c(
        '<a href="https://cran.r-project.org/package=clarabel"><code>clarabel</code></a>',
        '<a href="https://cran.r-project.org/package=scs"><code>scs</code></a>',
        '<a href="https://docs.mosek.com/latest/rmosek/index.html"><code>Rmosek</code></a>',
        '<a href="https://cran.r-project.org/package=ECOSolveR"><code>ECOSolveR</code></a>',
        '<a href="https://cran.r-project.org/package=ECOSolveR"><code>ECOSolveR</code></a>',
        '<a href="https://www.gurobi.com/"><code>gurobi</code></a>',
        '<a href="https://cran.r-project.org/package=Rglpk"><code>Rglpk</code></a>',
        '<a href="https://cran.r-project.org/package=Rglpk"><code>Rglpk</code></a>',
        '<a href="https://cran.r-project.org/package=highs"><code>highs</code></a>',
        '<a href="https://cran.r-project.org/package=cccp"><code>cccp</code></a>',
        '<a href="https://cran.r-project.org/package=osqp"><code>osqp</code></a>',
        '<a href="https://cran.r-project.org/package=Rcplex"><code>Rcplex</code></a>',
        '<a href="https://cran.r-project.org/package=piqp"><code>piqp</code></a>',
        '<a href="https://www.scipopt.org/"><code>scip</code></a>',
        '<a href="https://www.fico.com/en/products/fico-xpress-optimization"><code>xpress</code></a>'),
    LP   = rep(check, 15),
    QP   = c(check, check, check, " ", " ",
             check, " ", " ", check,
             " ", check, check, check, " ", check),
    SOCP = c(check, check, check, check, check,
             check, " ", " ", " ",
             check, " ", check, " ", check, check),
    SDP  = c(check, check, check, " ", " ",
             " ", " ", " ", " ",
             " ", " ", " ", " ", " ", " "),
    EXP  = c(check, check, check, check, check,
             " ", " ", " ", " ",
             " ", " ", " ", " ", " ", " "),
    MIP  = c(" ", " ", " ", " ", check,
             check, " ", check, check,
             " ", " ", check, " ", check, check)
)
