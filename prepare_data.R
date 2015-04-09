# prepare_data.R
# This script downloads, unzips, subsets and filters the household power consumption data so that it only covers From Feb 1st to Feb 2nd 2007.
# Preparation of this data is implied by the creation of variable 'pcdata' in the current environment.
# 'pcdata' must have 2880 observations (2 days x 24 hours/day x 60 mins/hour) of 9 variables (2 character, 7 numeric, 1 POSIXct).

# Load required libraries and crash if not installed
require(dplyr)
require(lubridate)

# Automatically download and read data
pcZipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datafile <- "household_power_consumption.txt"
temp <- tempfile()
download.file(pcZipUrl, temp, method = "curl")
# Coerce columns to character or number accordingly, with NA character specified as '?'.
# fread function runs faster, but has a documented issue correctly understanding argument 'na.strings=x'
# so using it implies manual conversion of '?' characters, which is inconvenient.
raw <- read.csv(unz(temp, datafile), sep = ";",header = T, stringsAsFactors=F, na.strings=c("?","NA"), 
                colClasses=c(rep("character", 2), rep("numeric", 7)))
# Stops using temp file and frees resources
unlink(temp)
closeAllConnections()

# Validate load
if (nrow(raw) != 2075259 & ncol(raw) != 9) {
        stop("Verify the data has been downloaded correctly. There should be 2075259 rows and 9 columns")
}

# Create timestamp from Date and Time columns
raw <- raw %>% mutate(timestamp = parse_date_time(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))

# Filter out data only for dates between February 1st and 2nd, 2007.
# Lubridate interval between 1st hour of Feb 1st and last minute of Feb 2nd.
interval <- new_interval(ymd_hms("2007-02-01 00:00:00"), ymd_hms("2007-02-02 23:59:59"))
# Filter out observations outside interval
pcdata <- raw %>% filter(timestamp %within% interval)

# Validate filtering
if (nrow(pcdata) != 2880) {
        stop("There is a problem with your subsetting. There should be 2880 observations.")
}

# Remove unnecessary objects from memory
rm(raw)