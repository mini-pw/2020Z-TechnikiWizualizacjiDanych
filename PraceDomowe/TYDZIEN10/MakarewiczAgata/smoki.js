// usuwamy poprzedni obrazek
svg.selectAll('*').remove();

// podana liczba kubełków 
var bins_number = data[0].bins_number;
// kolor smoków/wykresu
var color = data[0].color

// ustawiamy wymiary naszego wykresu
var margin = {top: 10, right: 30, bottom: 30, left: 40},
    width = 700 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// dodajemy obiekt svg do strony
svg.attr("width", width + margin.left + margin.right+80)
    .attr("height", height + margin.top + margin.bottom+100)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");
          
// tworzymy oś OX
var x = d3.scaleLinear()
    .domain([0, d3.max(data, function(d) {return d.Age;})])
    .range([0, width]);
    
// dodajemy do wykresu 
// (translate(80,410) - przesunięcie po to aby można było dodać estetyczne opisy osi i tytuł wykresu)  
svg.append("g")
  .attr("transform", "translate(80," + 410 + ")")
  .call(d3.axisBottom(x))
  .selectAll("text")
    .attr("transform", "translate(-10,0)rotate(-45)")
    .style("text-anchor", "end");

// tworzymy histogram
var histogram = d3.histogram()
    .value(function(d) { return d.Age; }) // kolumna z której wartosci rozważamy (Age)
    .domain(x.domain()) // dziedzina
    // tworzymy zakresy poszczególnych kubełków ( max-min / podana liczba kubełków )
    .thresholds(d3.range(d3.min(data, function(d) {return d.Age;}), x.domain()[1],
    (x.domain()[1]-d3.min(data, function(d) {return d.Age;}))/(bins_number)));
    
var bins = histogram(data);

// tworzymy oś OY
var y = d3.scaleLinear()
  .range([height, 0])
  .domain([0, d3.max(bins, function(d) { return d.length; })]);

// dodajemy oś OY do wykresu i tak jak w przypadku osi OX przesuwamy tak aby estetycznie wyglądało
svg.append("g")
  .attr("transform", "translate(80, 50)")
  .call(d3.axisLeft(y));
  
// dodajemy opisy obu osi orz tytuł wykresu

svg.append("text")
  .attr("class", "title")
  .attr("transform", "translate(" + (width/2+50) + " ," + 
                           (20) + ")")
  .style("text-anchor", "middle")
  .style('font-family', 'Comic Sans MS')
  .style("font-size", "25px")
  .text("How old are dragons which are still alive?");      

svg.append("text")
  .attr("class", "title")
  .attr("transform", "translate(" + (width/2+50) + " ," + 
                           (height + margin.top + 100) + ")")
  .style("text-anchor", "middle")
  .style('font-family', 'Comic Sans MS')
  .style("font-size", "18px")
  .text("Age (years)");      
  
svg.append("text")
  .attr("class", "title")
  .attr("transform", "rotate(-90)")
  .attr("y", 35)
  .attr("x", -200)
  .style("text-anchor", "middle")
  .style('font-family', 'Comic Sans MS')
  .style("font-size", "18px")
  .text("Count");

  

// dodajemy tooltip - ułatwia odczytanie wykresu zwłaszcza gdy liczba kubełków jest duża
// po najechaniu myszką na słupek wyświetla informację ile żyje smoków w danym przedziale wiekowym
var tooltip = d3.select("body").append("div")	
  .attr("class", "tooltip")				
  .style("opacity", 0)
  .style("background-color", "black")
  .style("color", "white")
  .style("border-radius", "5px")
  .style("padding", "10px");

var showTooltip = function(d) {
    tooltip
      .transition()
      .duration(100)
      .style("opacity", 1);
    tooltip
      .html("Age: " + d3.format("d")(d.x0) + " - " + d3.format("d")(d.x1)
      + "<br/>" + "Count: " + d.length )
      .style("left", (d3.mouse(this)[0]+20) + "px")
      .style("top", (d3.mouse(this)[1]) + "px");
  };
  
var moveTooltip = function(d) {
    tooltip
      .style("left", d3.event.pageX+20  + "px")
      .style("top", d3.event.pageY-20 + "px");
  };

var hideTooltip = function(d) {
    tooltip
      .transition()
      .duration(100)
      .style("opacity", 0);
  };
  
// dodajemy słupki histogramu do wykresu - ich współrzędne równiez musimy przesunąc, tak jak osie    
svg.selectAll("rect")
    .data(bins)
    .enter()
    .append("rect")
      //.attr("x", 1)
      //.attr("transform", function(d) { return "translate(" + x(d.x0) + "," + y(d.length) + ")"; })
      .attr("x", function(d) { return x(d.x0)+80 ; })
      .attr("y", function(d) { return y(d.length)+50; })
      .attr("width", function(d) { return x(d.x1) - x(d.x0) -1 ; })
      .attr("height", function(d) { return height - y(d.length); })
      .style("fill", color)
      .on("mouseover", showTooltip )
      .on("mousemove", moveTooltip )
      .on("mouseleave", hideTooltip );
      