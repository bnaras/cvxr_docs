library(here)
library(fs)

#' Set the rendering parameters for markdowns to be either "test" or
#' "save" or "ignore", the default
#' @description This function exploits `testthat` and parametrized
#'     markdowns to ensure that the `CVXR` documentation examples and
#'     tutorials give expected results. When the mode is `"ignore"`,
#'     the markdowns just render normally; when the mode is `"save"`
#'     the results of running the markdown get saved to
#'     `testdata_dir/data_dir` (where `data_dir` is the
#'     markdown-specific directory); and finally, when the mode is
#'     `"test"`, the generated results in the markdown are tested
#'     against saved results in `testdata_dir/data_dir`. Any
#'     discrepancies will show up as `testthat` failures in the
#'     markdown output. Of course, the markdowns have to be written so
#'     that they behave according to the parameters and execute the
#'     testthat tests.
#' @param mode which should be one of `"ignore"` (default), `"save"`
#'     or `"test"`
#' @param testdata_dir a directory under static directory of the
#'     blogdown site for test data
#'
set_params  <- function(mode = c("ignore", "save", "test"), testdata_dir = "test_data_1.0") {
    mode  <- match.arg(mode)
    rmds  <- list.files(file.path(here(), "content", "cvxr_examples"), pattern = ".Rmd$",
                        full.names = TRUE)
    for (f in rmds) {
        lines  <- readLines(f)
        yaml_range  <- grep("^---", lines)[1:2]
        yaml_lines  <- do.call(seq.int, as.list(yaml_range))
        yaml  <- lines[yaml_lines]
        mode_line  <- grep("^  mode:", yaml)
        yaml[mode_line]  <- paste("  mode:", mode)
        testdata_dir_line  <- grep("^  testdata_dir:", yaml)
        yaml[testdata_dir_line]  <- paste("  testdata_dir:", testdata_dir)
        lines[yaml_lines]  <- yaml
        writeLines(lines, f)
    }
    invisible(TRUE)
}

## For testing use set_mode("test")
##set_params("test")

## For saving use
## set_params("save")

## For publishing use, which is the default, use one of
##set_params("ignore")
## or
set_params()
