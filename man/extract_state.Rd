% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/slurm_commands.R
\name{extract_state}
\alias{extract_state}
\title{Extract job state from detailed job information provided by slookup}
\usage{
extract_state(lookup_val)
}
\arguments{
\item{lookup_val}{Result from running slookup_job. Can be either an array containing an error message or job details. In case of an error message, the job has finished.}
}
\description{
Extract job state from detailed job information provided by slookup
}
