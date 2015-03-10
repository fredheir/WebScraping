#  --------------------------------------------------



# Load the packages ---------------------------------
require(lubridate)
require(plyr)
require(stringr)
require(XML)
require(RCurl)


# Extracting a table --------------------------------
url='http://en.wikipedia.org/wiki/Elections_in_Russia'
tables<-readHTMLTable(url)
head(tables[[6]])


# Download html -------------------------------------
url  <- "http://en.wikipedia.org/wiki/Boris_Nemtsov"
raw <-  getURL(url,encoding="UTF-8") #Download the page
#this is a very very long line. Let's not print it. Instead:
substring (raw,1,200)
PARSED <- htmlParse(raw) #Format the html code d


# Accessing HTML elements in R with XPath -----------
xpathSApply(PARSED, "//h1")


# Extract content -----------------------------------
xpathSApply(PARSED, "//h1",xmlValue)


# Untitled  -----------------------------------------




HTML tags
======================

- \<html>: starts html code
- \<head> : contains meta data etc
- \<script> : e.g. javascript to be loaded
- \<style> : css code
- \<meta> : denotes document properties, e.g. author, keywords
- \<title> : 
- \<body> : 

HTML tags2
======================

- \<div>, \<span> :these are used to break up a document into sections and boxes
- \<h1>,\<h2>,\<h3>,\<h4>,\<h5> Different levels of heading
- \<p> : paragraph
- \<br> : line break
- and others: \<a>, \<ul>, \<tbody>, \<th>, \<td>, \<ul>, \<ul>, <img>



What about other headings?
=====================
type:sq2




# Untitled  -----------------------------------------
temp=xpathSApply(PARSED, "//h3",xmlValue)

str_trim(temp[10])


# Extracting links ----------------------------------
length(xpathSApply(PARSED, "//a/@href"))


# Get references ------------------------------------
head(xpathSApply(PARSED, "//span[@class='reference-text']",xmlValue))

head(as.character(xpathSApply(PARSED, "//span[@class='reference-text']/span/a/@href")))


# Sanity test ---------------------------------------
links <- (xpathSApply(PARSED, "//span[@class='reference-text']/span/a/@href"))
browseURL(links[1])


# How it works --------------------------------------
head(xpathSApply(PARSED, "//span[@class='reference-text']/span/a/@href"))


# XPath2 --------------------------------------------
head(xpathSApply(PARSED, "//span[@class='reference-text'][17]/span/a/@href"))


# Wildcards -----------------------------------------
(xpathSApply(PARSED, "//*[@class='citation news'][17]/a/@href"))
(xpathSApply(PARSED, "//span[@class='citation news'][17]/a/@*"))


# Scrape Telegraph ----------------------------------
url <- 'http://www.telegraph.co.uk/search/?queryText=nemtsov&sort=relevant'
raw <-  getURL(url)#,encoding="UTF-8") 
PARSED <- htmlParse(raw) #Format the html code d
links<-xpathSApply(PARSED, "//a/@href")
length(links)
links<-xpathSApply(PARSED, "//div[@class='searchresults']//a/@href")
length(links)
length(unique(links))
links<-unique(links)

links<-links[grep('http',links)]


# Daily Mail ----------------------------------------
url <- 'http://www.dailymail.co.uk/home/search.html?sel=site&searchPhrase=nemtsov'
raw <-  getURL(url)#,encoding="UTF-8") 
PARSED <- htmlParse(raw) #Format the html code d
links<-xpathSApply(PARSED, "//a/@href")
length(links)
links<-xpathSApply(PARSED, "//div[@class='sch-results']//a/@href")
length(links)
length(unique(links))
links<-unique(links)


# dt2 -----------------------------------------------
head(links)

paste('http://www.dailymail.co.uk',links,sep='')
links=paste('http://www.dailymail.co.uk',links,sep='')


# Solution ------------------------------------------
url <- 'http://www.bbc.co.uk/search?q=nemtsov'
raw <-  getURL(url,encoding="UTF-8") 
PARSED <- htmlParse(raw) #Format the html code d
links<-xpathSApply(PARSED, "//a/@href")
length(links)
links<-xpathSApply(PARSED, '//ol[@class="search-results results"]//a/@href')
length(links)
length(unique(links))
links<-unique(links)


# Make function to get links ------------------------
getBBCLinks <- function(url){
  raw <-  getURL(url,encoding="UTF-8") 
  PARSED <- htmlParse(raw) #Format the html code d
  links<-unique(xpathSApply(PARSED, '//ol[@class="search-results results"]//a/@href'))
  return (links)
}


url='http://www.bbc.co.uk/search?q=putin'
links <-getBBCLinks(url)
links


# Untitled  -----------------------------------------
Get the headline:


# Untitled  -----------------------------------------
(xpathSApply(PARSED, "//span[@class='date']",xmlValue))


# Make a scraper ------------------------------------
bbcScraper <- function(url){
  date=''
  title=''
  SOURCE <-  getURL(url,encoding="UTF-8")
  PARSED <- htmlParse(SOURCE)
  title=xpathSApply(PARSED, "//title",xmlValue)
  date=xpathSApply(PARSED, "//meta[@name='OriginalPublicationDate']/@content")
  d=data.frame(url,title,date)
  return(d)
}

url='http://www.bbc.co.uk/search?q=putin'
links <-getBBCLinks(url)

dat <- ldply(links,bbcScraper)


# Guardian ------------------------------------------
url <- "http://www.theguardian.com/environment/2015/mar/08/how-will-everything-change-under-climate-change"
  SOURCE <-  getURL(url,encoding="UTF-8")
  PARSED <- htmlParse(SOURCE)
  xpathSApply(PARSED, "//h1[contains(@itemprop,'headline')]",xmlValue)
  xpathSApply(PARSED, "//a[@rel='author']",xmlValue)
  xpathSApply(PARSED, "//time[@itemprop='datePublished']",xmlValue)


# Guardian continued --------------------------------
  xpathSApply(PARSED, "//time[@itemprop='datePublished']/@datetime")
  xpathSApply(PARSED, "//li[@class='inline-list__item ']/a",xmlValue)
  xpathSApply(PARSED, "//div[@itemprop='articleBody']",xmlValue)


# Guardian scraper ----------------------------------
guardianScraper <- function(url){
  SOURCE <-  getURL(url,encoding="UTF-8")
  PARSED <- htmlParse(SOURCE)
  headline = author =date = tags = body =''
  headline<-xpathSApply(PARSED, "//h1[contains(@itemprop,'headline')]",xmlValue)
  author<-xpathSApply(PARSED, "//a[@rel='author']",xmlValue)[1]
  date<-as.character(xpathSApply(PARSED, "//time[@itemprop='datePublished']/@datetime"))
  tags<-xpathSApply(PARSED, "//li[@class='inline-list__item ']/a",xmlValue)
  tags<-paste(tags,collapse=',')
  body<-xpathSApply(PARSED, "//div[@itemprop='articleBody']",xmlValue)
  d<- tryCatch(
    {
      d=data.frame(url,headline,author,date,tags,body)      
    },error=function(cond){
      print (paste('failed for page',url))
      return(NULL)
    }
    )
}




# Get Guardian links --------------------------------
url='http://www.theguardian.com/world/russia?page=7'
getGuardianLinks <- function(url){
  raw <-  getURL(url,encoding="UTF-8") 
  PARSED <- htmlParse(raw) #Format the html code d
  links<-unique(xpathSApply(PARSED, '//div[@class="fc-item__container"]//a/@href'))
  return (links)
}

links <- getGuardianLinks(url)
dat<-ldply(links[1:8],guardianScraper)
head(dat[,1:5])


# Tidy the data -------------------------------------
gsub('\n','',dat$tags)
as.Date(dat$date)
gsub('\n','',dat$headline)

dat$tags <-gsub('\n','',dat$tags)
dat$date <-as.Date(dat$date)
dat$headline <-gsub('\n','',dat$headline)


# lubridate for dates -------------------------------
time="2015-02-09T14:59:32+0000"
ymd_hms(time)
time="\nMonday 23 February 2015\n"
dmy(time)
time='06/12/2013'
dmy(time)
mdy(time)


# Solutions (1: Mirror) -----------------------------
#MIRROR
url <- "http://www.mirror.co.uk/news/world-news/oscar-pistorius-trial-murder-reeva-3181393"
SOURCE <-  getURL(url,encoding="UTF-8") 
PARSED <- htmlParse(SOURCE)
title <- xpathSApply(PARSED, "//h1",xmlValue)
author <- xpathSApply(PARSED, "//li[@class='author']",xmlValue)
time  <- xpathSApply(PARSED, "//time[@itemprop='datePublished']/@datetime")


# Telegraph -----------------------------------------
#Telegraph
url <- "http://www.telegraph.co.uk/news/uknews/terrorism-in-the-uk/10659904/Former-Guantanamo-detainee-Moazzam-Begg-one-of-four-arrested-on-suspicion-of-terrorism.html"
SOURCE <-  getURL(url,encoding="UTF-8") 
PARSED <- htmlParse(SOURCE)
title <- xpathSApply(PARSED, "//h1[@itemprop='headline name']",xmlValue)
author <- xpathSApply(PARSED, "//p[@class='bylineBody']",xmlValue)
time  <- xpathSApply(PARSED, "//p[@class='publishedDate']",xmlValue)


# Independent ---------------------------------------
#Independent
url <- "http://www.independent.co.uk/news/people/emma-watson-issues-feminist-response-to-prince-harry-speculation-marrying-a-prince-is-not-prerequisite-to-being-a-princess-10064025.html"
SOURCE <-  getURL(url,encoding="UTF-8")
PARSED <- htmlParse(SOURCE)
title <- xpathSApply(PARSED, "//h1",xmlValue)
author <- xpathSApply(PARSED, "//span[@class='authorName']",xmlValue)
time  <- xpathSApply(PARSED, "//p[@class='dateline']",xmlValue)
as.Date(str_trim(time),"%d %B %Y")


