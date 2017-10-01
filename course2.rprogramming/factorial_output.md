# This is the output of timing four factorial functions

The median time used by each fucntion was determined by microbenchmark::microbenchmark with 100 repeats. The output is listed below (in microseconds),

|Input           |1     |18    |35    |52    |69    |86    |103   |120   |137   |154   |171   |
|----------------|------|------|------|------|------|------|------|------|------|------|------|
|Factorial_loop  |13.196|38.854|65.978|93.469|115.10|140.75|165.68|190.60|216.26|242.65|265.38|
|Factorial_reduce|35.188|320.36|352.62|390.00|417.49|456.35|483.11|515.73|556.05|579.87|617.26|
|Factorial_func  |19.794|205.27|390.74|589.04|779.27|952.65|1155.3|1335.0|1519.3|1708.1|1889.9|
|Factorial_mem   |13.196|13.195|13.195|13.195|13.196|8.0640|13.196|13.195|13.195|13.196|8.0640|

From the table, we call tell that 'Factorial_mem' performed the best, and the user time didn't change much while the input number became bigger.
For the other three functions, the user time increased approximately in a linear scale along with the input number. 
The 'Factorial_loop' function performed the second best, the 'Factorial_reduce' function perfomed the third best, and 'Factorial_func' that used recursion perfomed the worst.
Here is a link to [an exploratory picture](https://github.com/tonyworld/2017DataScience/blob/master/course2.rprogramming/factorial_time.png).

The R code used for the analysis is listed below.
```{r}
library(microbenchmark)
library(purrr)
source("factorial_code.R")
# Because factorial(171) gives Inf, 11 number from 1 to 171 were selected as the input numbers
x <- seq(1, 171, by = 17)
# time the user time with microbenchmark
time.loop <- unlist(map(x, function(x) summary(microbenchmark(Factorial_loop(x), times = 100), unit = "us")$median))
time.reduce <- unlist(map(x, function(x) summary(microbenchmark(Factorial_reduce(x), times = 100), unit = "us")$median))
time.func <- unlist(map(x, function(x) summary(microbenchmark(Factorial_func(x), times = 100), unit = "us")$median))
factorials <- 1
time.mem <- unlist(map(x, function(x) summary(microbenchmark(Factorial_mem(x), times = 100), unit = "us")$median))
out <- rbind(time.loop, time.reduce, time.func, time.mem)
colnames(out) <- x
rownames(out) <- paste0("Factorial_", c("loop", "reduce", "func", "mem"))
write.table(out, 'clipboard', quote = F, sep = "|")
# compare the speed of four functions
png("factorial_time.png", width = 600, height = 400)
plot(1:11, type = "n", xaxt = "n", ylim = c(0, 2000), xlab = "Input number", ylab = "Microseconds", main = "Median time used by each function")
axis(1, at = 1:11, label = x)
lines(1:11, time.loop, col = 1, lwd = 2)
lines(1:11, time.reduce, col = 2, lwd = 2)
lines(1:11, time.func, col = 3, lwd = 2)
lines(1:11, time.mem, col = 4, lwd = 2)
legend("topleft", col = 1:4, lwd = 2, legend = paste0("Factorial_", c("loop", "reduce", "func", "mem")))
dev.off()
```
