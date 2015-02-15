
  // Setting color domains(intervals of values) for our map
  var svg = d3.select("#area2").append("svg")
  .attr("width", width)
  .attr("height", height);

  var div = d3.select("#area2").append("div")   
  .attr("class", "tooltip")               
  .style("opacity", 0);




var g = svg.append("g");


var filtLib="liberal"

mm = function(data,value ) {
  //console.log(value)
  dat=data
  var p=[]
    for( var i in dat ) {
             if( dat[ i ][2] == value )
                  if (dat[i][3]==filtLib){
                      p.push(dat[i][1]+": "+dat[i][0]+"<br/>")
                    }
    }
     return(p)
}

mm2 = function(dat,value ) {
  var p=[]
    for( var i in dat ) {
             if( dat[ i ][2] == value )
                  if (dat[i][3]==filtLib){
                      p.push(dat[i][1])
                    }
    }
     return(p)
}



addUp = function(target,data) {
  var p=0
  dat=data
    for( i in dat) {
             if( dat[ i ][2] == target ){
                if (dat[i][3]==filtLib){
                    p=p+parseInt(dat[i][0])
              }
             }
    }
     return(p)
}


  queue()
    .defer(d3.json, "world.json")
    .defer(d3.csv, "out.csv")
    .defer(d3.csv,"out2.csv")
    .defer(d3.csv,"out2Ref.csv")
    .await(ready);

var rateByIdRef=d3.map()

console.log(filtLib)
function ready(error, map, data,data2,data2Ref) {
    data.filter(function(d){return d.orientation==filtLib || filtLib=="all"}).forEach(function(d) {
    temp.set(d.interpretedPlace,d.UN);
    dataset= data.map(function(d) { return  [d.n, d.interpretedPlace,d.UN,d.orientation] })
  })
    


tot1=tot2=0
  data2.filter(function(d){return d.orientation==filtLib || filtLib=="all"}).forEach(function(d){
        rateById[d.UN] = +d.n;
        tot1  += +d.n
  })

  data2Ref.filter(function(d){return d.orientation==filtLib || filtLib=="all"}).forEach(function(d){
        rateByIdRef[d.UN] = +d.n;
        tot2  += +d.n
  })



adjustValue=tot1/tot2
  //Drawing Choropleth
  g.selectAll("path")
  //svg.append("g")
  .attr("class", "country")
  .data(topojson.feature(map, map.objects.countries).features) 
  .enter().append("path")
  .attr("class","q2-9")
  .attr("class", function(d) {return (rateById[d.id]/adjustValue )> rateByIdRef[d.id] ? quantize((rateById[d.id]/adjustValue)/(rateByIdRef[d.id])) : quantize(-1*(rateByIdRef[d.id])/(rateById[d.id]/adjustValue))})
 .attr("d", path)
  .style("opacity", 1)

  //Adding mouseevents
  .on("mouseover", function(d) {
    d3.select(this).transition().duration(10).style("opacity", 1);
    div.transition().duration(10)
    .style("opacity", 0.8)

    sss=temp[d.id]
    console.log(d.id)
    mainBody=(mm(dataset,d.id))
    country=(getCountry(mm2(dataset,d.id)))
   // console.log(getCountry(mainBody))
    //nArticles=addUp(sss,dataset)
    nArticles=addUp(d.id,dataset)
    div.html("<strong>"+country + " : " + nArticles+"</strong><br/><br/>"+mainBody)
    .style("left", (d3.event.pageX) + "px")
    .style("top", (d3.event.pageY -30) + "px");
  })
  .on("mouseout", function() {
    d3.select(this)
    .transition().duration(10)
    .style("opacity", 1);
    div.transition().duration(10)
    .style("opacity", 0);
  })
  
   // Adding cities on the map

   //var peopleTable = tabulate(dataset, [1,3, 0]);

 g.selectAll("g.place-label")
    .data(topojson.feature(map, map.objects.countries).features)

  .enter().append("text")
    .attr("class", "place-label")
    .attr("transform", function(d) { return "translate(" + path.centroid(d) + ")"; }) //WHOO use to calculate center of each point
    .attr("dy", ".35em")
    .filter(function(d){if (Math.abs( (rateById[d.id]/adjustValue)   - (rateByIdRef[d.id]))>3) {return true;}else{return false;}})

    .text(function(d) { return Math.round(100*(rateById[d.id]/adjustValue)/(rateByIdRef[d.id]))/100})
    .style("font-size","9")



  }; // <-- End of Choropleth drawing
 
  //Adding legend for our Choropleth


