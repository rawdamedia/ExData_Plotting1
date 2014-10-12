# create data directory if not present yet
if (!file.exists("data")) {
    dir.create("data")
}
setwd("./data")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              "./household_power_consumption.zip",
              "curl")
unzip("./household_power_consumption.zip")
data_file <- list.files(pattern = "txt$")

# read into memory then clean up 
power <- read.table(data_file, header=T,sep=";",na.strings = "?")
file.remove(list.files())
setwd("../")
file.remove("data")

# Combine the Date and Time fields into a datetime field in POSIXt format
power$datetime <- strptime(paste(power$Date, power$Time),format = "%e/%m/%Y %H:%M:%S")

# get only the required subset of data
pwr <- power[power$datetime>=strptime("2007-02-01", format="%Y-%m-%d") 
             & power$datetime<strptime("2007-02-03", format="%Y-%m-%d"), ]

# create the plot in a png file
png(filename = "plot2.png", width = 480, height = 480)
plot(pwr$datetime,
     pwr$Global_active_power, 
     bg = NA, type = "l",
     ylab = "Global Active Power (kilowatts)",
     xlab = NA)
dev.off()