#Loops and functions
===============
#1)
for (i in 1:1000) print (i)
total=0

#2)
for (i in 1:1000) {
  total=total+i
	}
total

#3) 
divideByTwo <- function(x) return(x/2)
divideByTwo(10)

#4) 
ninetynine <- function(x) return (99)

#5)
addThem <- function(x,y) return(x+y)


#One take on how to scrape Wikipedia pageviews
  
getData <- function(url){
  #function to download data in json format
  require(rjson)
	raw.data <- readLines(url, warn="F") 
	rd  <- fromJSON(raw.data)
	rd.views <- rd$daily_views 
	rd.views <- unlist(rd.views)
	rd <- as.data.frame(rd.views)
  rd$date <- rownames(rd)
  rownames(rd) <- NULL
	return(rd)
}

  
getUrls <- function(y1,y2,term){
  #function to create a list of urls given a term and a start and endpoint
    urls <- NULL
    for (year in y1:y2){
      for (month in 1:9){
      	urls <- c(urls,(paste("http://stats.grok.se/json/en/",year,0,month,"/",term,sep="")))
    	}
    
    	for (month in 10:12){
      	urls <- c(urls,(paste("http://stats.grok.se/json/en/",year,month,"/",term,sep="")))
    	}
    }
    return(urls)
}
  
getStats <- function(y1,y2,terms){
  #function to download data for each term
  #returns a dataframe
  output <- NULL
  for (term in terms){
    urls <- getUrls(y1,y2,term)
    
    results <- NULL
    for (url in urls){
      print(url)
      results <- rbind(results,getData(url))
    }
    results$term <- term
    
    output <- rbind(output,results)
  }
  return(output)
}
  
visualiseStats <- function(input){
  #function to visualise data from the getStats function
  require(lubridate)
  require(ggplot2)
  input$date <- as.Date(input$date)
  ggplot(input,aes(date,rd.views,colour=term))+geom_line()
}

input <- getStats(2011,2012,c("Data_mining","Web_scraping"))
visualiseStats(input)
