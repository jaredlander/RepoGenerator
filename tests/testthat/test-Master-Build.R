context("Master function creates a folder and repo")

theUser <- 'jaredlander'
repoName <- 'SuperTester'
repoPath <- '~/SuperTester'
theToken <- 'GITHUB_PAT'
delToken <- Sys.getenv('GITHUB_Tester')

teardown({
    unlink(repoPath, recursive=TRUE, force=TRUE)
    gh::gh("DELETE /repos/:owner/:repo", owner=theUser, repo=repoName, .token=delToken)
})

test_that('Create objects here', {
    skip_on_cran()
    skip('Need to figure out how to handle the env vars')
    skip_if(Sys.getenv(theToken) == '')
    
    newRepo <- createRepo(name=repoName, path=repoPath, token=theToken)
    
    allRepos <- gh::gh("/users/:username/repos", username=theUser, .token=Sys.getenv(theToken), .limit=Inf)
    repoOnGitHub <- repoName %in% vapply(allRepos, "[[", "", "name")
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
    
    expect_true(repoOnGitHub)
})
