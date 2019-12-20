// dane z appki (na bieżąco aktualizowane)
var imageHeight = data[0].im_height;
var imageWidth = data[0].im_width;
var treeColor = data[0].tree_color;
var levels = data[0].levels;
var areBaubles = data[0].are_baubles;
var baubleFreq = data[0].baubles_freq;
var baubleR = data[0].baubles_size * 5;
                  
// tworzenie rdzenia svg
var svgContainer = r2d3.svg
  .append('svg')
  .attr('height', imageHeight)
  .attr('width', imageWidth);
                  
// zmienne do współrzędnych w kolejnych częściach skryptu
var xLeft = imageWidth / 10;
var xRight = imageWidth * 9 / 10;
var xMid = imageWidth / 2;
var yUp, yDown, points;
var randBau;
var isSurprise;

// funkcja zwracający losowy kolor
function getRandomColor() {
  var letters = '0123456789ABCDEF';
  var color = '#';
  for (var i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}

// funkcja generująca (albo i nie) bombkę
function generateCircle(x, y, r, percentOfBeingCreated)
{
  randBau = Math.random() * 100;
  
  // jeżeli bombka została "wylosowana"
  if(randBau <= percentOfBeingCreated)
  {
    // skalowanie r (zależnie od wielkości obrazka)
    r = r * Math.min(imageHeight, imageWidth) / 400;
      
    // dodawanie bombki
    svgContainer
      .append('circle')
      .attr('cx', x)
      .attr('cy', y + r * 4 / 5)
      // promienie jednostajnie wylosowane z przedziału <3/4 * r; 5/4 * r>
      .attr('r', r + Math.random() * r / 8 - Math.random() * r / 4)
      .attr('fill', getRandomColor());
  }
}

// funkcja generująca cały rysunek
function generateDrawing()
{
  // za każdą zmianą czyścimy ekran...
  d3.selectAll("svg > *").remove();
  
  // ...i zaczynamy wszystko od nowa
  svgContainer = r2d3.svg
    .append('svg')
    .attr('height', imageHeight)
    .attr('width', imageWidth);

  // produkujemy <levels> poziomów choinki
  var i;
  for(i = 0; i < levels; i++)
  {
    yUp = imageHeight / 20 + imageHeight * i * 7 / (levels + 1) / 8; // >= 20
    yDown = imageHeight / 20 + imageHeight * (i+2) * 7 / (levels + 1) / 8; // <= 370
    
    points = xLeft.toString().concat(',', yDown.toString(), ' ',
                         xRight.toString(), ',', yDown.toString(), ' ',
                         xMid.toString(), ',', yUp.toString());
    
    svgContainer.data(r2d3.data)
      .append('polygon')
      .attr("points", points)
      .attr("fill", treeColor);
  }
  
  // generujemy bombki (jeżeli opcja <areBaubles> zaznaczona)
  if(areBaubles)
    for(i = -1; i < levels; i++)
    {
      yUp = imageHeight / 20 + imageHeight * i * 7 / (levels + 1) / 8; // >= 20
      yDown = imageHeight / 20 + imageHeight * (i+2) * 7 / (levels + 1) / 8; // <= 370
      
      if(i >= 0) // bombki na najwyższym poziomie
      {
        generateCircle(xLeft + Math.random() * imageWidth / 8, yDown, baubleR, baubleFreq);
        generateCircle(xRight - Math.random() * imageWidth / 8, yDown, baubleR, baubleFreq);
      }
      
      if(i != levels - 1) // dla najniższego poziomu nie tworzymy "środkowych"
      {
        if(i >= 0) // bombki boczne nie na najwyższym piętrze - żeby nie wychodziły poza rysunek
        {
          generateCircle(xMid + imageHeight / 6 + Math.random() * imageWidth / 8 - imageWidth / 16,
                        yDown + Math.random() * imageWidth / 8 - imageWidth / 16,
                        baubleR, baubleFreq);
          generateCircle(xMid - imageHeight / 6 + Math.random() * imageWidth / 8 - imageWidth / 16,
                        yDown + Math.random() * imageWidth / 8 - imageWidth / 16,
                        baubleR, baubleFreq);
        }
        
        generateCircle(xMid + Math.random() * imageWidth / 8 - imageWidth / 16,
                       yDown + Math.random() * imageWidth / 8 - imageWidth / 16,
                       baubleR, baubleFreq);
      }
    }
    
  // pień
  svgContainer.data(r2d3.data)
    .append('rect')
    .attr('x', xMid - imageWidth / 10)
    .attr('y', imageHeight - imageHeight * 3 / 40)
    .attr('width', imageWidth / 5)
    .attr('height', imageHeight * 3 / 40)
    .attr('fill', "brown");
    
  // tekst "niespodzianka"
  isSurprise = Math.random();
  if(isSurprise >= 0.95)
    svgContainer.data(r2d3.data)
      .append('text')
      .text("Merry Christmas :DD")
      .attr('x', 0)
      .attr('y', imageHeight / 2 + imageWidth / 20)
      .style('fill', "red")
      .style('font-size', imageWidth / 10)
      .style('font-family', "Comic Sans MS"); // najlepsza czcionka kiedykolwiek
}

generateDrawing(); // tworzy nowy obrazek wraz z każdą zmianą