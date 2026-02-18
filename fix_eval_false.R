#!/usr/bin/env Rscript
## Fix incorrectly converted eval = FALSE chunks
## Display-only chunks should remain eval = FALSE
## Test harness chunks should have eval = params$mode %in% c("test", "save")

library(here)

qmd_files <- c(
  list.files(file.path(here(), "examples"), pattern = "\\.qmd$",
             full.names = TRUE, recursive = TRUE),
  list.files(file.path(here(), "reference"), pattern = "\\.qmd$",
             full.names = TRUE, recursive = TRUE),
  file.path(here(), "whatsnew.qmd")
)
qmd_files <- qmd_files[file.exists(qmd_files)]

test_harness_pattern <- 'eval = params\\$mode %in% c\\("test", "save"\\)'
test_harness_replacement <- 'eval = params$mode %in% c("test", "save")'

## Test harness content indicators
harness_keywords <- c("saveRDS", "readRDS", "expect_", "testdata_dir",
                       "library(here)", "library(testthat)")

for (f in qmd_files) {
  lines <- readLines(f)
  changed <- FALSE

  ## Find all chunk boundaries
  chunk_starts <- grep("^```\\{r", lines)
  chunk_ends <- grep("^```$", lines)

  for (cs in chunk_starts) {
    ## Check if this chunk has the test harness eval pattern
    if (!grepl(test_harness_pattern, lines[cs], perl = TRUE)) next

    ## Find the matching chunk end
    matching_end <- chunk_ends[chunk_ends > cs][1]
    if (is.na(matching_end)) next

    ## Get chunk content
    if (matching_end > cs + 1) {
      chunk_content <- paste(lines[(cs+1):(matching_end-1)], collapse = "\n")
    } else {
      chunk_content <- ""
    }

    ## Check if this is a test harness chunk
    is_harness <- any(sapply(harness_keywords, function(kw) grepl(kw, chunk_content, fixed = TRUE)))

    if (!is_harness) {
      ## This is a display-only chunk — restore eval = FALSE
      lines[cs] <- gsub(test_harness_pattern, "eval = FALSE", lines[cs], perl = TRUE)
      changed <- TRUE
      cat("  Fixed display chunk at line", cs, "in", basename(f), "\n")
    }
  }

  if (changed) {
    writeLines(lines, f)
  }
}
cat("Done fixing eval = FALSE chunks.\n")
