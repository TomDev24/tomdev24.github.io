$("document").ready(function(){
    var slideAmount = $(".carousel-inner").children().length;
    var cards = $("#accordion").children();
    var eventHandlers = [];
        
    for (var i = 0; i < slideAmount; i++) {
        eventHandlers[i] = function(index){
            $(cards[index]).children()[0].click()
            $('html, body').animate({
                scrollTop: $(cards[index]).offset().top
            }, 1000);
        }
    }
    $(".carousel-caption").on('click', function(){
        var index = $(this).attr("data-slide");
        eventHandlers[index](index);
    })

    function resetBodyCss(){
      $("body").css("background-image", 'none');
      $("body").css("background-color", '#fff');
    }
    $("#treasureBtn").on('click', function(){
      resetBodyCss()
      $("body").css("background-image", 'url("./media/head.png")')
    })
    $("#wolfBtn").on('click', function(){
      resetBodyCss()
      $("body").css("background-color", '#FD5D5D')
    })
    $("#yamiBtn").on('click', function(){
      resetBodyCss()
      $("body").css("background-image", 'url("./media/yami-logo.png")')
    })
    $("#telegramBtn").on('click', function(){
      resetBodyCss()
      $("body").css("background-color", '#2aabee')
    })
    $("#ravenousBtn").on('click', function(){
      resetBodyCss()
      $("body").css("background-color", '#cca353')
    })
})

//Access the Rendering Context of Canvas to Play with it
var myCanvas = document.getElementById("myCanvas");
myCanvas.height =
  window.innerHeight ||
  document.documentElement.clientHeight ||
  document.body.clientHeight; //height of the canvas
myCanvas.width =
  window.innerWidth ||
  document.documentElement.clientWidth ||
  document.body.clientWidth; //width of the canvas
var moveIt = myCanvas.getContext("2d"); //returns a drawing context on the canvas

var deltaX = 100;
var deltaY = 100;
//addEventListener() works by adding a function or an object that implements EventListener to the list of event listeners for the specified event type on the EventTarget on which it's called
window.addEventListener("keydown", keysPressed, false);
window.addEventListener("keyup", keysReleased, false);

//Store the Key events in Array
var keys = [];
//On Key Down
function keysPressed(e) {
  // store an entry for every key pressed
  keys[e.keyCode] = true;
  // left
  if (keys[37]) {
    deltaX -= 5;
  }
  // right
  if (keys[39]) {
    deltaX += 5;
  }
  // down
  if (keys[38]) {
    deltaY -= 5;
  }
  // up
  if (keys[40]) {
    deltaY += 5;
  }

  e.preventDefault();
}

//On Key Up
function keysReleased(e) {
  // mark keys that were released
  keys[e.keyCode] = false;
}

//Now Let the Magic begins...
function drawCircle(x, y) {
    //starts a new path by emptying the list of sub-paths. Call this method when you want to create a new path.
  moveIt.beginPath();
      //adds an arc to the path which is centered at (x, y) position with radius r starting at startAngle and ending at endAngle going in the given direction by anticlockwise (defaulting to clockwise)
  moveIt.arc(x, y, 20, 0, 2 * Math.PI, true);
    //causes the point of the pen to move back to the start of the current sub-path. It tries to add a straight line (but does not actually draw it) from the current point to the start. If the shape has already been closed or has only one point, this function does nothing
  moveIt.closePath();
  //specifies the color or style to use inside shapes  
  moveIt.fillStyle = "rgb(255, 0, 0)";
  //fills the current or given path with the current fill style using the non-zero or even-odd winding rule

  moveIt.fill();
}

//Request Animation Frame
function animate() {
    //sets all pixels in the rectangle defined by starting point (x, y) and size (width, height) to transparent black, erasing any previously drawn content
  moveIt.clearRect(0, 0, myCanvas.width, myCanvas.height);
  drawCircle(deltaX, deltaY);
  //tells the browser that you wish to perform an animation and requests that the browser call a specified function to update an animation before the next repaint
  requestAnimationFrame(animate);
}
animate();

