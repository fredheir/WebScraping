#  --------------------------------------------------



# Tabulate this data --------------------------------
require (ggplot2)
clubs <- c("Tottenham","Arsenal","Liverpool",
           "Everton","ManU","ManC","Chelsea")
nPages <- c(67,113,54,16,108,93,64)
df <- data.frame(clubs,nPages)
df


# Visualise it --------------------------------------
ggplot(df,aes(clubs,nPages,fill=clubs))+
  geom_bar(stat="identity")+
  coord_flip()+theme_bw(base_size=70)


# Changing the case ---------------------------------
tolower('ROLF')
states = rownames(USArrests)
tolower(states[0:4])
toupper(states[0:4])


# Number of characters ------------------------------
nchar(states)
states[nchar(states)==5]



# str_split -----------------------------------------
require(stringr)
link="http://stats.grok.se/json/en/201401/web_scraping"
str_split(link,'/')
unlist(str_split(link,"/"))


# Cleaning data -------------------------------------
annoyingString <- "\n    something HERE  \t\t\t"

nchar(annoyingString)
str_trim(annoyingString)
tolower(str_trim(annoyingString))
nchar(str_trim(annoyingString))


# Structured practice -------------------------------
require(RCurl)

download.file('https://raw.githubusercontent.com/fredheir/WebScraping/gh-pages/Lecture1_2015/text.txt',destfile='tmp.txt',method='curl')
text=readLines('tmp.txt')



# Walkthrough ---------------------------------------
length(text)
text[7]
length(unlist(str_split(text[7],' ')))
table(length(unlist(str_split(text[7],' '))))
words=sort(table(length(unlist(str_split(text[7],' ')))))
tail(words)
nchar(names(tail(words)))
words=sort(table(length(unlist(str_split(text,' ')))))
tail(words)


# What do they do - grep ----------------------------
grep("Ohio",states)

grep("y",states)

#To make a selection
states[grep("y",states)]



# Walkthrough2 --------------------------------------
grep('London',text)
grep('conspiracy',text)
grep('amendment',text)
grep('§',text)
length(grep('§',text))


# Regex ---------------------------------------------
stalinwords=c("stalin","stalingrad","Stalinism","destalinisation")
grep("stalin",stalinwords,value=T)

#Capitalisation
grep("stalin",stalinwords,value=T)
grep("[Ss]talin",stalinwords,value=T)

#Wildcards
grep("s*grad",stalinwords,value=T)

#beginning and end of word
grep('\\<d',stalinwords,value=T)
grep('d\\>',stalinwords,value=T)


# Walkthrough3 --------------------------------------
grep('[Aa]mendment',text)
grep('^[Aa]mendment',text)
grep('\\?$',text)


# What do they do: gsub -----------------------------
author <- "By Rolf Fredheim"
gsub("By ","",author)
gsub("Rolf Fredheim","Tom",author)


# Paste ---------------------------------------------
var=123
paste("url",var,sep="")
paste("url",var,sep=" ")


# Paste2 --------------------------------------------
var=123
paste("url",rep(var,3),sep="_")


# Paste3 --------------------------------------------
paste("url",1:3,var,sep="_")
var=c(123,421)
paste(var,collapse="_")


# With a URL ----------------------------------------
var=201401
paste("http://stats.grok.se/json/en/",var,"/web_scraping")
paste("http://stats.grok.se/json/en/",var,"/web_scraping",sep="")


# Walkthrough ---------------------------------------
a="test"
b="scrape"
c=94

paste(a,b,c,sep='_')
paste(a,b,c,sep='')
#OR:
paste0(a,b,c)
paste('a',1:10,sep='')


# Testing a URL is correct in R ---------------------
var=201401
url=paste("http://stats.grok.se/json/en/",var,"/web_scraping",sep="")
url
browseURL(url)


# Fetching data -------------------------------------
var=201401
url=paste("http://stats.grok.se/json/en/",var,"/web_scraping",sep="")
raw.data <- readLines(url, warn="F") 
raw.data


# Fetching data2 ------------------------------------
require(jsonlite)
rd  <- fromJSON(raw.data)
rd


# Fetching data3 ------------------------------------
rd.views <- unlist(rd$daily_views)
rd.views


# Fetching data4 ------------------------------------
rd.views <- unlist(rd.views)
df <- as.data.frame(rd.views)
df


# Put it together -----------------------------------
var=201403

url=paste("http://stats.grok.se/json/en/",var,"/web_scraping",sep="")
rd <- fromJSON(readLines(url, warn="F"))
rd.views <- rd$daily_views 
df <- as.data.frame(unlist(rd.views))


# Can we turn this into a function?  ----------------
df=myfunction(var) 


# Plot it -------------------------------------------
require(ggplot2)
require(lubridate)
df$date <-  as.Date(rownames(df))
colnames(df) <- c("views","date")
ggplot(df,aes(date,views))+
  geom_line()+
  geom_smooth()+
  theme_bw(base_size=20)


# Idea of a loop ------------------------------------
name='Rolf Fredheim'
name='Yulia Shenderovich'
name='David Cameron'
firstsecond=(str_split(name, ' ')[[1]])
ndiff=nchar(firstsecond[2])-nchar(firstsecond[1])
print (paste0(name,"'s surname is ",ndiff," characters longer than their firstname"))




# Simple loops --------------------------------------
for (number in 1:5){
	print (number)
}


# Looping over functions ----------------------------
states_first=head(states)
for (state in states_first){
	print (
		tolower(state)
	)
}

for (state in states_first){
  print (
		substring(state,1,4)
	)
}


# Urls again ----------------------------------------
for (month in 1:12){
	print(paste(2014,month,sep=""))
}


# Not quite right -----------------------------------
	for (month in 1:9){
		print(paste(2012,0,month,sep=""))
	}

	for (month in 10:12){
		print(paste(2012,month,sep=""))
	}


# Store the data ------------------------------------
dates=NULL
	for (month in 1:9){
		date=(paste(2012,0,month,sep=""))
		dates=c(dates,date)
	}

	for (month in 10:12){
		date=(paste(2012,month,sep=""))
		dates=c(dates,date)
	}
print (as.numeric(dates))

dates <- c(c(201201,201202),201203)
print (dates)



# Putting it together -------------------------------
  for (month in 1:9){
		print(paste("http://stats.grok.se/json/en/2013",0,month,"/web_scraping",sep=""))
	}

	for (month in 10:12){
		print(paste("http://stats.grok.se/json/en/2013",month,"/web_scraping",sep=""))
	}


