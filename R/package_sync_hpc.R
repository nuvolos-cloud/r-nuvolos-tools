#' Synchronize packages between Nuvolos and the HPC Cluster
#' @export
package_sync_hpc <- function() {
  installed_packages_local <- dir("/dhlib")
  cluster_path <- read.delim("/lifecycle/.clusterpath", header = FALSE, stringsAsFactors = FALSE)[1,1]
  user_name <- suppressWarnings({ read.delim("/secrets/username", header = FALSE, stringsAsFactors = FALSE)[1,1] })
  # create remote package folder if doesn't exist yet
  system(sprintf("ssh %s@scc-secondary.alphacruncher.net 'mkdir -p %s/lib'",user_name, cluster_path))

  # create a folder where we track successful remote package installs
  system('mkdir -p ~/hpc_installed/lib')

  # remove any lock folders
  system(sprintf("ssh %s@scc-secondary.alphacruncher.net 'rm -rf %s/lib/00*'",user_name, cluster_path))

  # get list of installed packages
  installed_packages_remote <- system('ls ~/hpc_installed/lib', intern = TRUE)

  packages_to_install <- setdiff(installed_packages_local, installed_packages_remote)

  if (length(packages_to_install) > 0) {
    r_version <- paste0(R.version$major,".",R.version$minor)
    for (p in packages_to_install) {
      print(sprintf("Installing package: %s", p))
      system(sprintf("ssh -o ServerAliveInterval=30 %s@scc-secondary.alphacruncher.net \"module load R/intel/mkl/%s && Rscript -e \\\"install.packages('%s',lib='%s/lib', repos='%s')\\\"\" && mkdir -p ~/hpc_installed/lib/%s",user_name, r_version, p, cluster_path,options()$repos, p))
    }
  } else {
    print("No additional packages to install.")
  }
}

#' Install packages locally and remotely
#' @export
install.packages <- function(package) {
  cluster_path <- read.delim("/lifecycle/.clusterpath", header = FALSE, stringsAsFactors = FALSE)[1,1]
  user_name <- suppressWarnings({ read.delim("/secrets/username", header = FALSE, stringsAsFactors = FALSE)[1,1] })
  # create remote package folder if doesn't exist yet
  system(sprintf("ssh -o ServerAliveInterval=30 %s@scc-secondary.alphacruncher.net 'mkdir -p %s/lib'",user_name, cluster_path))

  # remove any lock folders
  system(sprintf("ssh %s@scc-secondary.alphacruncher.net 'rm -rf %s/lib/00*'",user_name, cluster_path))

  # create a folder where we track successful remote package installs
  system('mkdir -p ~/hpc_installed/lib')

  # install first on hpc cluster
  for (p in package) {
    r_version <- paste0(R.version$major,".",R.version$minor)
    print(sprintf("Installing package on cluster: %s", p))
    system(sprintf("ssh -o ServerAliveInterval=30 %s@scc-secondary.alphacruncher.net \"module load R/intel/mkl/%s && Rscript -e \\\"install.packages('%s',lib='%s/lib', repos='%s')\\\"\" && mkdir -p ~/hpc_installed/lib/%s",user_name, r_version, p, cluster_path,options()$repos, p))
  }

  utils::install.packages(package)
}


#' Synchronize packages between Nuvolos and the HPC Cluster
#' @export
install_github <- function(repo) {
  cluster_path <- read.delim("/lifecycle/.clusterpath", header = FALSE, stringsAsFactors = FALSE)[1,1]
  user_name <- suppressWarnings({ read.delim("/secrets/username", header = FALSE, stringsAsFactors = FALSE)[1,1] })
  r_version <- paste0(R.version$major,".",R.version$minor)

  if (!'remotes' %in% dir("~/hpc_installed/lib")) {
    nuvolos.tools:::install.packages('remotes')
  }

  # remove any lock folders
  system(sprintf("ssh %s@scc-secondary.alphacruncher.net 'rm -rf %s/lib/00*'",user_name, cluster_path))

  system(sprintf("ssh -o ServerAliveInterval=30 %s@scc-secondary.alphacruncher.net \"module load R/intel/mkl/%s && export R_LIBS_USER=%s/lib && Rscript -e \\\"remotes::install_github('%s')\\\"\" && mkdir -p ~/hpc_installed/lib/%s",user_name, r_version, cluster_path, repo, tail(strsplit(repo,"/")[[1]],1)))
}