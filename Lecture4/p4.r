
# Web Scraping part 4: APIs
# author: Rolf Fredheim and Aiora Zabala
# University of Cambridge
# 11/03/2014

# Catch up
# 
# Slides from week 1: http://quantifyingmemory.blogspot.com/2014/02/web-scraping-basics.html
# Slides from week 2: http://quantifyingmemory.blogspot.com/2014/02/web-scraping-part2-digging-deeper.html
# Slides from week 3: http://quantifyingmemory.blogspot.com/2014/03/web-scraping-scaling-up-digital-data.html

# Get the docs:
# http://fredheir.github.io/WebScraping/Lecture4/p4.html
# 
# http://fredheir.github.io/WebScraping/Lecture4/p4.Rpres
# 
# http://fredheir.github.io/WebScraping/Lecture4/p4.r



#Facebook API 
fqlQuery='select share_count,like_count,comment_count from link_stat where url="'
url="http://www.theguardian.com/world/2014/mar/03/ukraine-navy-officers-defect-russian-crimea-berezovsky"
queryUrl = paste0('http://graph.facebook.com/fql?q=',fqlQuery,url,'"')  #ignoring the callback part
lookUp <- URLencode(queryUrl) #What do you think this does?
lookUp

#Read it in:
require(rjson)
rd <- readLines(lookUp, warn="F") 
dat <- fromJSON(rd)
dat






#Geocoding
#write a function
getUrl <- function(address,sensor = "false") {
 root <- "http://maps.google.com/maps/api/geocode/json?"
 u <- paste0(root,"address=", address, "&sensor=false")
 return(URLencode(u))
}
getUrl("Kremlin, Moscow")



#In use
require(RJSONIO)
target <- getUrl("Kremlin, Moscow")
dat <- fromJSON(target)
latitude <- dat$results[[1]]$geometry$location["lat"]
longitude <- dat$results[[1]]$geometry$location["lng"]
place <- dat$results[[1]]$formatted_address

latitude
longitude
place



#Getting a static map
#Construct that URL in R using paste?
base="http://maps.googleapis.com/maps/api/staticmap?center="
latitude=55.75
longitude=37.62
zoom=13
maptype="hybrid"
suffix ="&size=800x800&sensor=false&format=png"


#Possible solution
base="http://maps.googleapis.com/maps/api/staticmap?center="
latitude=55.75
longitude=37.62
zoom=13
maptype="hybrid"
suffix ="&size=800x800&sensor=false&format=png"

target <- paste0(base,latitude,",",longitude,
                 "&zoom=",zoom,"&maptype=",maptype,suffix)


#What to do next...?
download.file(target,"test.png", mode = "wb")

#Leftovers
#non-latin strings in scraper output:


bbcScraper <- function(url){
  SOURCE <-  getURL(url,encoding="UTF-8")
  PARSED <- htmlParse(SOURCE,encoding="UTF-8")
  title=xpathSApply(PARSED, "//h1[@class='story-header']",xmlValue)
  date=as.character(xpathSApply(PARSED, "//meta[@name='OriginalPublicationDate']/@content"))
  if (is.null(date))    date <- NA
  if (is.null(title))    title <- NA
  return(c(title,date))
}


#Social APIs
url="http://www.theguardian.com/uk-news/2014/mar/10/rise-zero-hours-contracts"
target=paste0("http://urls.api.twitter.com/1/urls/count.json?url=",url)
  rd <- readLines(target, warn="F") 
  dat <- fromJSON(rd)
  dat
  shares <- dat$count





#Social APIs, my solutions
#Linkedin
url="http://www.theguardian.com/uk-news/2014/mar/10/rise-zero-hours-contracts"
target=paste0("http://www.linkedin.com/countserv/count/share?url=$",url,"&format=json")
  rd <- readLines(target, warn="F") 
  dat <- fromJSON(rd)

#StumbleUpon
url="http://www.theguardian.com/uk-news/2014/mar/10/rise-zero-hours-contracts"
target=paste0("http://www.stumbleupon.com/services/1.01/badge.getinfo?url=",url)
  rd <- readLines(target, warn="F") 
  dat <- fromJSON(rd)



#Map making 2: my approach
query="cambridge university"
target=paste0("http://geocode-maps.yandex.ru/1.x/?format=json&lang=en-BR&geocode=",query)
  rd <- readLines(target, warn="F") 
  dat <- fromJSON(rd)

#Exctract address and location data
address <- dat$response$GeoObjectCollection$featureMember[[1]]$
  GeoObject$metaDataProperty$GeocoderMetaData$AddressDetails$Country$AddressLine
pos <- dat$response$GeoObjectCollection$featureMember[[1]]$
  GeoObject$Point
require(stringr)
temp <- unlist(str_split(pos," "))
latitude=as.numeric(temp)[1]
longitude=as.numeric(temp)[2]


#Map making 2: my approach 2
zoom=13
lang="en-US"
maptype="map" #pmap,map,sat,trf (traffic!) Note: if using sat, file is in JPG format, not PNG
target <- paste0("http://static-maps.yandex.ru/1.x/?ll=",latitude,",",longitude,"&size=450,450&z=",zoom,"&l=map&lang=",lang,"&l=",maptype)
download.file(target,"test.png", mode = "wb")


#YouTube stats
#Function to return stats about a single video
getStats <- function(id){
  url=paste0("https://gdata.youtube.com/feeds/api/videos/",id,"?v=2&alt=json")
  raw.data <- readLines(url, warn="F") 
  rd  <- fromJSON(raw.data)
  dop  <- as.character(rd$entry$published)
  term <- rd$entry$category[[2]]["term"]
  label <- rd$entry$category[[2]]["label"]
  title <- rd$entry$title
  author <- rd$entry$author[[1]]$name
  duration <- rd$entry$`media$group`$`media$content`[[1]]$duration
  favs <- rd$entry$`yt$statistics`["favoriteCount"]
  views <- rd$entry$`yt$statistics`["viewCount"]
  dislikes <- rd$entry$`yt$rating`["numDislikes"]
  likes <- rd$entry$`yt$rating`["numLikes"]
  return(data.frame(id,dop,term,label,title,author,duration,favs,views,dislikes,likes))
}



#YouTube Comments

#Function to return comments about a video

getComments <- function(id){
  url=paste0("http://gdata.youtube.com/feeds/api/videos/",id,"/comments?v=2&alt=json")
  raw.data <- readLines(url, warn="F") 
  rd  <- fromJSON(raw.data)
  comments <- as.character(sapply(1:length(rd$feed$entry), function(x) (rd$feed$entry[[x]]$content)))
  return(comments)
}
