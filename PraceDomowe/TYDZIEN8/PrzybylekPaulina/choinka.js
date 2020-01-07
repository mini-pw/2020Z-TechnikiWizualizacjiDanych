var bombki = data[0].bombki; //liczba bombek
var kolory = data[0].kolory; //kolor bombek
var wysokoscchoinki = data[0].wysokosc; //wysokosc choinki
var gwiazda = data[0].gwiazda; //czy chcemy gwiazdke
var lancuch = data[0].lancuch; //czy chcemy lancuch
var kolorlancucha = data[0].kolorlancucha; //w jakim kolorze lancuch
var lampeczki = data[0].lampeczki; //liczba lampek

//rozmiar obrazka
var rozmiar = {x:500, y:500};
svg.style('background', '#FAF0E6');
svg.selectAll('*').remove();

//choinka

var podstawachoinki = 300;
var tangenskataprzypodstawie = wysokoscchoinki/(podstawachoinki/2); //Math.tan(katprzypodstawie / 180 * Math.PI)

function szerokoscchoinki(y){
  // Funkcja zwraca szerokość choinki na wysokosci y
  var wysokosc = Math.floor(rozmiar.y - 75 - y);
  return 2 * Math.floor((wysokoscchoinki - wysokosc) / tangenskataprzypodstawie);
}

			
//pien choinki
svg.append('rect')
            .attr('x', rozmiar.x/2 - 20)
            .attr('y', rozmiar.y - 75)
            .attr('width', 40)
            .attr('height', 50)
            .attr('fill', 'brown');

var ilosc = 100;

//chcemy zrobic choinke z malych trojkacikow, ktore maja imitowac galazki 
var trojkat = d3.symbol()
            .type(d3.symbolTriangle)
            .size(200);
            
//polozenie trojkatow - skala na ktorej beda one rysowane
var Y = [];
var ymax = rozmiar.y - 75 + 10;
var ymin = rozmiar.y - 75 - wysokoscchoinki - 10;
  
while(ymin < ymax) {
  Y.push(ymin);
  ymin = ymin + 15;
}

var Xskala = [];
var Yskala = [];
for(var i = 0; i < Y.length; i++){
    var szerokosc = szerokoscchoinki(Y[i]);
    var xmin = (rozmiar.x - szerokosc)/2;
    var xmax = xmin + szerokosc;
    while( xmin < xmax){
      Xskala.push(xmin);
      Yskala.push(Y[i]);
      xmin = xmin + 5;
    }
}

//dodawanie malych trojkacikow
for (var j = 0; j < Yskala.length; j++){
  
var kolor = ['#006400', '#556B2F', '#8FBC8F', '#228B22', '#90EE90', '#008000'];
var losowo = Math.floor(Math.random()*kolory.length);

svg.append('path')
            .attr('d', trojkat)
            .attr('stroke', 'none')
            .attr('fill', kolor[losowo])
            .attr('transform', 'translate(' + Xskala[j] + ',' + Yskala[j] + ')');
}
        
            
//gwiazdka

if(gwiazda){

//korzystamy z symbolu gwiazdki
var star = d3.symbol()
            .type(d3.symbolStar)
            .size(500);
            
var szczyt = rozmiar.y - 90 - wysokoscchoinki; //powinnismy odjac 75, aby czubek choinki zgadzal sie z gwiazdka, ale ja chcialam aby ona byla wyzej
            
svg.append('path')
            .attr('d', star)
            .attr('stroke', 'none')
            .attr('fill', '#DAA520')
            .attr('transform', 'translate('+ 250 + ',' + szczyt + ')' ); 
}
            

//bombki

//tworzymy skale Y dla bombek, od niej zalezy skala X
var Ybombki =  d3.range(bombki).map(function(){
  var ymax = rozmiar.y - 75;
  var ymin = rozmiar.y - 75 - wysokoscchoinki; 
  var Y = Math.floor(Math.random()*(ymax - ymin + 1)) + ymin;
  return {y: Y};
  });

svg.selectAll('circle')
            .data(Ybombki)
            .enter()
            .append('circle')
            .attr('cy', function(d) {return d.y; })
            .attr('cx', function(d){
              var szerokosc = szerokoscchoinki(d.y);
              var xmin = (rozmiar.x - szerokosc)/2;
              var xmax = xmin + szerokosc;
              return Math.floor(Math.random()*(xmax - xmin + 1)) + xmin;
            })
            .attr('r', function(d) { return Math.floor(Math.random()*(9 - 4)) + 4})
            .attr('fill', kolory);


//lampki

//bierzemy lement diamentu
var lampka = d3.symbol()
            .type(d3.symbolDiamond)
            .size(100);
            
//tworzymy skale dla lampek
var Ylampki = [];
var k = 0;

while(k < lampeczki){
  var ymax = rozmiar.y - 75;
  var ymin = rozmiar.y - 75 - wysokoscchoinki + 30; 
  Ylampki.push(Math.floor(Math.random()*(ymax - ymin + 1)) + ymin);
  k++;
}          
  
var Xlampki = [];
for(var l = 0; l < Ylampki.length; l++){
  var szerokosc = szerokoscchoinki(Ylampki[l]);
  var xmin = (rozmiar.x - szerokosc)/2;
  var xmax = xmin + szerokosc;
  Xlampki.push(Math.floor(Math.random()*(xmax - xmin + 1)) + xmin);
}
                
//rysujemy lampeczki
for (var j = 0; j < Ylampki.length; j++){
  svg.append('path')
            .attr('d', lampka)
            .attr('stroke', 'none')
            .attr('fill', '#B0E0E6')
            .attr('transform', "translate(" + Xlampki[j] + "," + Ylampki[j] + ")")
            .transition()
            .duration(100)
            .on('start', function powtarzaj(){
                d3.active(this)
                .transition()
                .duration(100)
                .delay(50)
                .attr('fill','#ADD8E6')
                .transition()
                .duration(100)
                .delay(50)
                .attr('fill', '#FFFFE0')
                .on('end', powtarzaj)});
}  


//lancuch

function lancuchpunkty(y) {
  //funckja wyznacza punkty na osi x lancucha dla danego y
  var szerokosc = szerokoscchoinki(y);
  var x1 = (rozmiar.x - szerokosc)/2 - 5;
  var x2 = x1 + szerokosc + 15;
  return [x1,x2];
}

if (lancuch){
  
//dzielimy choinke na 4 i wyznaczamy 3 miejsca na lancuch
var Ylancuch = Math.floor(wysokoscchoinki/4);
var y1 = rozmiar.y - 75 - Ylancuch;
var y2 = y1 - Ylancuch;
var y3 = y2 - Ylancuch;

var lancuch1 = lancuchpunkty(y1);
var lancuch2 = lancuchpunkty(y2);
var lancuch3 = lancuchpunkty(y3);
var grubosc = 10;

//rysujemy lancuchy
svg.append('line')
    .style('stroke', kolorlancucha)
    .style('stroke-width', grubosc)
    .style('stroke-linecap', 'round')
    .attr('x1', lancuch1[0])
    .attr('y1', y1)
    .attr('x2', lancuch1[1])
    .attr('y2', y1 + 20);
    
svg.append('line')
    .style('stroke', kolorlancucha)
    .style('stroke-width', grubosc)
    .style('stroke-linecap', 'round')
    .attr('x1', lancuch2[0])
    .attr('y1', y2)
    .attr('x2', lancuch2[1])
    .attr('y2', y2 + 20);
    
svg.append('line')
    .style('stroke', kolorlancucha)
    .style('stroke-width', grubosc)
    .style('stroke-linecap', 'round')
    .attr('x1', lancuch3[0])
    .attr('y1', y3)
    .attr('x2', lancuch3[1])
    .attr('y2', y3 + 20);

}