## Requests from CRAN

Elaborated the description, changed the test to use tempdir, updted the createDownloadText() example. The only thing I couldn't do was add an example for createRepo() since that requires a GitHub Personal Access Token to run. I could set donttest or dontrun, but if I recall correctly they still get tested by CRAN.

Added a `SystemRequirements` field to the DESCRIPTION file to include GitHub and RStudio.

## Test environments
- Windows 10
    - R 3.5.0
    - R 3.4.3
- Windows Server 2012 R2 (on Appveyor)
- win-builder (devel and release)
- Ubuntu 14.04 (on travis-ci)
    - oldrel
    - release
    - devel
- Ubuntu 16.04 (WSL), R 3.4.3


## R CMD check results

### On Windows 10, Windows Server, Ubuntu 14.04 and Ubuntu 16.04

0 errors | 0 warnings | 0 notes

### On Win-builder

0 errors | 0 warnings | 1 notes

The note is two-fold. The first part is saying that I'm the maintainer. But I guess the real trigger is the possibly misspelled word "repo." As far as I can tell that seems to be an appropriate use of the word.

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.
