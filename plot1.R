# Plot1.R
# This script creates the plot as it appears on 
# https://github.com/rdpeng/ExData_Plotting1/blob/master/figure/unnamed-chunk-2.png
# The plot is created as part of Course Project 1 for the 'Exploratory Data Analysis' Coursera MOOC.

# Execute common code for all plots in file 'prepare_data.R'
if (file.exists("prepare_data.R")) {
        source("prepare_data.R")
} else {
        stop("File 'prepare_data.R' is missing. This file is in charge of downloading, cleaning and preparing the data for plotting, so it´s critical.")
}

# Backup current base graphics defaults except for RO properties
.pardefault <- par(no.readonly = T)

# Create 1st Plot on PNG graphic device
par(mar=c(4,4,2,2))
png("plot1.png", width = 480, height = 480, bg = "transparent")
with(pcdata, hist(Global_active_power, col="red", xlab = "Global Active Power (kilowatts)", 
                  ylim = c(0,1200), main="Global Active Power"))

# Close the graphics device
dev.off()
# Restore previous base graphic system defaults
par(.pardefault)
