library(here)
## Modify each markdown rendering mode

#' Set the rendering mode for markdowns to be either "test" or "save" or "ignore"
#' @param the mode which should be one of "ignore", "save" or "test"
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

set_mode("test")
