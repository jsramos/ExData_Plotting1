# Plot3.R
# This script creates the plot as it appears on 
# https://github.com/rdpeng/ExData_Plotting1/blob/master/figure/unnamed-chunk-4.png
# The plot is created as part of Course Project 1 for the 'Exploratory Data Analysis' Coursera MOOC.

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

# Backup current base graphics defaults except for RO properties
.pardefault <- par(no.readonly = T)

# Create 1st Plot on PNG graphic device
par(mar=c(4,4,2,2))
png("plot3.png", width = 480, height = 480, bg = "transparent")
with(pcdata, {
        plot(Sub_metering_1 ~ timestamp, type = "l", xlab="", ylab="Energy sub metering")
        lines(Sub_metering_2 ~ timestamp, col = "red")
        lines(Sub_metering_3 ~ timestamp, col = "blue")
        legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = c(1,1))
        })


# Close the graphics device
dev.off()
# Restore previous base graphic system defaults
par(.pardefault)
