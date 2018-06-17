#' @title createRepo
#' @description Creates a new project and pushes it to GitHub
#' @details This is designed to make a bare repo to be used for workshops. It will create a new project with a customized README and customized download file. It then pushes this to GitHub.
#' @export
#' @author Jared P. Lander
#' @md
#' @param name Name to use for project and repo
#' @param path Location for the new project
#' @param data [data.frame] listing data sources. Must have at least the following columns: Local (the name the file should be on disk after downloaded), Remote (the URL of the file), Mode (the way to write to disk, either 'w' or 'wb').
#' @param packages Vector of packages that the user will be instructed to install.
#' @param user GitHub username
#' @param organizer Name of organizer of class. This can be in the form a a Markdown-style link.
#' @param token The name of the environment variable holding the GitHub access token. This can be set with [base::Sys.setenv()].
#' @param readme Path to parameterized rmarkdown document with parameters `className`, `organizer` and `packages`. If missing the default from the package is used.
#' @param ssh If `TRUE`, change the remote to use ssh instead of https
#' @return If all operations are successful, returns `TRUE`
#' 
createRepo <- function(name, path, 
                       data, 
                       packages=c('here', 'knitr', 'rmarkdown', 
                                  'tidyverse', 'usethis'),
                       user,
                       organizer=user,
                       token='GITHUB_PAT',
                       readme,
                       ssh=TRUE)
{
    # use defaults for certain arguments
    if(missing(user))
    {
        user <- Sys.info()['user']
    }
    
    # they must specify a path
    if(missing(path))
    {
        stop('You must specify a path to for the generated repo.')
    }
    
    # they MUST install usethis and rprojroot, so if they are not in the 
    # packages list they are added
    # and a message is generated saying as such
    unique(c(packages, 'rprojroot', 'usethis'))
    
    # create new project
    rstudioapi::initializeProject(path=path)
    
    # copy code, data, images, prep, etc
    # folders <- dir(here::here('payload'), full.names=TRUE)
    folders <- dir(system.file('payload', package='RepoGenerator'), 
                   full.names=TRUE, 
                   # include all files to get .gitignore
                   # this seems a little dangerous to me
                   # because what other hidden files are coming
                   all.files=TRUE)
    file.copy(folders, file.path(path), recursive=TRUE)
    
    if(missing(readme))
    {
        readme <- file.path(path, 'README.Rmd')
    }
    
    # render the README
    rmarkdown::render(readme, 
                      params=list(
                          className=name,
                          organizer=organizer,
                          packages=packages
                      ), 
                      output_format=rmarkdown::github_document())
    # remove the HTML version of README which was created for some reason I don't know
    unlink(file.path(path, 'README.html'))
    
    ## add list of files to the download file
    # if the data is missing, take all the data in metadata
    if(missing(data))
    {
        data <- utils::read.csv(system.file('metadata/DataList.csv', package="RepoGenerator"), 
                         stringsAsFactors=FALSE, header=TRUE)
    }
    
    dataBlocks <- createDownloadText(data)
    write(dataBlocks, file=file.path(path, 'prep', 'DownloadData.r'), append=TRUE)

    # create new GitHub repo
    # requires that the token be stored in GITHUB_PAT
    new_github_repo <- createGitHubRepo(repoName=name,
                                        token=Sys.getenv(token))
        
    # create git repo
    repo <- git2r::init(path)
    
    # add and commit files
    git2r::add(repo, dir(path, recursive=TRUE))
    # also add .gitignore
    # not sure if we can just change the above dir to include hidden files
    # because that might also include the .git folder
    git2r::add(repo, file.path(path, '.gitignore'))
    git2r::commit(repo, "Adding all files to Git")

    # add the remote
    git2r::remote_add(repo, 'origin', sprintf('https://github.com/%s/%s.git',
                                              user, name)
    )
    
    # push to git
    git2r::push(repo, "origin", "refs/heads/master", 
                credentials=git2r::cred_token(token))
    
    # switch to SSH afterward
    # this will allow us to use the ssh key to push to it instead of https
    if(ssh)
    {
        # first we remove the current https remote
        git2r::remote_remove(repo, name='origin')
        # then we add the ssh remote
        git2r::remote_add(repo, 'origin', sprintf('git@github.com:%s/%s.git', 
                                                  user, name)
        )
    }
    
    return(TRUE)
}

#' @title createDownloadText
#' @description Builds text for file that downloads data
#' @details Creates a block of code. The first line is a comment of the file name, then is uses [download.file()] using the remote URL and the local filename.
#' @author Jared P. Lander
#' @md
#' @param info [data.frame] listing data sources. Must have at least the following columns: Local (the name the file should be on disk after downloaded), Remote (the URL of the file), Mode (the way to write to disk, either 'w' or 'wb').
#' @return Returns the block of text
#' @examples 
#' 
#' dataList <- read.csv(system.file('metadata/DataList.csv', package='RepoGenerator'), 
#'     stringsAsFactors=FALSE, header=TRUE)
#' cat(RepoGenerator:::createDownloadText(dataList))
#' 
createDownloadText <- function(info)
{
    downloadBlock <- "# %s\ndownload.file(\n\t'%s',\n\tdestfile=file.path(dataDir, '%s'),\n\tmode='%s')\n"
    
    sprintf(downloadBlock, info$Local, info$Remote, info$Local, info$Mode)
}
