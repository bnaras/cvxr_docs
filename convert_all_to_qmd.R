#!/usr/bin/env Rscript
## Batch convert v1.8.x_port .Rmd files to Quarto .qmd files
## with all API and formatting changes applied

library(here)

## Mapping: source Rmd basename -> target qmd path (relative to project root)
file_map <- list(
  "intro.Rmd"                                    = "examples/intro.qmd",
  "gentle_intro.Rmd"                             = "examples/gentle-intro.qmd",
  "huber-regression.Rmd"                         = "examples/regression/huber-regression.qmd",
  "logistic-regression.Rmd"                      = "examples/regression/logistic-regression.qmd",
  "quantile-regression.Rmd"                      = "examples/regression/quantile-regression.qmd",
  "censored-regression.Rmd"                      = "examples/regression/censored-regression.qmd",
  "isotonic-regression.Rmd"                      = "examples/regression/isotonic-regression.qmd",
  "near-isotonic-and-near-convex-regression.Rmd" = "examples/regression/near-isotonic-and-near-convex-regression.qmd",
  "elastic-net.Rmd"                              = "examples/regression/elastic-net.qmd",
  "pliable-lasso.Rmd"                            = "examples/regression/pliable-lasso.qmd",
  "glmnet_equivalence.Rmd"                       = "examples/regression/glmnet-equivalence.qmd",
  "2d_ball.Rmd"                                  = "examples/misc/2d-ball.qmd",
  "catenary.Rmd"                                 = "examples/misc/catenary.qmd",
  "fast_mixing_mc.Rmd"                           = "examples/misc/fast-mixing-mc.qmd",
  "integer-programming.Rmd"                      = "examples/misc/integer-programming.qmd",
  "portfolio-optimization.Rmd"                   = "examples/finance/portfolio-optimization.qmd",
  "kelly-strategy.Rmd"                           = "examples/finance/kelly-strategy.qmd",
  "direct-standardization.Rmd"                   = "examples/statistics/direct-standardization.qmd",
  "log-concave.Rmd"                              = "examples/statistics/log-concave.qmd",
  "sparse-inverse-covariance-estimation.Rmd"     = "examples/statistics/sparse-inverse-covariance-estimation.qmd",
  "survey_calibration.Rmd"                       = "examples/statistics/survey-calibration.qmd",
  "l1-trend-filtering.Rmd"                       = "examples/signal-processing/l1-trend-filtering.qmd",
  "saturating-hinges.Rmd"                        = "examples/signal-processing/saturating-hinges.qmd",
  "solver-parameters.Rmd"                        = "examples/solvers/solver-parameters.qmd",
  "using-other-solvers.Rmd"                      = "examples/solvers/using-other-solvers.qmd",
  "warm_starts.Rmd"                              = "examples/solvers/warm-starts.qmd",
  "speed.Rmd"                                    = "examples/solvers/speed.qmd",
  "solver-peculiarities.Rmd"                     = "examples/solvers/solver-peculiarities.qmd",
  "dcp.Rmd"                                      = "reference/dcp.qmd",
  "whatsnew.Rmd"                                 = "whatsnew.qmd"
)

## data_dir mapping (for test harness params)
data_dir_map <- list(
  "intro.Rmd"                                    = "intro",
  "gentle_intro.Rmd"                             = "gentle_intro",
  "huber-regression.Rmd"                         = "huber-regression",
  "logistic-regression.Rmd"                      = "logistic-regression",
  "quantile-regression.Rmd"                      = "quantile-regression",
  "censored-regression.Rmd"                      = "censored",
  "isotonic-regression.Rmd"                      = "isotonic-regression",
  "near-isotonic-and-near-convex-regression.Rmd" = "near-iso-regression",
  "elastic-net.Rmd"                              = "elastic-net",
  "pliable-lasso.Rmd"                            = "plasso",
  "glmnet_equivalence.Rmd"                       = "glmnet_equivalence",
  "2d_ball.Rmd"                                  = "2d_ball",
  "catenary.Rmd"                                 = "catenary",
  "fast_mixing_mc.Rmd"                           = "fast-mixing-mc",
  "integer-programming.Rmd"                      = "integer-programming",
  "portfolio-optimization.Rmd"                   = "portfolio-optimization",
  "kelly-strategy.Rmd"                           = "kelly-strategy",
  "direct-standardization.Rmd"                   = "direct-standardization",
  "log-concave.Rmd"                              = "log-concave",
  "sparse-inverse-covariance-estimation.Rmd"     = "sparse_inverse_covariance_estimation",
  "survey_calibration.Rmd"                       = "survey_calibration",
  "l1-trend-filtering.Rmd"                       = "l1-trend-filtering",
  "saturating-hinges.Rmd"                        = "saturating_hinges",
  "solver-parameters.Rmd"                        = "solver-parameters",
  "using-other-solvers.Rmd"                      = "using-other-solvers",
  "warm_starts.Rmd"                              = "warm_starts",
  "speed.Rmd"                                    = "speed",
  "solver-peculiarities.Rmd"                     = "solver-peculiarities",
  "dcp.Rmd"                                      = "dcp",
  "whatsnew.Rmd"                                 = "whatsnew"
)

convert_file <- function(src_basename, dest_relpath, data_dir) {
  src <- file.path(here(), "v1.8.x_port", src_basename)
  dest <- file.path(here(), dest_relpath)

  if (!file.exists(src)) {
    cat("  SKIP (source not found):", src, "\n")
    return(invisible(NULL))
  }

  lines <- readLines(src)

  ## 1. Fix YAML: update testdata_dir, ensure params block is correct
  yaml_ends <- grep("^---", lines)
  if (length(yaml_ends) >= 2) {
    yaml_range <- yaml_ends[1]:yaml_ends[2]
    yaml <- lines[yaml_range]

    ## Update testdata_dir
    yaml <- gsub("testdata_dir: test_data_1.0", "testdata_dir: test_data_1.8", yaml)

    ## Remove slug line
    yaml <- yaml[!grepl("^slug:", yaml)]

    ## Remove date line
    yaml <- yaml[!grepl("^date:", yaml)]

    ## Remove bibliography line (handled at project level)
    yaml <- yaml[!grepl("^bibliography:", yaml)]

    ## Remove link-citations line
    yaml <- yaml[!grepl("^link-citations:", yaml)]

    ## Ensure data_dir is set
    if (!any(grepl("data_dir:", yaml))) {
      ## Add data_dir after testdata_dir
      td_line <- grep("testdata_dir:", yaml)
      if (length(td_line) > 0) {
        yaml <- append(yaml, paste0("  data_dir: ", data_dir), after = td_line[1])
      }
    }

    ## Ensure params block exists
    if (!any(grepl("^params:", yaml))) {
      ## Insert params before closing ---
      insert_at <- length(yaml) - 1
      yaml <- append(yaml, c("params:",
                              "  mode: ignore",
                              paste0("  testdata_dir: test_data_1.8"),
                              paste0("  data_dir: ", data_dir)),
                     after = insert_at)
    }

    ## Reconstruct lines
    lines <- c(yaml, lines[(yaml_ends[2] + 1):length(lines)])
  }

  ## 2. Re-enable test harness chunks
  lines <- gsub('eval = FALSE', 'eval = params$mode %in% c("test", "save")', lines)

  ## 3. Remove add_to_solver_blacklist lines
  lines <- lines[!grepl("add_to_solver_blacklist", lines)]

  ## 4. Replace %>% with |>
  lines <- gsub("%>%", "|>", lines, fixed = TRUE)

  ## 5. Replace %<>% with proper assignment pipe
  ## %<>% is compound assignment — need to restructure manually
  ## For now, leave %<>% as a comment flag
  ## lines <- gsub("%<>%", "|>", lines, fixed = TRUE)  ## manual fix needed

  ## 6. Fix Hugo-style links to relative Quarto links
  lines <- gsub('/cvxr_examples/cvxr_intro/', '../examples/intro.qmd', lines, fixed = TRUE)
  lines <- gsub('/cvxr_examples/cvxr_gentle-intro/', '../examples/gentle-intro.qmd', lines, fixed = TRUE)
  lines <- gsub('/examples/', '../examples/', lines, fixed = TRUE)
  lines <- gsub('/post/cvxr_functions/', '../reference/functions.qmd', lines, fixed = TRUE)
  lines <- gsub('/post/cvxr_dcp/', '../reference/dcp.qmd', lines, fixed = TRUE)
  lines <- gsub('/cvxr_faq/', '../reference/faq.qmd', lines, fixed = TRUE)
  lines <- gsub('/cvxr_dcp/', '../reference/dcp.qmd', lines, fixed = TRUE)
  lines <- gsub('/cvxr_functions/', '../reference/functions.qmd', lines, fixed = TRUE)

  ## Fix cross-links to other examples
  lines <- gsub('/cvxr_examples/cvxr_([^/]+)/', '../examples/\\1.qmd', lines)
  lines <- gsub('/cvxr_examples/whats_new_1.0', '../whatsnew.qmd', lines, fixed = TRUE)

  ## 7. Fix image paths for Quarto (static/ -> /static/ or adjust)
  ## Hugo served static/ at root, Quarto may need different path
  lines <- gsub('\\(/img/', '(/static/img/', lines)

  ## 8. Remove "Source" sections
  source_idx <- grep("^## Source$", lines)
  if (length(source_idx) > 0) {
    ## Remove from ## Source to end or next ## heading
    for (si in rev(source_idx)) {
      next_heading <- which(grepl("^## ", lines[(si+1):length(lines)])) + si
      if (length(next_heading) > 0) {
        end_idx <- next_heading[1] - 1
      } else {
        end_idx <- length(lines)
      }
      lines <- lines[-(si:end_idx)]
    }
  }

  ## 9. Fix solver references that weren't already converted
  lines <- gsub('solver = "ECOS_BB"', 'solver = "HIGHS"', lines, fixed = TRUE)
  lines <- gsub('solver = "ECOS"', 'solver = "CLARABEL"', lines, fixed = TRUE)
  lines <- gsub('solver = "GLPK_MI"', 'solver = "HIGHS"', lines, fixed = TRUE)
  lines <- gsub('solver = "GLPK"', 'solver = "HIGHS"', lines, fixed = TRUE)

  ## Ensure dest directory exists
  dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)

  writeLines(lines, dest)
  cat("  OK:", src_basename, "->", dest_relpath, "\n")
  invisible(NULL)
}

cat("Converting v1.8.x_port files to Quarto .qmd...\n")
for (src_name in names(file_map)) {
  convert_file(src_name, file_map[[src_name]],
               data_dir_map[[src_name]])
}
cat("Done. Manual review needed for edge cases.\n")
