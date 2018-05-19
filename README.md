<!-- README.md is generated from README.Rmd. Please edit that file -->
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/RepoGenerator)](https://cran.r-project.org/package=RepoGenerator) [![Travis-CI Build Status](https://travis-ci.org/jaredlander/RepoGenerator.svg?branch=master)](https://travis-ci.org/jaredlander/RepoGenerator) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/jaredlander/RepoGenerator?branch=master&svg=true)](https://ci.appveyor.com/project/jaredlander/RepoGenerator) [![Coverage Status](https://img.shields.io/codecov/c/github/jaredlander/RepoGenerator/master.svg)](https://codecov.io/github/jaredlander/RepoGenerator?branch=master)

RepoGenerator
=============

Generates a project and repo for easy initialization of a workshop.

GitHub Token
============

This is dependent on having a GitHub [Personal Access Token](https://blog.github.com/2013-05-16-personal-api-tokens/) (PAT).

First, go to GitHub user settings. Then click on `Developer Settings`.

``` r
knitr::include_graphics('images/GitHub-Settings.png')
```

![](images/GitHub-Settings.png)

On the following page click `Personal Access Token`.

``` r
knitr::include_graphics('images/GitHub-Developer-Settings.png')
```

![](images/GitHub-Developer-Settings.png)

Then click `Generate new token`.

``` r
knitr::include_graphics('images/GitHub-Token-Generation.png')
```

![](images/GitHub-Token-Generation.png)

Finally, select the `Repo` option.

``` r
knitr::include_graphics('images/PAT-Options.png')
```

![](images/PAT-Options.png)

The way some of the packages this package depends on are written, require that this code be saved in an environment variable. The best way to do this is to have a file named `.Renviron` in your home directory which can be located with `Sys.getenv('HOME')`. The file should look like this.

``` sh
GITHUB_PAT='LongStringOfNumbersAndLetters'
```

Generating a Project
====================

To create a project and turn it into a GitHub repo use the `createRepo` function.

If you have a list of data files stored somewhere that you want the user to download, build a `data.frame` listing at least the local name to be used for the data, the URL where the data are stored and the mode to write the data such as 'w' or 'wb'. If you don't provide one, the default data stored in my [data.world](https://data.world/landeranalytics/training) repo will be used. You should also specify a set of packages for the users to install.

``` r
data(datafiles, package='RepoGenerator')
datafiles[, c('Local', 'Remote', 'Mode')]
#>                     Local
#> 1       DiamondColors.csv
#> 2             diamonds.db
#> 3       ExcelExample.xlsx
#> 4      FavoriteSpots.json
#> 5         flightPaths.csv
#> 6            reaction.txt
#> 7            ribalta.html
#> 8      SocialComments.xml
#> 9         TomatoFirst.csv
#> 10            visited.csv
#> 11     manhattan_Test.rds
#> 12    manhattan_Train.rds
#> 13 manhattan_Validate.rds
#> 14    manhattan_Train.csv
#>                                                       Remote Mode
#> 1  https://query.data.world/s/uVlTdijkCbfac49-3k12tawsmviArp    w
#> 2  https://query.data.world/s/Z5k9W39e1kD5hzcJIcRlFClhIHnw5v   wb
#> 3  https://query.data.world/s/5wa6K_X91yfkf-BVpRe2UIabO5A-QB   wb
#> 4  https://query.data.world/s/033kPeDH9pMdcnhPRIOwhjrw3lpA10    w
#> 5  https://query.data.world/s/IIwWxfh9cTydB8h_OueRyA7yxvZ6bf    w
#> 6  https://query.data.world/s/uDfiLMRxSiB_kQQhEt_LbDGVOcStBR    w
#> 7  https://query.data.world/s/kK6-MCw-EbRmnwP-e2MmhEL82lLU4N    w
#> 8  https://query.data.world/s/vzZ_zJzCqXY_yExaJIt79XkJAqUbe-    w
#> 9  https://query.data.world/s/o_LrhM_oY5dexXVDbsMNxF2JyyIMrg    w
#> 10 https://query.data.world/s/GCIO0yVrO50N130s_CZNK50ujmqrE3    w
#> 11 https://query.data.world/s/tkfdrcapfsw7ihodbjzsdywz7povce   wb
#> 12 https://query.data.world/s/t6nblljn7a5ei6ghdqzkhfynn7iu5b   wb
#> 13 https://query.data.world/s/4tfwbez3ul5ap7apg2ffgltfpzmifm   wb
#> 14 https://query.data.world/s/zGvNwNJbY2470sjsVxYFstm426SEf1    w
```

``` r
packages <- c('caret', 'coefplot','DBI', 'dbplyr', 'doParallel', 'dygraphs', 
              'foreach', 'ggthemes', 'glmnet', 'jsonlite', 'leaflet', 'odbc', 
              'recipes', 'rmarkdown', 'rprojroot', 'RSQLite', 'rvest', 
              'tidyverse', 'threejs', 'usethis', 'UsingR', 'xgboost', 'XML', 
              'xml2')
```

``` r
createRepo(
    # the name to use for the repo and project
    name='WorkshopExampleRepo', 
    # the location on disc to build the project
    path='~/WorkshopExampleRepo',
    # the list of data files for the user to download
    data=datafiles,
    # vector of packages the user should install
    packages=packages,
    # the GitHub username to create the repo for
    user='jaredlander',
    # the new repo's README has the name of who is organizing the class
    organizer='Lander Analytics',
    # the name of the environment variable storing the GitHub PAT
    token='MyGitHubPATEnvVar'
)
```

GitHub
======

The earlier code created [this repo](https://github.com/jaredlander/WorkshopExampleRepo) on GitHub. You can point your attendees to the repo you created for easy instructions on getting ready for the workshop!
