## cvxr_docs testing policy: render/test with free CRAN solvers only.
##
## CVXR auto-selects the highest-priority *available* solver, which on a machine
## that also has commercial solvers installed (MOSEK, GUROBI, CPLEX, SCIP,
## XPRESS) is not reproducible and makes doc regression checks meaningless. We
## therefore exclude the commercial solvers from AUTOMATIC selection whenever
## CVXR loads. This is auto-selection only: a document that explicitly names a
## solver (e.g. solver = "MOSEK") still uses it, because the explicit path
## checks usability, not the exclusion list.
local({
  .cvxr_commercial <- c("MOSEK", "GUROBI", "CPLEX", "SCIP", "XPRESS")
  setHook(
    packageEvent("CVXR", "onLoad"),
    function(...) {
      ns <- asNamespace("CVXR")
      if (exists("set_excluded_solvers", envir = ns, inherits = FALSE)) {
        try(get("set_excluded_solvers", envir = ns)(.cvxr_commercial),
            silent = TRUE)
      }
    }
  )
})
