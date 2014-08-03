var stage = new Kinetic.Stage({
  container: 'board',
  width: 600,
  height: 400
});

var foregroundLayer = new Kinetic.Layer();

// background
var backgroundLayer = new Kinetic.Layer();
var background = new Kinetic.Rect({
    fill: '#aaa',
    x : 0,
    y : 0,
    width : 600,
    height : 400
});
backgroundLayer.add(background);


var centerX = stage.width()/2;
var centerY = stage.height()/2;

var Player = function(){
    var config = {
        fill: 'green',
        x : 0,
        y : centerY-40,
        width: 15,
        height: 80,
    };
    Kinetic.Rect.call(this, config);
};
Player.prototype = new Kinetic.Rect({});
Player.prototype.constructor = Player;

var player = new Player();

foregroundLayer.add(player);
stage.add(backgroundLayer);
stage.add(foregroundLayer);

var amplitude = 150;
var period = 2000;
// in ms


var anim = new Kinetic.Animation(function(frame) {
  var newY = amplitude * Math.sin(frame.time * 2 * Math.PI / period) + centerY-40;
  player.setY(newY);
}, foregroundLayer);

anim.start();