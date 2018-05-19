#' @title callGitHubAPI
#' @description Function for interacting with the GitHub API
#' @details Builds up and executes a GitHub API request
#' @author Jared P. Lander
#' @param repoName Name of repo to interact with
#' @param token GitHub Personal Access Token: this should be the actual token, not the name of an environment variable
#' @param apiURL The base URL for the GitHub API, this really should not need to be changed
#' @param path The API endpoint
#' @param encoding The type of encoding for the request, either json of form
#' @param method The method to be used, as an R function, such as POST or GET
#' @return An API status
#' 
callGitHubAPI <- function(repoName, 
                          token,
                          apiURL='https://api.github.com', 
                          path='/user/repos', encoding=c('json', 'form'),
                          method=httr::POST
)
{
    encoding <- match.arg(encoding)
    # build up full URL so we can call the appropriate API endpoint
    apiURL <- httr::modify_url(apiURL, path=path)
    
    # if the token is not supplied, try to get it from the environment variable
    if(missing(token))
    {
        token <- Sys.getenv('GITHUB_PAT')
    }
    
    ## make the call
    # this is a post statement to create the repo
    result <- method(
        # this is the base URL and the end point
        url=apiURL,
        # the body only consists of the name of the repo we are creating
        body=list(name=repoName),
        # use the proper encoding
        encode=encoding,
        # build headers
        httr::add_headers(
            # the type of data the API accepts
            Accept="application/vnd.github.v3+json",
            # Just used the name of this package, not sure it's correct
            "User-Agent"="RepoGenerator",
            # the API access token, typically stored in GITHUB_PAT
            Authorization=sprintf("token %s", token)
        )
    )
    
    return(result)
}

#' @title createGitHubRepo
#' @describeIn callGitHubAPI Creating a GitHubRepo
createGitHubRepo <- function(repoName, 
                             token)
{
    callGitHubAPI(repoName=repoName, token=token,
                  apiURL='https://api.github.com',
                  path='/user/repos',
                  encoding='json',
                  method=httr::POST)
}

#' @title deleteGitHubRepo
#' @describeIn callGitHubAPI Deleting a GitHubRepo
#' @param owner GitHub username
deleteGitHubRepo <- function(owner,
                             repoName,
                             token)
{
    callGitHubAPI(repoName=repoName, token=token,
                  apiURL='https://api.github.com',
                  path=sprintf('/repos/%s/%s', owner, repoName),
                  encoding='json',
                  method=httr::DELETE)
}

#' @title checkGitHubRepoExists
#' @describeIn callGitHubAPI Check that a GitHubRepo exists
checkGitHubRepoExists <- function(owner,
                                  repoName,
                                  token)
{
    callGitHubAPI(repoName=repoName, token=token,
                  apiURL='https://api.github.com',
                  path=sprintf('/repos/%s/%s', owner, repoName),
                  encoding='json',
                  method=httr::GET)
}