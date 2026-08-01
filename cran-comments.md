## Test environments
- local Windows 11, R 4.5.3
- win-builder (R Under development, 2026-07-24 r90297)
- ubuntu 20.04 (via GitHub Actions)

## R CMD check results
There were no ERRORs or WARNINGs.

Notes:
- checking top-level files ... NOTE
  Non-standard file/directory found at top level: 'LICENSE.md'
  This is a standard GPL-3 license file and can be ignored.

- checking for non-standard things in the check directory ... NOTE
  Found the following files/directories: ''NULL''
  This is a benign temporary file and can be ignored.

## Downstream dependencies
There are no downstream dependencies.

## Submission comments
This is a resubmission of postvocs 0.2.0.

Changes from 0.1.0 (the previously submitted version):

### Breaking Changes
- The `screen_volatiles()` function has been split into two separate functions:
  - `annotate_compounds()` for compound annotation (CAS → chemical names and properties).
  - `filter_by_frequency()` for frequency-based screening.
  This was done to improve modularity and allow users to use annotation and screening independently.
- `extract_cas_abundance()` has been renamed to `extract_peak_areas()` with enhanced functionality.
- `build_cas_abundance_matrix()` has been renamed to `build_cas_abundance()` with simplified interface.

### New Features
- Added `encoding` parameter to `process_gcms_txt()` and `batch_process_gcms()` to handle non-UTF-8 files.
- Added `use_cache` and `force_retrieve` parameters to `annotate_compounds()` for flexible caching control.
- Added `save_postvocs_results()` for unified saving of analysis results.
- Added `sheet` parameter for Excel worksheet selection in relevant functions.

### Enhancements
- All console output has been converted from `cat()` to `message()` for better suppression control.
- Default output paths have been removed from functions.
- `save_postvocs_results()` now checks for existing single quotes before adding them.
- All examples now write to `tempdir()` where appropriate.
- Added Excel file support and automatic CAS cleaning.
- Example codes updated to use `\dontrun{}` or `\donttest{}` appropriately:
  - `annotate_compounds()`, `filter_by_frequency()`, and `save_postvocs_results()` retain `\dontrun{}` due to webchem queries and longer execution times.
  - Self-contained examples with simulated data use `\donttest{}`.
  
### Documentation
- Added example data files to make all function examples self-contained and directly runnable:
  - `inst/extdata/txt/`: 13 sample GC-MS .txt files (approximately 310 KB)
  - `inst/extdata/SampleID.xlsx`: sample mapping file (approximately 9 KB)
- All examples have been updated to use `system.file()` to reference these example files, and `tempdir()` for output paths.

### Bug Fixes
- Fixed encoding warnings in `process_gcms_txt()`.
- Improved sample name mapping in `batch_process_gcms()`.

These changes were made after the initial 0.1.0 submission and before CRAN acceptance, therefore the version has been incremented to 0.2.0.

The package passes `R CMD check --as-cran` with no errors or warnings (only two benign notes about LICENSE.md and a temporary NULL directory).
