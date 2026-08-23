library(here)
library(fs)

#' Set the rendering parameters for Quarto documents to be either "test" or
#' "save" or "ignore", the default
#' @description This function exploits `testthat` and parametrized
#'     Quarto documents to ensure that the `CVXR` documentation examples and
#'     tutorials give expected results. When the mode is `"ignore"`,
#'     the documents just render normally; when the mode is `"save"`
#'     the results of running the document get saved to
#'     `testdata_dir/data_dir` (where `data_dir` is the
#'     document-specific directory); and finally, when the mode is
#'     `"test"`, the generated results in the document are tested
#'     against saved results in `testdata_dir/data_dir`. Any
#'     discrepancies will show up as `testthat` failures in the
#'     document output. Of course, the documents have to be written so
#'     that they behave according to the parameters and execute the
#'     testthat tests.
#' @param mode which should be one of `"ignore"` (default), `"save"`
#'     or `"test"`
#' @param testdata_dir a directory under the site's static directory
#'     holding baselines for ONE CVXR version, named for that version:
#'     `test_data/1.8.2`, `test_data/1.9.1`, ... For `mode = "test"`
#'     this argument is REQUIRED: name the set you are checking
#'     against. For `mode = "save"` it defaults to a directory named
#'     for the installed CVXR version, which is the set being
#'     produced. For `mode = "ignore"` it is not used and each
#'     document's existing value is left untouched. NOTE that the save-mode chunks in the documents call
#'     `dir.create()` NON-recursively, so `static/<testdata_dir>` must
#'     already exist before a save pass or every save errors.
#'
set_params  <- function(mode = c("ignore", "save", "test"),
                        testdata_dir = NULL) {
    mode  <- match.arg(mode)
    if (is.null(testdata_dir)) {
        if (mode == "test") {
            ## No default on purpose: checking against an unstated baseline
            ## is how a stale default silently tested the wrong version
            ## (the previous hard-coded "test_data/1.9.1"). Say what you
            ## are comparing against.
            stop("mode = \"test\" requires an explicit `testdata_dir` ",
                 "naming the baseline set to check against, e.g. ",
                 "set_params(\"test\", \"test_data/1.9.2\").")
        }
        if (mode == "save") {
            ## Baselines belong to the CVXR that produced them (see
            ## static/test_data/README.md), so the save default is named
            ## for the INSTALLED version.
            testdata_dir  <- file.path(
                "test_data", as.character(utils::packageVersion("CVXR")))
            message("Saving baselines to static/", testdata_dir,
                    " (installed CVXR version)")
        }
        ## mode "ignore": documents never read testdata_dir, so each
        ## file's existing value is left untouched.
    }
    ## Find all .qmd files in the examples/ and reference/ directories
    qmds  <- c(
        list.files(file.path(here(), "examples"), pattern = "\\.qmd$",
                   full.names = TRUE, recursive = TRUE),
        list.files(file.path(here(), "reference"), pattern = "\\.qmd$",
                   full.names = TRUE, recursive = TRUE)
    )
    for (f in qmds) {
        lines  <- readLines(f)
        yaml_range  <- grep("^---", lines)[1:2]
        if (is.na(yaml_range[1]) || is.na(yaml_range[2])) next
        yaml_lines  <- do.call(seq.int, as.list(yaml_range))
        yaml  <- lines[yaml_lines]
        mode_line  <- grep("^  mode:", yaml)
        if (length(mode_line) == 0) next
        yaml[mode_line]  <- paste("  mode:", mode)
        testdata_dir_line  <- grep("^  testdata_dir:", yaml)
        if (!is.null(testdata_dir) && length(testdata_dir_line) > 0) {
            yaml[testdata_dir_line]  <- paste("  testdata_dir:", testdata_dir)
        }
        lines[yaml_lines]  <- yaml
        writeLines(lines, f)
    }
    invisible(TRUE)
}

## For testing use set_params("test")
##set_params("test")

## For saving use
## set_params("save")

## For publishing use, which is the default, use one of
##set_params("ignore")
## or
set_params()
