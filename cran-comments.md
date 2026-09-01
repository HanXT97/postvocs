## Test environments
- local Windows 11, R 4.5.3
- win-builder (R Under development, 2026-08-30 r90397)
- ubuntu 20.04 (via GitHub Actions)
- macOS 26.5.2 (via GitHub Actions)

## R CMD check results
There were no ERRORs or WARNINGs.

Notes:
- checking CRAN incoming feasibility ... NOTE
  Possibly misspelled words in DESCRIPTION: CAS, GC, Shimadzu, metabolomics, spectrometry
  These are standard technical terms. The DESCRIPTION includes `Language: en-US` to address this.

- checking top-level files ... NOTE
  Non-standard file/directory found at top level: 'LICENSE.md'
  The LICENSE file is standard GPL-3 and this note is benign.

- checking for non-standard things in the check directory ... NOTE
  Found the following files/directories: ''NULL''
  This is a benign temporary file from the checking process and can be safely ignored.

## Downstream dependencies
There are no downstream dependencies.

## Submission comments
This is a resubmission of postvocs 0.2.5, addressing the CRAN reviewer's comments on version 0.2.3.

Changes in this version (0.2.5):
- Modified `annotate_compounds()` example to use user-provided library (`lib_source = "user"`) instead of webchem, eliminating network dependency and preventing macOS check failures.
- Added pre-annotated example data (`inst/extdata/annotated_example.rds`) for `filter_by_frequency()` and `save_postvocs_results()` examples.
- `filter_by_frequency()` and `save_postvocs_results()` examples now load pre-annotated data, avoiding repeated `annotate_compounds()` calls.
- Added defensive checks in `annotate_compounds()` for `prop_df` to handle edge cases.

All examples are now self-contained, executable, and do not require network access.

The package passes `R CMD check --as-cran` with no errors or warnings.
