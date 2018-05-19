context("Master function creates a folder and repo")

theUser <- 'jaredlander'
repoName <- 'SuperTester'
repoPath <- '~/SuperTester'
theToken <- 'GITHUB_PAT'
delToken <- 'GITHUB_TESTER'

teardown({
    unlink(repoPath, recursive=TRUE, force=TRUE)
    gone <- RepoGenerator:::deleteGitHubRepo(
        owner=theUser,
        repoName=repoName,
        token=Sys.getenv(delToken)
    )
})

test_that('Create objects here', {
    skip_on_cran()
    skip('Need to figure out how to handle the env vars')
    skip_if(Sys.getenv(theToken) == '')
    
    newRepo <- createRepo(name=repoName, path=repoPath, token=theToken)
    
    repoExists <- RepoGenerator:::checkGitHubRepoExists(
        owner=theUser,
        repoName=repoName,
        token=Sys.getenv(theToken)
    )
})

test_that("The repo was created successfully on disc", {
    skip_on_cran()
    skip('Need to figure out how to handle the env vars')
    skip_if(Sys.getenv(theToken) == '')
    
    expect_true(newRepo)
    expect_true(dir.exists(repoPath))
    
})

test_that('The repo was created on GitHub', {
    skip_on_cran()
    skip('Need to figure out how to handle the env vars')
    skip_if(Sys.getenv(theToken) == '')
    
    expect_is(repoExists, 'response')
    expect_equal(repoExists$status_code, 200)
})
