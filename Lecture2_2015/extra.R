#  --------------------------------------------------



# Variables -----------------------------------------
uni  <-  "The University of Cambridge"
uni


# Paying tax: ---------------------------------------
#9400 tax free
(20000-9440)*20/100
#OR:
wage <- 20000
taxFree <- 9400
rate <- 20
(wage-taxFree)*rate/100


# Briefly about functions ---------------------------
plusOne <- function(x){ 
  	return(x+1)			
	}

plusOne2 <- function(num){ 
		return(num+1)			
	}

	plusOne(8)
	plusOne2(10)
  plusOne2(num=5)
  #plusOne2(wrongVar=2)


# Simple loops --------------------------------------
for (number in 1:5){
	print (number)
}


# Looping over functions ----------------------------
a <- c(1,2,3,4,5)
for (value in a){
	print (
		plusOne(value)
	)
}

listOfNumbers <- c(1,2,3,4,5)
for (number in listOfNumbers){
	print (
		number+1
	)
}


# More loops ----------------------------------------
a <- c(1,2,3,4,5)
a[1] #The first number in the vector
a[4] #The fourth number in the vector

for (i in 1:length(a)){
	print (
		plusOne(a[i])
	)
}


# Functions without variables -----------------------
printName <- function(){
  print ("My name is Rolf Fredheim")
}

printName()


# e.g. for simulations ------------------------------
sillySimulation <- function(){
x1 <- runif(500,80,100)
x2 <- runif(500,0,100)
v1 <- c(x1,x2)

x3 <- runif(1000,0,100)

df <- data.frame(v1,x3)
require(ggplot2)

print(ggplot(df, aes(v1,x3))+geom_point()+ggtitle("simulation of some sort"))
}


#  --------------------------------------------------
sillySimulation()


# Inserting variables -------------------------------
desperateTimes <- function(){
  print(paste0("Rolf is struggling to finish his PhD on time. Time remaining: 6 months"))
}


# Name ----------------------------------------------
desperateTimes <- function(name){
  print(paste0(name ," is struggling to finish his PhD on time. Time remaining: 6 months"))
}
desperateTimes(name="Tom")


# Gender --------------------------------------------
desperateTimes <- function(name,gender="m"){
  if(gender=="m"){
    pronoun="his"
  }else{
    pronoun="her"
  }
  
  print(paste0(name ," is struggling to finish ",pronoun," PhD on time. Time remaining: 6 months"))
}
desperateTimes(name="Tanya",gender="f")


# degree --------------------------------------------
desperateTimes <- function(name,gender="m",degree){
  if(gender=="m"){
    pronoun="his"
  }else{
    pronoun="her"
  }
  
  print(paste0(name ," is struggling to finish ",pronoun," ",degree," on time. Time remaining: 6 months"))
}
desperateTimes(name="Rolf",gender="m","Mphil")


# Days til deadline ---------------------------------
require(lubridate)
require(ggplot2)
deadline=as.Date("2015-09-01")
daysLeft <- deadline-Sys.Date()
totDays <- deadline-as.Date("2011-10-01")
print(daysLeft)
print(paste0("Rolf is struggling to finish his PhD on time. Days remaining: ", as.numeric(daysLeft)))


# part2 ---------------------------------------------
print(paste0("Percentage to go: ",round(as.numeric(daysLeft)/as.numeric(totDays)*100)))
df <- data.frame(days=c(daysLeft,totDays-daysLeft),lab=c("to go","completed"))
ggplot(df,aes(1,days,fill=lab))+geom_bar(stat="identity",position="fill")


#  --------------------------------------------------
timeToWorry <- function(){
  require(lubridate)
  deadline=as.Date("2015-09-01")
  daysLeft <- deadline-Sys.Date()
  totDays <- deadline-as.Date("2011-10-01")
  print(daysLeft)
  print(paste0("Rolf is struggling to finish his PhD on time. Days remaining: ", as.numeric(daysLeft)))
  print(paste0("Percentage to go: ",round(as.numeric(daysLeft)/as.numeric(totDays)*100)))
  df <- data.frame(days=c(daysLeft,totDays-daysLeft),lab=c("to go","completed"))
  ggplot(df,aes(1,days,fill=lab))+geom_bar(stat="identity",position="fill")
}


# File it away until in need of a reminder ----------
timeToWorry()



