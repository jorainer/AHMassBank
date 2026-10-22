#' Updated version to create the metadata for MassBank releases
#'
#' To add a new release:
#'
#' - update the `releases` variable below (just keeping the one release that
#'   should be added)
#' - update `BiocVersion` (if needed).
#' - run `source("make-metadata.R")` **in this folder containing the script**.
#' 
#' @noRd
NULL

if (!"make-metadata.R" %in% dir())
    stop("run R in the inst/scripts/ folder")

## Update this variable!
releases <- c("2025.05.1", "2025.10", "2026.03")

## Update if the BiocVersion different from the current one.
BiocVersion <- character()

if (!length(BiocVersion))
    BiocVersion <- as.character(BiocManager::version())

library(gh)

.release_metadata <- function(x, biocVersion) {
    release_meta <- gh("GET /repos/MassBank/MassBank-data/releases/tags/:tag", 
                       tag = x)
    asset_names <- vapply(release_meta$assets, function(x) x$name, "")
    idx <- grep("RIKEN", asset_names)
    if (length(idx) != 1L)
        stop("Requested asset not found for release ", x)
    asset <- release_meta$assets[[idx]]
    if (!length(asset))
        stop("Requested asset not found in this release!")
    prefix <- "https://github.com"
    path <- sub(paste0("^", prefix), "",
                asset$browser_download_url)
    res <- data.frame(
        Title = paste0("MassBank release ", x),
        Description = paste0("Spectra object with MS2 spectra and small ",
                             "compound annotations from MassBank release ",
                             x, "."),
        BiocVersion = biocVersion,
        Genome = NA_character_,
        SourceType = "MSP",
        SourceUrl = "https://github.com/MassBank/MassBank-data",
        SourceVersion = x,
        SourceLastModifiedDate = as.POSIXct(release_meta$created_at),
        Species = NA_character_,
        TaxonomyId = NA_character_,
        Coordinate_1_based = NA,
        DataProvider = "MassBank",
        Maintainer = "Johannes Rainer <johannes.rainer@eurac.edu>",
        RDataClass = "Spectra",
        DispatchClass = "MspSpectra",
        Location_Prefix = prefix,
        RDataPath = path,
        ResourceName = paste0("MassBank.", x),
        Tags = paste0("MSP:MassBank:Metabolite:Annotation:", x)
    )
}

for (release in releases) {
    m <- .release_metadata(release, BiocVersion)
    write.csv(m, file = paste0("../extdata/metadata_", release, ".csv"),
              row.names = FALSE)
}


## To check the metadata:
## library(AnnotationHubData)
## Test <- AnnotationHubData::makeAnnotationHubMetadata("AHMassBank")
