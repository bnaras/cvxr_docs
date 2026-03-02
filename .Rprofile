## Project .Rprofile for cvxr_docs
## Restrict CVXR to the four standard solvers (CLARABEL, SCS, OSQP, HIGHS).
## Files that need MOSEK, GUROBI, etc. call include_solvers() explicitly.
setHook(packageEvent("CVXR", "attach"), function(...) {
  std <- c("CLARABEL", "SCS", "OSQP", "HIGHS")
  CVXR::set_excluded_solvers(setdiff(CVXR::installed_solvers(), std))
})
