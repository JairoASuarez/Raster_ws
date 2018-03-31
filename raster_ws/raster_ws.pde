import frames.timing.*;
import frames.primitives.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean shading = true;
boolean aliasing = true;
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

void setup() {
  //use 2^n to change the dimensions
  size(512, 512, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it :)
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    public void execute() {
      spin();
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow( 2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  anti_aliasing();
  shading();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.coordinatesOf converts from world to frame
  // here we convert v1 to illustrate the idea
  if (debug) {
    float x1, x2, x3, y1, y2, y3, a, b, c;
    x1 = round(frame.coordinatesOf(v1).x());
    x2 = round(frame.coordinatesOf(v2).x());
    x3 = round(frame.coordinatesOf(v3).x());
    y1 = round(frame.coordinatesOf(v1).y());
    y2 = round(frame.coordinatesOf(v2).y());
    y3 = round(frame.coordinatesOf(v3).y());
    pushStyle();
    stroke(255, 255, 0, 255);
    for(float x = -pow(2, n); x <= pow(2, n); x+=1.0){
      for(float y = -pow(2, n); y <= pow(2,n); y+=1.0){
        a = ((y2-y3)*(x-x3) + (x3-x2)*(y-y3)) / ((y2-y3)*(x1-x3) + (x3-x2)*(y1-y3));
        b = ((y3-y1)*(x-x3) + (x1-x3)*(y-y3)) / ((y2-y3)*(x1-x3) + (x3-x2)*(y1-y3));
        c = 1-a-b;
        //println(a, b, c);
        if(0.0 < a && a < 1.0 && 0.0 < b && b < 1.0 && 0.0 < c && c < 1.0){
          point(round(x), round(y));
        }
      }
    }
    popStyle();
  }
}

void anti_aliasing(){
  if(aliasing){
    float range = 0.01;
    float x1, x2, x3, y1, y2, y3, a, b, c;
    x1 = round(frame.coordinatesOf(v1).x());
    x2 = round(frame.coordinatesOf(v2).x());
    x3 = round(frame.coordinatesOf(v3).x());
    y1 = round(frame.coordinatesOf(v1).y());
    y2 = round(frame.coordinatesOf(v2).y());
    y3 = round(frame.coordinatesOf(v3).y());
    pushStyle();
    stroke(255, 255, 127, 50);
    //stroke(100, 100, 100);
    for(float x = -pow(2, n); x <= pow(2, n); x+=1.0){
      for(float y = -pow(2, n); y <= pow(2,n); y+=1.0){
        a = ((y2-y3)*(x-x3)+(x3-x2)*(y-y3))/((y2-y3)*(x1-x3)+(x3-x2)*(y1-y3));
        b = ((y3-y1)*(x-x3)+(x1-x3)*(y-y3))/((y2-y3)*(x1-x3)+(x3-x2)*(y1-y3));
        c = 1-a-b;
        if (0.0 < a && a < 1.0 && 0.0 < b && b < 1.0 && 0.0 < c && c < 1.0){
          if(a < range || b < range || c < range)
            point(round(x), round(y));
        }
      }
    }
    popStyle();
  }
}

void shading(){
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void spin() {
  if (scene.is2D())
    scene.eye().rotate(new Quaternion(new Vector(0, 0, 1), PI / 100), scene.anchor());
  else
    scene.eye().rotate(new Quaternion(yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100), scene.anchor());
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == 'a')
    aliasing = !aliasing;
  if (key == 's')
    shading = !shading;
  if (key == '+') {
    n = n < 9 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 9;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}