## Canonical solver-capabilities table — single source of truth, sourced by
## index.qmd and examples/solvers/using-other-solvers.qmd so the two pages can
## never drift apart. This file defines the data frame `solver_tbl`, its
## footnote `solver_tbl_note`, and `solver_tbl_html()`, which both pages call
## to render them, so the styling is shared too.
##
## Provenance: measured, not transcribed. Each cell is a named-solver solve
## (`psolve(prob, solver = <name>)`) of a small problem of that class in the
## CVXR 1.9.2.9300 solver-selection matrix (2026-10-15); POW is a genuine
## PowCone3D constraint (power(x, p) with rational p reduces to SOC, so it does
## not test the power cone). A check means the solve returned an optimal status.
## Columns: Solver, R Package (HTML links), LP, QP, SOCP, SDP, EXP, POW, MILP,
## MIQP, MISOCP.

check <- "\U2713"
no <- " "

solver_tbl <- tibble::tibble(
    ## * = commercial, free academic license available (first footnote).
    Solver = c("CLARABEL", "SCS", "MOSEK*", "ECOS", "ECOS_BB",
               "GUROBI*", "GLPK", "GLPK_MI", "HIGHS",
               "CVXOPT", "OSQP", "CPLEX*", "PIQP", "SCIP", "XPRESS*"),
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
    ##          CLARABEL SCS    MOSEK  ECOS   ECOS_BB
    ##          GUROBI   GLPK   GLPK_MI HIGHS
    ##          CVXOPT   OSQP   CPLEX  PIQP   SCIP   XPRESS
    LP     = rep(check, 15),
    QP     = c(check, check, check, check, check,
               check, no,    no,    check,
               check, check, check, check, check, check),
    SOCP   = c(check, check, check, check, check,
               check, no,    no,    no,
               check, no,    check, no,    check, check),
    SDP    = c(check, check, check, no,    no,
               no,    no,    no,    no,
               check, no,    no,    no,    no,    no),
    EXP    = c(check, check, check, check, check,
               no,    no,    no,    no,
               no,    no,    no,    no,    no,    no),
    POW    = c(check, check, check, no,    no,
               no,    no,    no,    no,
               no,    no,    no,    no,    no,    no),
    MILP   = c(no,    no,    check, no,    check,
               check, no,    check, check,
               no,    no,    check, no,    check, check),
    MIQP   = c(no,    no,    check, no,    check,
               check, no,    no,    no,
               no,    no,    check, no,    check, check),
    MISOCP = c(no,    no,    check, no,    check,
               check, no,    no,    no,
               no,    no,    check, no,    check, check)
)

solver_tbl_note <- c(
    "* Commercial solver; free academic licenses are available.",
    "QP: solvers with a quadratic-objective interface receive the objective directly; the other conic solvers solve a second-order-cone reformulation.",
    "Without a commercial solver, mixed-integer problems can use HIGHS or GLPK_MI (MILP only), SCIP (MILP, MIQP, MISOCP) or ECOS_BB.",
    "ECOS_BB is used only when named, as in psolve(prob, solver = \"ECOS_BB\").",
    "Smooth nonlinear programs, psolve(prob, nlp = TRUE), use the separate NLP solvers Uno or IPOPT; see Using Other Solvers."
)

## Render the table inside a horizontally scrollable `div.solver-table`
## (styles.css keeps cells from wrapping). The notes go in a block below the
## table rather than in kableExtra::footnote(): Quarto re-parses kable HTML and
## drops that footer's colspan, squeezing every note into the first column.
solver_tbl_html <- function(caption = NULL) {
    tbl <- knitr::kable(solver_tbl, format = "html", escape = FALSE,
                        caption = caption) |>
        kableExtra::kable_styling("striped") |>
        kableExtra::column_spec(seq_along(solver_tbl), background = "#ececec")
    notes <- paste0("<p>", htmltools::htmlEscape(solver_tbl_note), "</p>",
                    collapse = "\n")
    knitr::asis_output(paste0(
        '<div class="solver-table">\n', tbl, "\n</div>\n",
        '<div class="solver-table-note">\n', notes, "\n</div>\n"))
}
