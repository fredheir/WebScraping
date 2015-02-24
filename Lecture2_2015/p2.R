#  --------------------------------------------------



# Load the packages ---------------------------------
require(ggplot2)
require(lubridate)
require(plyr)
require(stringr)
require(jsonlite)


# Last week's example -------------------------------
url  <- "http://stats.grok.se/json/en/201201/web_scraping"
raw.data <- readLines(url, warn="F") 
rd  <- fromJSON(raw.data)
summary(rd)


# Cont ----------------------------------------------
rd.views <- unlist(rd$daily_views )
rd.views


# Sorting a data frame ------------------------------
df <- data.frame(rd.views)
df$dates <-rownames(df)
order(rownames(df))

ord_df <-df[order(rownames(df)),]
ord_df


# Changing the date ---------------------------------
target <- 201401
url <- paste("http://stats.grok.se/json/en/",
          target,"/web_scraping",sep="")

getData <- function(url){
	raw.data <- readLines(url, warn="F") 
	rd  <- fromJSON(raw.data)
	rd.views <- unlist(rd$daily_views )
	df <- data.frame(rd.views)
  #Because row names tend to get lost....
  df$dates <- rownames(df)
	return(df)
}

getData(url)


# Create urls for January -June ---------------------
5:10
201401:201406
targets <- 201401:201406
target_urls <- paste("http://stats.grok.se/json/en/",
                  targets,"/web_scraping",sep="")
target_urls


# Download them one by one --------------------------
for (i in target_urls){
	print (i)
}

for (i in target_urls){
	dat = getData(i)
}


# Loops: storing the data? --------------------------
hold <- NULL
for (i in 1:5){
  print(paste0('this is loop number ',i))
  hold <- c(hold,i)
  print(hold)
}


# Solution ------------------------------------------
holder <- NULL
for (i in target_urls){
	dat <- getData(i)
	holder <- rbind(holder,dat)
}

holder


# Parsimonious approach -----------------------------
dat <- ldply(target_urls,getData)


# Putting it together -------------------------------
targets <- 201401:201406
targets <- paste("http://stats.grok.se/json/en/",
              201401:201406,"/web_scraping",sep="")
dat <- ldply(targets,getData)


# Task ----------------------------------------------
targets <- c("Barack_Obama","United_States_elections,_2014")


# Walkthrough ---------------------------------------
targets <- c("Barack_Obama","United_States_elections,_2014")
target_urls <- paste("http://stats.grok.se/json/en/201401/",targets,sep="")
results <- ldply(target_urls,getData)

#find number of rows for each: 
t <- nrow(results)/length(targets)
t
#apply ids:
results$id <- rep(targets,each=t)


# Download the page ---------------------------------
url <- 'http://www.dailymail.co.uk/reader-comments/p/asset/readcomments/2643770?max=10&order=desc'
raw.data <- readLines(url, warn="F") 
rd  <- fromJSON(raw.data)

str(rd)


# Digging in ----------------------------------------
dat <- rd$payload$page
dat$replies <- NULL
head(dat)


# Download these into R! ----------------------------
url <- 'http://graph.facebook.com/?id=http://www.bbc.co.uk/sport/0/football/31583092'
raw.data <- readLines(url, warn="F") 
rd  <- fromJSON(raw.data)
df <- data.frame(rd)


# Walkthrough ---------------------------------------
#1) 
url <- 'http://www.dailymail.co.uk/news/article-2643770/Why-Americans-suckers-conspiracy-theories-The-country-founded-says-British-academic.html'
target <- paste('http://urls.api.twitter.com/1/urls/count.json?url=',url,sep="")
raw.data <- readLines(target, warn="F") 
rd  <- fromJSON(raw.data)
tw1 <- data.frame(rd)

url2 <- 'http://www.huffingtonpost.com/2015/02/22/wisconsin-right-to-work_n_6731064.html'
target <- paste('http://urls.api.twitter.com/1/urls/count.json?url=',url2,sep="")
raw.data <- readLines(target, warn="F") 
rd  <- fromJSON(raw.data)
tw2 <- data.frame(rd)


# Walkthrough 2 and 3 -------------------------------
#2)
df <- rbind(tw1,tw2)

#3)
getTweetCount <-function(url){
	target <- paste('http://urls.api.twitter.com/1/urls/count.json?url=',url,sep="")
	raw.data <- readLines(target, warn="F") 
	rd  <- fromJSON(raw.data)
	tw1 <- data.frame(rd)
	return(tw1)
}
getTweetCount(url2)


# Walkthrough 4 -------------------------------------
#4)
getBoth <-function(url){
	target <- paste('http://urls.api.twitter.com/1/urls/count.json?url=',url,sep="")
	raw.data <- readLines(target, warn="F") 
	rd  <- fromJSON(raw.data)
	tw1 <- data.frame(rd)

	target <- paste('http://graph.facebook.com/?id=',url,sep='')
	raw.data <- readLines(target, warn="F") 
	rd  <- fromJSON(raw.data)
	fb1 <- data.frame(rd)
  
	df <- cbind(fb1[,1:2],tw1$count)
	colnames(df) <- c('id','fb_shares','tw_shares')
	return(df)
}


# Walkthrough 5 -------------------------------------
#5)
targets <- c(
'http://www.dailymail.co.uk/news/article-2643770/Why-Americans-suckers-conspiracy-theories-The-country-founded-says-British-academic.html',
'http://www.huffingtonpost.com/2015/02/22/wisconsin-right-to-work_n_6731064.html'
)

dat <- ldply(targets,getBoth)


# Comments ------------------------------------------
url <- 'http://www.huffingtonpost.com/2015/02/22/wisconsin-right-to-work_n_6731064.html'
api <- 'http://graph.facebook.com/comments?id='
target <- paste(api,url,sep="")
raw.data <- readLines(target, warn="F") 
rd  <- fromJSON(raw.data)
head(rd$data)


# Download the page ---------------------------------
url <- 'http://www.huffingtonpost.com/2015/02/22/wisconsin-right-to-work_n_6731064.html'
api <- 'http://juicer.herokuapp.com/api/article?url='

target <- paste(api,url,sep="")
target

raw.data <- readLines(target, warn="F") 
rd  <- fromJSON(raw.data)

dat <- rd$article
dat$entities <-NULL

dat <-data.frame(dat)
dat


#  --------------------------------------------------
ent <- rd$article$entities
ent


# What does the last frame give us? -----------------

#use square bracket notation to navigate these data:
ent[ent$type=='Location',]
ent[ent$type=='Person',]


