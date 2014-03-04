#Web Scraping part 3: Scaling up
#author: Rolf Fredheim and Aiora Zabala
#University of Cambridge
#04/03/2014


#In code
bbcScraper <- function(url){
  SOURCE <-  getURL(url,encoding="UTF-8")
  PARSED <- htmlParse(SOURCE)
  title=xpathSApply(PARSED, "//h1[@class='story-header']",xmlValue)
  date=as.character(xpathSApply(PARSED, "//meta[@name='OriginalPublicationDate']/@content"))
  if (is.null(date))    date <- NA
  if (is.null(title))    title <- NA
  return(c(title,date))
}



#Loop
require(RCurl)
require(XML)
urls <- c("http://www.bbc.co.uk/news/business-26414285","http://www.bbc.co.uk/news/uk-26407840","http://www.bbc.co.uk/news/world-asia-26413101","http://www.bbc.co.uk/news/uk-england-york-north-yorkshire-26413963")
results=NULL
for (url in urls){
  newEntry <- bbcScraper(url)
  results <- rbind(results,newEntry)
}
data.frame(results) #ignore the warning
```




#Disadvantage of loop
temp=NULL
#1st loop
temp <- rbind(temp,results[1,])
temp

#2nd loop
temp <- rbind(temp,results[2,])

#3d loop
temp <- rbind(temp,results[3,])

#4th loop
temp <- rbind(temp,results[4,])
temp


#sapply
A bit more efficient.

Takes a vector.
Applies a formula to each item in the vector:

```{r}
dat <- c(1,2,3,4,5)
sapply(dat,function(x) x*2)
```

syntax: sapply(data,function)
function: can be your own function, or a standard one:

```{r}
sapply(dat,sqrt)
```

#in our case:
urls <- c("http://www.bbc.co.uk/news/business-26414285","http://www.bbc.co.uk/news/uk-26407840","http://www.bbc.co.uk/news/world-asia-26413101","http://www.bbc.co.uk/news/uk-england-york-north-yorkshire-26413963")

sapply(urls,bbcScraper)


require(plyr)
dat <- ldply(urls,bbcScraper)
dat


#filtered links:
unique(xpathSApply(PARSED, "//a[@class='title linktrack-title']/@href"))
#OR 
xpathSApply(PARSED, "//div[@id='news content']/@href")


#Create a table
require(plyr)
targets <- unique(xpathSApply(PARSED, "//a[@class='title linktrack-title']/@href"))
results <- ldply(targets[1:5],bbcScraper) #limiting it to first five pages
results



#Principles of downloading

Function: download.file(url,destfile)
destfile = filename on disk
option: mode="wb"



#Example
url <- "http://lib.ru/SHAKESPEARE/hamlet8.pdf"
download.file(url,"hamlet.pdf",mode="wb")


#Automating downloads
url <- "http://lib.ru/GrepSearch?Search=pdf"
SOURCE <-  getURL(url,encoding="UTF-8") # Specify encoding when dealing with non-latin characters
PARSED <- htmlParse(SOURCE)
links <- (xpathSApply(PARSED, "//a/@href"))
links[grep("pdf",links)][1]
links <- paste0("http://lib.ru",links[grep("pdf",links)])
links[1]

#Can you write a loop to download the first ten links?


#What do they do: grep
grep("SHAKESPEARE",links)
links[grep("SHAKESPEARE",links)] #or: grep("SHAKESPEARE",links,value=T)

grep("hamlet*",links,value=T)[1]


#Regex
grep("stalin",c("stalin","stalingrad"),value=T)
grep("stalin\\b",c("stalin","stalingrad"),value=T)

#What do they do: gsub
author <- "By Rolf Fredheim"
gsub("By ","",author)
gsub("Rolf Fredheim","Tom",author)


#str_split
str_split(links[1],"/")
unlist(str_split(links[1],"/"))

parts <- unlist(str_split(links[1],"/"))
length(parts)
parts[length(parts)]


#The rest
annoyingString <- "\n    something HERE  \t\t\t"
nchar(annoyingString)
str_trim(annoyingString)
tolower(str_trim(annoyingString))
nchar(str_trim(annoyingString))
```

#Formatting dates
require(lubridate)
as.Date("2014-01-31")
date <- as.Date("2014-01-31")
str(date)

date <- as.Date("2014-01-31")
str(date)
date+years(1)
date-months(6)
date-days(1110)


as.Date("2014-01-31","%Y-%m-%d")

date  <- "04 March 2014"
as.Date(date,"%d %b %Y")


#Lubridate
require(lubridate)
date  <- "04 March 2014"
dmy(date)
time <- "04 March 2014 16:10:00"
dmy_hms(time,tz="GMT")
time2 <- "2014/03/01 07:44:22"
ymd_hms(time2,tz="GMT")

#Task
url <- 'http://www.telegraph.co.uk/news/uknews/terrorism-in-the-uk/10659904/Former-Guantanamo-detainee-Moazzam-Begg-one-of-four-arrested-on-suspicion-of-terrorism.html'
SOURCE <-  getURL(url,encoding="UTF-8") 
PARSED <- htmlParse(SOURCE)
title <- xpathSApply(PARSED, "//h1[@itemprop='headline name']",xmlValue)
author <- xpathSApply(PARSED, "//p[@class='bylineBody']",xmlValue)





#Code translated to R:
fqlQuery='select share_count,like_count,comment_count from link_stat where url="'
url="http://www.theguardian.com/world/2014/mar/03/ukraine-navy-officers-defect-russian-crimea-berezovsky"
queryUrl = paste0('http://graph.facebook.com/fql?q=',fqlQuery,url,'"')  #ignoring the callback part
lookUp <- URLencode(queryUrl) #What do you think this does?
lookUp



#Retrieving data
require(rjson)
url="http://quantifyingmemory.blogspot.com/2014/02/web-scraping-basics.html"
queryUrl = paste0('http://graph.facebook.com/fql?q=',fqlQuery,url,'"')  #ignoring the callback part
lookUp <- URLencode(queryUrl)
rd <- readLines(lookUp, warn="F") 
dat <- fromJSON(rd)
dat



#Accessing the numbers
dat$data[[1]]$like_count
dat$data[[1]]$share_count
dat$data[[1]]$comment_count
