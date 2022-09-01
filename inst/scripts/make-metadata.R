#' Steps to create the metadata for a new release:
#'
#' - follow the description to create a new MassBank CompDb in `make-data.R`.
#' - Copy the `CompDb` SQLite file to the folder */home/jo/Projects/CompDbs*.
#' - Change the `version` variable below to the new MassBank release.
#'
#' @noRd
NULL

version <- "2022.06"
biocVersion <- "3.16"

baseDir <- "/home/jo/Projects/AHMassBank/"


## Start processing the data.
fl <- paste0(baseDir, version, "/CompDb.MassBank.", version, ".sqlite")
if (!file.exists(fl))
    stop("File ", fl, " not found")

require(CompoundDb, quietly = TRUE)
cdb <- CompDb(fl)


.metadataForCompDb <- function(x, biocVersion) {
    message("Processing file ", basename(x), " ... ", appendLF = FALSE)
    mtd <- metadata(CompDb(x))
    version <- mtd$value[mtd$name == "source_date"]
    vals <- data.frame(
        Title = paste0("MassBank CompDb for release ", version),
        Description = paste0("CompDb annotation database with compound ",
                             "annotations for MassBank release ", version, "."),
        BiocVersion = biocVersion,
        Genome = NA_character_,
        SourceType = "MySQL",
        SourceUrl = "https://massbank.eu/MassBank",
        SourceVersion = version,
        Species = NA_character_,
        TaxonomyId = NA_character_,
        Coordinate_1_based = NA,
        DataProvider = "MassBank",
        Maintainer = "Johannes Rainer <johannes.rainer@eurac.edu>",
        RDataClass = "CompDb",
        DispatchClass = "CompDb",
        RDataPath = paste0("AHMassBank/", version, "/", basename(x)),
        ResourceName = basename(x),
        Tags = paste0("CompDb:MassBank:Metabolite:Annotation:", version)
    )
    message("OK")
    return(vals)
}

meta <- .metadataForCompDb(fl, biocVersion)
write.csv(meta, file = paste0("../extdata/metadata_", version, ".csv"),
          row.names = FALSE)

## To check the metadata:
## library(AnnotationHubData)
## Test <- AnnotationHubData::makeAnnotationHubMetadata("AHMassBank")
