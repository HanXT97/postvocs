#' Batch process GC-MS TXT files in a directory with sample name mapping
#'
#' Processes all TXT files in a given directory using \code{process_gcms_txt()},
#' maps the raw file names to user-defined sample names via an Excel mapping file,
#' and returns two lists: one containing all PeakTables and one containing all
#' SearchResults, each named by the mapped sample name.
#'
#' @param txt_dir Character. Path to the directory containing the TXT files.
#' @param sample_file Character. Path to an Excel file with two columns:
#'   \code{SampleID} (raw file identifier, e.g., "03") and \code{SampleName}
#'   (user-defined sample name). IDs are automatically formatted to two digits
#'   (e.g., 1 -> "01").
#' @param sheet Integer or character. Sheet name or index in the Excel file.
#'   Default is \code{1} (first sheet).
#' @param pattern Character. Regular expression for file pattern; default
#'   \code{"\\.txt$"}.
#' @param ... Additional arguments passed to \code{process_gcms_txt()}
#'   (e.g., \code{debug = TRUE}). If \code{debug = TRUE} is passed, the
#'   detailed output from \code{process_gcms_txt} will be printed.
#'
#' @return A list with four components:
#'   \item{PeakTables}{A named list of data frames, each representing the
#'         PeakTable of a sample. Names are \code{"SampleName_PeakTable"}.}
#'   \item{SearchResults}{A named list of data frames, each representing the
#'         SearchResults of a sample. Names are \code{"SampleName_SearchResults"}.}
#'   \item{failed_files}{Character vector of raw file names that failed to
#'         process.}
#'   \item{summary}{A data frame with total, success, and failed counts.}
#'
#' @keywords postvocs
#'
#' @importFrom readxl read_excel
#' @importFrom tools file_path_sans_ext
#' @importFrom stats setNames
#' @importFrom utils capture.output
#' @export
#'
#' @examples
#' \dontrun{
#' # Process all .txt files in a folder (quiet mode)
#' result <- batch_process_gcms(
#'   txt_dir = "data-raw/GCMSResults/txt",
#'   sample_file = "data-raw/SampleID.xlsx",
#'   sheet = "Sheet1"
#' )
#'
#' # Process with debug output from process_gcms_txt
#' result <- batch_process_gcms(
#'   txt_dir = "data-raw/GCMSResults/txt",
#'   sample_file = "data-raw/SampleID.xlsx",
#'   debug = TRUE
#' )
#'
#' # Access a specific sample's PeakTable
#' peak_iamf1 <- result$PeakTables[["IAMF1_PeakTable"]]
#' }
batch_process_gcms <- function(txt_dir, sample_file, sheet = 1,
                               pattern = "\\.txt$", ...) {

  # ---- 1. Read sample mapping file ----
  if (!file.exists(sample_file)) {
    stop("sample_file not found: ", sample_file)
  }

  # Read the Excel file, keep only the first two columns and rename them
  # to avoid warnings about empty or duplicate column names.
  raw_map <- readxl::read_excel(sample_file, sheet = sheet)
  if (ncol(raw_map) < 2) {
    stop("Mapping file must contain at least two columns: SampleID and SampleName")
  }
  sample_map <- raw_map[, 1:2]
  names(sample_map) <- c("SampleID", "SampleName")

  # Format SampleID to two-digit character strings
  sample_map$SampleID <- sprintf("%02d", as.numeric(sample_map$SampleID))
  sample_map$SampleID <- as.character(sample_map$SampleID)

  id_to_name <- setNames(sample_map$SampleName, sample_map$SampleID)

  # ---- 2. Get list of files ----
  txt_files <- list.files(path = txt_dir, pattern = pattern, full.names = TRUE)
  if (length(txt_files) == 0) {
    stop("No files matching pattern '", pattern, "' found in ", txt_dir)
  }

  total_files <- length(txt_files)

  # ---- 3. Initialize results ----
  PeakTables <- list()
  SearchResults <- list()
  failed_files <- character(0)
  success_count <- 0
  fail_count <- 0

  # ---- 4. Process each file ----
  for (f in txt_files) {
    raw_id <- tools::file_path_sans_ext(basename(f))

    dots <- list(...)
    debug_flag <- if ("debug" %in% names(dots)) dots$debug else FALSE

    tryCatch({
      # ---- Call process_gcms_txt, suppressing output unless debug=TRUE ----
      if (debug_flag) {
        res <- process_gcms_txt(txt_file = f, ...)
      } else {
        res <- NULL
        capture.output({
          res <- suppressMessages(process_gcms_txt(txt_file = f, ...))
        }, type = "output")
      }

      # ---- Map raw ID to user-defined sample name ----
      if (raw_id %in% names(id_to_name)) {
        sample_name <- id_to_name[[raw_id]]
      } else {
        warning("SampleID '", raw_id, "' not found in mapping file. Using raw ID as fallback.")
        sample_name <- raw_id
      }

      # Extract PeakTable and SearchResults
      peak_idx <- grep("_PeakTable$", names(res), value = TRUE)[1]
      search_idx <- grep("_SearchResults$", names(res), value = TRUE)[1]

      if (is.na(peak_idx) || is.na(search_idx)) {
        stop("PeakTable or SearchResults not found in parsed result")
      }

      peak_df <- res[[peak_idx]]
      search_df <- res[[search_idx]]

      peak_name <- paste0(sample_name, "_PeakTable")
      search_name <- paste0(sample_name, "_SearchResults")
      PeakTables[[peak_name]] <- peak_df
      SearchResults[[search_name]] <- search_df

      success_count <- success_count + 1

      # ---- Print one-line success message ----
      cat("[OK] Successfully processed:", basename(f), "->", sample_name, "\n")

    }, error = function(e) {
      # Print failure message with error details
      cat("[FAIL] Failed to process:", basename(f), "\n")
      cat("  Error:", e$message, "\n")
      failed_files <<- c(failed_files, basename(f))
      fail_count <<- fail_count + 1
    })
  }

  # ---- 5. Print final summary ----
  cat("\n========================================\n")
  cat("Batch processing completed!\n")
  cat("Total files:", total_files, "\n")
  cat("Successfully processed:", success_count, "\n")
  cat("Failed:", fail_count, "\n")

  if (length(failed_files) > 0) {
    cat("\nFailed files:\n")
    print(failed_files)
  }

  # ---- 6. Return invisible list ----
  summary_df <- data.frame(
    total_files = total_files,
    success = success_count,
    failed = fail_count
  )

  invisible(list(
    PeakTables = PeakTables,
    SearchResults = SearchResults,
    failed_files = failed_files,
    summary = summary_df
  ))
}
