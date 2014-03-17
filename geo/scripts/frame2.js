  var chart2 = d3.select("#area1").append("svg")
  .attr("width", width)
  .attr("height", height)

  var div = d3.select("#area1").append("div")   
  .attr("class", "tooltip")               
  .style("opacity", 0);



var g2 = chart2.append("g");

var filt="pro-Kremlin"

  //Reading map file and data

  queue()
    .defer(d3.json, "world.json")
    .defer(d3.csv, "out.csv")
    .defer(d3.csv,"out2.csv")
    .defer(d3.csv,"out2Ref.csv")
    .await(ready);

var rateByIdRef=d3.map()

function ready(error, map, data,data2,data2Ref) {
    data.filter(function(d){return d.orientation==filt || filt=="all"}).forEach(function(d) {
    temp.set(d.interpretedPlace,d.UN);
    dataset= data.map(function(d) { return  [d.n, d.interpretedPlace,d.UN,d.orientation] })
  })
    


tot1=tot2=0
  data2.filter(function(d){return d.orientation==filt || filt=="all"}).forEach(function(d){
        rateById[d.UN] = +d.n;
        tot1  += +d.n
  })

  data2Ref.filter(function(d){return d.orientation==filt || filt=="all"}).forEach(function(d){
        rateByIdRef[d.UN] = +d.n;
        tot2  += +d.n
  })



adjustValue=tot1/tot2
  //Drawing Choropleth
  g2.selectAll("path")
  .attr("class", "country")
  .data(topojson.feature(map, map.objects.countries).features) 
  .enter().append("path")
  .attr("class", function(d) {return (rateById[d.id]/adjustValue )> rateByIdRef[d.id] ? quantize((rateById[d.id]/adjustValue)/(rateByIdRef[d.id])) : quantize(-1*(rateByIdRef[d.id])/(rateById[d.id]/adjustValue))})

      //.attr("y", function(d) { return d.children || d._children ? -4-d.size/(sizeDiv1): -barHeight; })

    //return quantize((rateById[d.id]/adjustValue)-(rateByIdRef[d.id])); })
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

 g2.selectAll("g2.place-label")
    .data(topojson.feature(map, map.objects.countries).features)

  .enter().append("text")
    .attr("class", "place-label")
    .attr("transform", function(d) { return "translate(" + path.centroid(d) + ")"; }) //WHOO use to calculate center of each point
    .attr("dy", ".35em")
    .filter(function(d){if (Math.abs( (rateById[d.id]/adjustValue)   - (rateByIdRef[d.id]))>3) {return true;}else{return false;}})



   // .text(function(d) { return (100*((rateById[d.id])/(rateByIdRef[d.id]))).toFixed(1)})
    .text(function(d) { return Math.round(100*(rateById[d.id]/adjustValue)/(rateByIdRef[d.id]))/100})
    .style("font-size","9")



  }; // <-- End of Choropleth drawing
 

