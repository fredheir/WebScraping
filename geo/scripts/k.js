
var width = 900,
    height = width/2.2,
    tot1 =0;

var svg = d3.select("#mapContainer").append("svg")
  .attr("width", width)
  .attr("height", height)
  .style("margin", "10px auto");


var projection = d3.geo.mercator()
    .center([30, 30])
    .scale(150)
    .translate([width / 2, height / 2]);

var path = d3.geo.path().projection(projection);


var rateById = {};


var quantize = d3.scale.quantize()
    .domain([2000,0])
    .range(d3.range(9).map(function(i) { return "q" + i + "-9"; }));



queue()
    .defer(d3.json, "world.json")
    .defer(d3.csv,"out2.csv")
    .await(ready);



function ready(error, worldmap,data2) {

  map =topojson.feature(worldmap, worldmap.objects.countries).features
  data2.forEach(function(d){
        rateById[d.UN] = +d.n;
        tot1  += +d.n
  })


  svg.append("g")
  .selectAll("path")
  .data(map) 
  .enter().append("path")
  .attr("class", function(d) { return quantize(rateById[d.id]); })
  .attr("d", path)


  svg.selectAll("labels")
  .data(map) 
  .enter().append("text")
  .attr("transform", function(d) { return "translate(" + path.centroid(d) + ")"; }) //WHOO use to calculate center of each point
  .filter(function(d){return rateById[d.id]>600 || rateById[d.id]<50})
  .text(function(d) {return(rateById[d.id])})



  }; 
 