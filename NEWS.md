# postvocs 0.2.0

## Breaking Changes
- `extract_cas_abundance()` has been renamed to `extract_peak_areas()` with enhanced functionality.
- `build_cas_abundance_matrix()` has been renamed to `build_cas_abundance()` with simplified interface.

## New Features
- Added `extract_peak_areas()` as a more flexible replacement for `extract_cas_abundance()`:
  - Supports data.frame input, file paths, and previous function outputs.
  - Can automatically detect and process all samples from a folder.
- Added `build_cas_abundance()` as a replacement for `build_cas_abundance_matrix()`:
  - Directly accepts output from `extract_peak_areas()`.
  - No automatic file saving; returns a data.frame for user control.
- Added `save_postvocs_results()` for unified saving of analysis results:
  - Supports CSV and XLSX formats.
  - Automatically adds single quote prefix to CAS columns to prevent Excel date conversion.
  - For XLSX output, multiple tables are saved as separate worksheets in one file.
- Added `filter_by_frequency()` for two-step occurrence frequency screening:
  - Removes compounds detected in blank samples.
  - Filters by total frequency and treatment-specific frequency.
  - Returns detailed summary tables with flags for each compound.

## Enhancements
- `annotate_compounds()` now supports Excel input and automatically cleans CAS numbers.
- `filter_by_frequency()` now accepts `annotate_compounds()` output directly.
- Improved documentation and examples for all functions.
- CAS numbers are automatically cleaned (spaces removed) during parsing.

## Bug Fixes
- Improved handling of column name detection in `extract_peak_areas()`.
- Enhanced error messages for better user guidance.

## Documentation
- Added comprehensive README.md with workflow examples.
- All functions now have complete roxygen2 documentation.


# postvocs 0.1.0

- Initial development version.
- Basic package structure with core functions for GC-MS data processing.
- Internal development only; not released on CRAN.
