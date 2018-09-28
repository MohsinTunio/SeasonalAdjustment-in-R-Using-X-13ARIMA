
###---Seasonal Adjustment Using X-13 ARIMA-SEATS----###


#-----Steps----
# 1. Create a new folder and put this code and data file in it
# 2. Save the data, already in excel format, into Tab Delimited Text and name it as 'data.txt'
# 3. Append with 'u', the variables to be seasonally adjusted
# 4. Change the data 'start time' and frequency where the timeseries function 'ts' is called
# 5. Open this code file and run it: it will create a seasonally adjusted series

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

if(!require(seasonal)){
  install.packages("seasonal")
  library(seasonal)
}

if(!require(Hmisc)){
  install.packages("Hmisc")
  library(Hmisc)
}

if(!require(xts)){
  install.packages("xts")
  library(xts)
}

if(!require(timseries)){
  install.packages("timeseries")
  library(timeSeries)
}

if(!require(forecast)){
  install.packages("forecast")
  library(forecast)
}

rm(list=ls())

#-----------------------------------------------------------------
# 1. Data Preparation/Processing
#-----------------------------------------------------------------

#if(!data_raw){
#data_raw<-read.table("data.txt")
#}

data_raw<-read.table("data.txt")
data_names<-names(data_raw)
data_sa<-subset(data_names,grepl("u",data_names))

data_with_u=select(data_raw,data_sa)

#-----------------------------------------------------------------
# 2. Seasonal Adjustment Block
#-----------------------------------------------------------------

output.data<- data.frame(matrix(nrow=nrow(data_with_u),ncol=ncol(data_with_u)))
for(val in 1:length(data_sa))
{
  series1<- data_with_u[val]
  series1<-ts(series1, start = c(2001,3), frequency = 4)
  series1_sa <- seas(series1)
  series1_sad<-series1_sa$data[,1]
  output.data[,val]<-series1_sad
  write.table(output.data, 'seasadjtry.csv', row.names = FALSE, col.names = names(data_with_u), quote = FALSE, sep = ',')
  
}
