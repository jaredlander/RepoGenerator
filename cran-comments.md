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

The word 'repo' was flagged as possibly misspelled, though I do believe that is the correct spelling for that meaning.

Got one warning about the README.

```
Conversion of 'README.md' failed:
pandoc.exe: Could not fetch images/GitHub-Settings.png
images/GitHub-Settings.png: openBinaryFile: does not exist (No such file or directory)
```

This was occurred because the `images` directory is marked in `.rbuildignore`. This image is only used for generating the README on GitHub so it should not affect anything on CRAN. Further, this warning did not occur in any other environment and the image shows up properly in the README on GitHub. So I hope it can be ignored since that image plays no role in package functionality.

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.
