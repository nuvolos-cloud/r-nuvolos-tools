# Nuvolos Tools

This package aids using R together with the HPC cluster from Nuvolos

## Installation

```
install.packages('remotes')
remotes::install_github('nuvolos-cloud/r-nuvolos-tools')
```

## Usage 

### Package installation on cluster

```
nuvolos.tools::install.packages('package')
# or to install from github
nuvolos.tools::install_github('repo/package')
# or to install a local package
nuvolos.tools::install_local("~/files/my_package")
# or to sync existing libraries
nuvolos.tools::package_sync_hpc()
```

### Job submission / monitoring / cancellation

```
nuvolos.tools::sbatch("~/files/xyz.R",n_cpus=4)
nuvolos.tools::squeue()
nuvolos.tools::scancel(jobid)
```
