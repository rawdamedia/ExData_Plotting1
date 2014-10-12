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

# get only the required subset of data
pwr <- power[power$Date=="1/2/2007" | power$Date=="2/2/2007",]

# create the plot in a png file
png(filename = "plot1.png", width = 480, height = 480)
hist(pwr$Global_active_power, 
     main="Global Active Power", 
     col = "red", 
     xlab = "Global Active Power (kilowatts)")
dev.off()