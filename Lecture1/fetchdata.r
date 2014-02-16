  fetchData <-function(nMonths,subjects) {  
    require(lubridate)
    require(stringr)
    require(rjson)
    # create a set of months to be analyzed
    dates <-seq(floor_date(Sys.time(),unit="month")-months(nMonths),floor_date(Sys.time(),unit="month"), by = "month")
   
    # create blank dataframe to hold three fields
    allData <- data.frame(count=numeric(),date=character(),name=character())
    # seperate each variable of the subject vector

    # loop through subjects and months

    # create dataframe for individual records
    df <- data.frame(count=numeric()) 
    
    for  (subject in subjects){
      
      # handle remote problems related to strings
      target <- str_replace(subject," ","_")

      
      for (i in 1:length(dates)) {
        yr <- year(dates[i])
 
     
        mth <- month(dates[i]) 
        if (str_length(mth)==1) {
          mth<-paste0("0",as.character(mth))
        }
       
        # obtain and process daily count data by month by target
        url <- paste0("http://stats.grok.se/json/en/",yr,mth,"/",target)
        raw.data <- readLines(url, warn="F") 
        rd  <- fromJSON(raw.data)
      	rd.views <- rd$daily_views 
      	rd.views <- unlist(rd.views)
      	rd <- as.data.frame(rd.views)
        rd$target <- target
        rd$date <- rownames(rd)
        rownames(rd) <- NULL
        print(rd)
          
        df <- rbind(df,(rd))
        
      }
    }
    return(df)
  }

  
  getData <- function(url){
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
  
term="Web_scraping"
getStats <- function(y1,y2,terms){
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
  input$date <- as.Date(input$date)
  ggplot(input,aes(date,rd.views,colour=term))+geom_line()
}

#input <- getStats(2011,2012,c("Data_mining","Web_scraping"))
#visualiseStats(input)
