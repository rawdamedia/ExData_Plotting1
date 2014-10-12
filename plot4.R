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
png(filename = "plot4.png", width = 480, height = 480)

#remember old settings
old.par <- par(mfcol=c(2, 2))

# plot2 in top left corner
plot(pwr$datetime,
     pwr$Global_active_power, 
     bg = NA, type = "l",
     ylab = "Global Active Power",
     xlab = NA)

#plot3 in bottom left corner
plot(pwr$datetime, pwr$Sub_metering_1, bg = NA, type = "l", 
     ylab = "Energy sub metering", xlab = NA)
lines(pwr$datetime, pwr$Sub_metering_2, col = "red", type = "l")
lines(pwr$datetime, pwr$Sub_metering_3, col = "blue", type = "l")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"),lty=1)

# Voltage in top right
plot(pwr$datetime, pwr$Voltage, bg = NA, type = "l",
     ylab = "Voltage", xlab = "datetime")

# Global reactive power in bottom right
plot(pwr$datetime, pwr$Global_react, bg = NA, type = "l",
     ylab = "Global_reactive_power", xlab = "datetime")

#close png file
dev.off()

# revert settings
par(old.par)