## Canonical solver capabilities table — sourced by index.qmd, whatsnew.qmd,
## and examples/solvers/using-other-solvers.qmd.
##
## Returns a tibble `solver_tbl` with columns:
##   Solver, R package (with HTML links), LP, QP, SOCP, SDP, EXP, MIP

check <- "\U2713"

solver_tbl <- tibble::tibble(
  Solver = c("CLARABEL", "SCS", "OSQP", "HIGHS",
             "ECOS", "ECOS_BB",
             "GLPK", "GLPK_MI",
             "CPLEX", "GUROBI", "MOSEK", "CVXOPT",
             "PIQP", "SCIP", "XPRESS"),
  `R package` = c(
    '<a href="https://clarabel.org">clarabel</a>',
    '<a href="https://cran.r-project.org/package=scs">scs</a>',
    '<a href="https://www.osqp.org">osqp</a>',
    '<a href="https://cran.r-project.org/package=highs">highs</a>',
    '<a href="https://cran.r-project.org/package=ECOSolveR">ECOSolveR</a>',
    '<a href="https://cran.r-project.org/package=ECOSolveR">ECOSolveR</a>',
    '<a href="https://cran.r-project.org/package=Rglpk">Rglpk</a>',
    '<a href="https://cran.r-project.org/package=Rglpk">Rglpk</a>',
    '<a href="https://cran.r-project.org/package=Rcplex">Rcplex</a>',
    '<a href="https://www.gurobi.com">gurobi</a>',
    '<a href="https://docs.mosek.com/latest/rmosek/index.html">Rmosek</a>',
    '<a href="https://cran.r-project.org/package=cccp">cccp</a>',
    '<a href="https://cran.r-project.org/package=piqp">piqp</a>',
    '<a href="https://cran.r-project.org/package=scip">scip</a>',
    '<a href="https://www.fico.com/en/products/fico-xpress-optimization">xpress</a>'),
  LP   = c(check, check, check, check, check, " ", check, check, check, check, check, check, check, check, check),
  QP   = c(check, check, check, check, check, " ", " ", " ", check, check, check, " ", check, " ", check),
  SOCP = c(check, check, " ", " ", check, " ", " ", " ", check, check, check, check, " ", check, check),
  SDP  = c(check, check, " ", " ", " ", " ", " ", " ", " ", " ", check, " ", " ", " ", " "),
  EXP  = c(check, check, " ", " ", check, check, " ", " ", " ", " ", check, " ", " ", " ", " "),
  MIP  = c(" ", check, " ", check, " ", check, " ", check, check, check, check, " ", " ", check, check)
)
