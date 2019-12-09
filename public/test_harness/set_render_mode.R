library(here)
## Modify each markdown rendering mode

#' Set the rendering mode for markdowns to be either "test" or "save"
#' or "ignore", the default
#' @param the mode which should be one of "ignore", "save" or "test"
#'
set_mode  <- function(mode = c("ignore", "save", "test")) {
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
        lines[yaml_lines]  <- yaml
        writeLines(lines, f)
    }
    invisible(TRUE)
}


## For testing use set_mode("test")
## set_mode("test")

## For saving use
## set_mode("save")

## For publishing use, which is the default
set_mode("ignore")
