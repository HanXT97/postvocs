## Test environments
- local Windows 11, R 4.5.3
- win-builder (R Under development, 2026-11-01 r91000)
- ubuntu 20.04 (via GitHub Actions)
- macOS 26.5.2 (via GitHub Actions)

## R CMD check results
There were no ERRORs or WARNINGs.

Notes:
- checking for non-standard things in the check directory ... NOTE
  Found the following files/directories: ''NULL''
  This is a benign temporary file from the checking process and can be safely ignored.

## Downstream dependencies
There are no downstream dependencies.

## Submission comments
This is a resubmission of postvocs 0.2.6, which adds a new argument and enhances summary statistics in `filter_by_frequency()`.

Changes in this version (0.2.6) relative to 0.2.5:
- Added `remove_blank_compounds` argument to `filter_by_frequency()` (default `FALSE`). When `TRUE`, compounds detected in blank samples are removed from all samples and flagged as `Removed_in_Blank = "-"`. When `FALSE`, blanks are only excluded from frequency calculations and no compounds are removed.
- Enhanced summary statistics to report blank-compound removal mode, number of blank samples, and number of samples used for frequency calculation.
- Updated documentation and added a second example demonstrating blank-compound removal.

All examples remain self-contained and executable without network access. The package passes `R CMD check --as-cran` with no errors or warnings.
