## Test environments
- local Windows 11, R 4.5.3
- win-builder (R Under development, 2026-07-24 r90297)
- ubuntu 20.04 (via GitHub Actions)

## R CMD check results
There were no ERRORs or WARNINGs.

Notes:
- checking for non-standard things in the check directory ... NOTE
  Found the following files/directories: ''NULL''
  This is a temporary artifact from the checking process and can be safely ignored.

## Downstream dependencies
There are no downstream dependencies.

## Submission comments
This is a resubmission of postvocs 0.2.2, addressing the CRAN reviewer's comments on version 0.2.1.

Changes in this version (0.2.2) relative to 0.2.1:
- Removed `+ file LICENSE` from the License field and deleted the LICENSE file, as requested. The package now uses only `License: GPL (>= 3)`.
- Regarding the reference request: A manuscript describing the methodology is currently under review. Once it is published, we will add the appropriate reference (Authors, year, DOI) to the DESCRIPTION field. Currently, the functions are documented with references to the underlying packages (webchem, dplyr, etc.) and standard practices.

All other changes from previous submissions are documented in the NEWS.md file.

The package passes `R CMD check --as-cran` with no errors or warnings (only benign notes about a temporary `''NULL''` directory).
