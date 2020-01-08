
//parameters
var treetopLeft = 100;
var treetopRight = 500;
var treetopBottom = 600;
var treetopTop = 50;

var trunkWidth = 40;
var trunkHeight = 60;

var floor = treetopBottom + trunkHeight;

var baubleR = 12;
var fallingDurationConstant = 1500;
var luckFactor = 0.4;

var explosionDuration = 800;
var explosionRBegin = 0;
var explosionREnd = 42;

var svgHeight = treetopBottom + trunkHeight + 100;
var svgWidth = 600;


//prints Christmas Tree with background
var printTree = function (image) {
    // background
    image.append("rect")
        .attr("x", 0)
        .attr("y", 0)
        .attr("height", treetopBottom + trunkHeight)
        .attr("width", svgWidth)
        .attr("fill", "#eeebcf");

    // treetop
    image.append('polygon')
        .style('fill', 'green')
        .attr("points", treetopLeft + "," + treetopBottom + ", " + (treetopRight + treetopLeft) / 2 + "," + treetopTop + ", " + treetopRight + "," + treetopBottom);

    // trunk
    image.append("rect")
        .attr("x", (treetopRight + treetopLeft) / 2 - trunkWidth / 2)
        .attr("y", treetopBottom)
        .attr("height", trunkHeight)
        .attr("width", trunkWidth)
        .attr("fill", "brown");
};

// prints a bauble of given color on the Christmas Tree
// the bauble has a chance (= luckFactor) to fall and explode
var addBauble = function (image, color) {

    // uniform random point from triangle representing treetop
    var baublePos = function () {
        var r1 = Math.random();
        var r2 = Math.random();
        return {
            x: (1 - Math.sqrt(r1)) * treetopLeft + Math.sqrt(r1) * (1 - r2) * (treetopRight + treetopLeft) / 2 + r2 * Math.sqrt(r1) * treetopRight,
            y: (1 - Math.sqrt(r1)) * treetopBottom + Math.sqrt(r1) * (1 - r2) * treetopTop + r2 * Math.sqrt(r1) * treetopBottom
        };
    };

    var bauble = function (color, pos) {
        return image.append('circle')
            .attr('cx', pos.x)
            .attr('cy', pos.y + baubleR)
            .attr('r', baubleR)
            .attr('fill', color)
            .attr('stroke', 'black').on("click", function () {
                dropBauble(d3.select(this));
            });
    };

    var addStaticBauble = function (color) {
        var pos = baublePos();
        bauble(color, pos);
    };

    var baubleExplosion = function (x, y) {

        var radialAreaGenerator = d3.radialArea()
            .angle(function(d) {return d.angle;})
            .innerRadius(function() {return 0;})
            .outerRadius(function(d) {return d.r;});

        var points = function (r0) {
            return [
                {angle: 0, r: r0},
                {angle: Math.PI * 0.125, r: r0 * 0.5},
                {angle: Math.PI * 0.25, r: r0},
                {angle: Math.PI * 0.375, r: r0 * 0.4},
                {angle: Math.PI * 0.5, r: r0 * 0.6},
                {angle: Math.PI * 0.625, r: r0 * 0.4},
                {angle: Math.PI * 0.75, r: r0 * 1.1},
                {angle: Math.PI * 0.875, r: r0 * 0.5},
                {angle:  Math.PI, r: r0 * 0.7},
                {angle: Math.PI * 1.125, r: r0 * 0.5},
                {angle: Math.PI * 1.25, r: r0},
                {angle: Math.PI * 1.375, r: r0 * 0.4},
                {angle: Math.PI * 1.5, r: r0 * 0.3},
                {angle: Math.PI * 1.625, r: r0 * 0.7},
                {angle: Math.PI * 1.75, r: r0 * 0.4},
                {angle: Math.PI * 1.875, r: r0 * 0.5},
                {angle: Math.PI * 2, r: r0}
            ];
        };

        //painting explosion
        image.append("path")
            .attr("d", radialAreaGenerator(points(explosionRBegin)))
            .attr("transform", "translate(" + x + ", " + y + ")")
            .attr("fill", "#b36000")
            .transition()
            .duration(explosionDuration)
            .attr("d", radialAreaGenerator(points(explosionREnd)))
            .remove();

        //playing explosion sound
        var audio = new Audio('audio/explosion.mp3');
        audio.play();
    };

    var dropBauble = async function (bauble) {
        var posY = bauble.attr("cy");
        var posX = bauble.attr("cx");
        var duration = Math.sqrt((floor - posY) * fallingDurationConstant);

        bauble.transition().duration(duration)
            .attr("cy", floor - baubleR)
            .remove();

        // sleep(duration)
        await new Promise(r => setTimeout(r, duration));

        baubleExplosion(posX, floor - baubleR);
    };

    var addFallingBauble = async function (color) {
        var pos = baublePos();
        dropBauble(bauble(color, pos));
    };

    if (Math.random() < luckFactor) {
        addFallingBauble(color);
    } else {
        addStaticBauble(color);
    }
};