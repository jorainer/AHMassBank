#' @title Creation of MassBank CompDb Resources
#'
#' @description
#' 
#' MassBank is a open access, community maintained annotation database for
#' small compounds. The data is released irregularly and provided as MySQL
#' database dumps or MSP annotation files.
#'
#' The steps to create CompDb SQLite databases for MassBank are:
#' 
#' - download the MySQL database dump *MassBank.sql* from
#'   https://github.com/MassBank/MassBank-data/releases
#' - install the MySQL database dump locally on a MySQL/MariaDB server.
#' - start R and connect to this database (using the `RMariaDB` package).
#' - load the helper function with
#'   `source(system.file("scripts", "massbank_to_compdb.R", package = "CompoundDb"))`
#' - create the CompDb database with `massbank_to_compdb(con)` where `con` is
#'   the connection to the MassBank MySQL database.
#'
#' @author Johannes Rainer
#'
#' @md
#'
#' @noRd
NULL

