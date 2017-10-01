# This is the output using oop_code.R
======
```{r}
## Read in the data
library(readr)
library(magrittr)
source("oop_code.R")
## Load any other packages that you may need to execute your code
library(dplyr)
library(tidyr)

data <- read_csv("data/MIE.csv")
x <- make_LD(data)
print(class(x))
```
The output is,

[1] "LongitudinalData"

```{r}
print(x)
```
The output is,

Longitudinal dataset with 10 subjects

```{r}
## Subject 10 doesn't exist
out <- subject(x, 10)
print(out)
```
The output is,

NULL

```{r}
out <- subject(x, 14)
print(out)
```
The output is,

Subject ID: 14

```{r}
out <- subject(x, 54) %>% summary
print(out)
```
The output is,

ID: 54 
  visit  bedroom       den living room    office
1     0       NA        NA    2.792601 13.255475
2     1       NA 13.450946          NA  4.533921
3     2 4.193721  3.779225          NA        NA

```{r}
out <- subject(x, 14) %>% summary
print(out)
```
The output is,

ID: 14 
  visit   bedroom family  room living room
1     0  4.786592           NA     2.75000
2     1  3.401442     8.426549          NA
3     2 18.583635           NA    22.55069

```{r}
out <- subject(x, 44) %>% visit(0) %>% room("bedroom")
print(out)
```
The output is,

ID: 44 
Visit: 0 
Room: bedroom 

```{r}
## Show a summary of the pollutant values
out <- subject(x, 44) %>% visit(0) %>% room("bedroom") %>% summary
print(out)
```
The output is,

ID: 44 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    8.0    30.0    51.0    88.8    80.0   911.0 

```{r}
out <- subject(x, 44) %>% visit(1) %>% room("living room") %>% summary
print(out)
```
The output is,

ID: 44 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   2.75   14.00   24.00   41.37   37.00 1607.00 
