# Assignment 1, 9/14/17
# unzip the data file
filename <- unzip(zipfile = "household_power_consumption.zip")
df <- read.table(filename, header = T, sep = ";", na = "?", nrow = 10, stringsAsFactors = F)
col.names <- colnames(df)
head(df)  # found the first column includes dates
dates <- read.table(filename, header = T, sep = ";", na = "?", colClasses = c("character", rep("NULL", ncol(df) - 1)))
dates <- as.Date(dates$Date, format = "%d/%m/%Y")
mt <- which(dates %in% as.Date(c("2007-02-01", "2007-02-02")))
# extract the data on "2007-02-01" and "2007-02-02"
df <- read.table(filename, header = F, sep = ";", na = "?", skip = mt[1], nrow = length(mt), stringsAsFactors = F)
colnames(df) <- col.names
rm(col.names, dates, filename, mt)

# plot 1
png(file = "plot1.png", width = 480, height = 480)
hist(df$Global_active_power, col = 2, xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")
dev.off()

# plot 2
xaxis.at <- c(0, 0.5, 1) * nrow(df)
png(file = "plot2.png", width = 480, height = 480)
plot(df$Global_active_power, type = "l", xlab = "", xaxt = "n", ylab = "Global Active Power (kilowatts)")
axis(1, at = xaxis.at, labels = c("Thu", "Fri", "Sat"))
dev.off()
# a better one
datetime <- strptime(paste(df$Date, df$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
png(file = "plot2.png", width = 480, height = 480)
plot(datetime, df$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()

# plot 3
xaxis.at <- c(0, 0.5, 1) * nrow(df)
png(file = "plot3.png", width = 480, height = 480)
plot(df$Sub_metering_1, type = "l", xlab = "", xaxt = "n", ylab = "Energy sub metering")
lines(df$Sub_metering_2, col = 2)
lines(df$Sub_metering_3, col = 4)
legend("topright", lwd = 1, col = c(1, 2, 4), legend = paste("Sub_metering", 1:3, sep = "_"))
axis(1, at = xaxis.at, labels = c("Thu", "Fri", "Sat"))
dev.off()

# plot 4
xaxis.at <- c(0, 0.5, 1) * nrow(df)
png(file = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))
# panel 1
plot(df$Global_active_power, type = "l", xlab = "", xaxt = "n", ylab = "Global Active Power")
axis(1, at = xaxis.at, labels = c("Thu", "Fri", "Sat"))
# panel 2
plot(df$Voltage, type = "l", xlab = "datetime", xaxt = "n", ylab = "Voltage")
axis(1, at = xaxis.at, labels = c("Thu", "Fri", "Sat"))
# panel 3
mt <- grep("Sub_metering", colnames(df), value = T)
col <- c(1, 2, 4)
matplot(df[, mt], type = "l", lty = 1, col = col, xlab = "", xaxt = "n", ylab = "Energy sub metering")
legend("topright", lwd = 1, col = col, legend = mt, bty = "n")
axis(1, at = xaxis.at, labels = c("Thu", "Fri", "Sat"))
# panel 4
plot(df$Global_reactive_power, type = "l", xlab = "datetime", xaxt = "n", ylab = "Global_reactive_power")
axis(1, at = xaxis.at, labels = c("Thu", "Fri", "Sat"))
dev.off()
