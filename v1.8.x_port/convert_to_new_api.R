#!/usr/bin/env Rscript
## Mechanical conversion of old CVXR API to new S7 CVXR API
## Run from: /Users/naras/research/cvxr/new_design/cvxr_docs_port/

convert_file <- function(infile) {
  lines <- readLines(infile)

  ## 1. Remove add_to_solver_blacklist lines
  lines <- lines[!grepl("add_to_solver_blacklist", lines)]

  ## 2. Remove the test infrastructure blocks (params$mode, here(), testthat saveRDS/readRDS)
  ## These reference external test data dirs that don't exist in our port
  ## We'll strip the eval = params$mode blocks by converting them to eval=FALSE
  lines <- gsub('eval = params\\$mode %in% c\\("test", "save"\\)',
                'eval = FALSE', lines)
  lines <- gsub('error = params\\$mode %in% c\\("test", "save"\\)',
                '', lines)

  ## 3. Remove params from YAML header (mode, testdata_dir, data_dir)
  ## Actually, just leave YAML alone — knitr will use defaults

  ## 4. Convert result$getValue(expr) pattern
  ## Common patterns:
  ##   result$getValue(x)  →  value(x)
  ##   result$getValue(betaHat)  →  value(betaHat)
  ##   result$getValue(X %*% beta)  →  value(X %*% beta)
  ## But variable names for the result object vary: result, soln, res, solution2.1, etc.
  ## Use a regex that captures any $getValue(...) with balanced parens
  ## Simple approach: replace NAME$getValue(STUFF) with value(STUFF)
  lines <- gsub("(\\w[\\w.]*)\\$getValue\\(", "value(", lines, perl = TRUE)

  ## 5. Convert result$value → the stored optimal value
  ## This is trickier because result$value could be on its own line or in sprintf
  ## We'll handle this: after solve(), the return value IS the optimal value
  ## So we need result$value → opt_val (but we also need to capture the solve result)
  ## For now, just replace result$value with value(problem) or similar
  ## Actually, the cleanest approach: keep result <- solve(prob), then replace
  ## result$value with result (since solve() returns the opt value)
  ## But some files use result$status too. Let's do a two-pass:
  ##   - If a line has ONLY result$value (e.g., in sprintf), replace with the var
  ##   - We handle this per-file for complex cases

  ## 6. Convert result$status → problem_status(prob)
  ## This needs to know the problem variable name, handle per-file

  ## 7. Convert result$solve_time → solver_stats(prob)@solve_time
  ## etc.

  ## 8. Replace solver = "ECOS" with solver = "CLARABEL"
  lines <- gsub('solver\\s*=\\s*"ECOS_BB"', 'solver = "HIGHS"', lines)
  lines <- gsub('solver\\s*=\\s*"ECOS"', 'solver = "CLARABEL"', lines)
  lines <- gsub('solver\\s*=\\s*"GLPK_MI"', 'solver = "HIGHS"', lines)
  lines <- gsub('solver\\s*=\\s*"GLPK"', 'solver = "HIGHS"', lines)

  writeLines(lines, infile)
  invisible(NULL)
}

## Apply to all Rmd files in this directory
rmd_files <- list.files(".", pattern = "\\.Rmd$", full.names = TRUE)
for (f in rmd_files) {
  if (basename(f) != "convert_to_new_api.R") {
    cat("Converting:", basename(f), "\n")
    convert_file(f)
  }
}
cat("Done. Manual fixes still needed for per-file special cases.\n")
