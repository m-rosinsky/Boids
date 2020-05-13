float viewAngle = 360;
int viewDistance = 50;
float mSpeed = 4.0;
float mForce = 1.0;

int numBoids = 50;

int edgeBuffer = 0;

boolean showViews = false;
boolean showDetectLines = false;

float separationFactor = 1;
float alignFactor = .5;
float cohesionFactor = 1;
float fleeFactor = 2;

float PredatorSpeed = 2.0;
int numPredators = 3;

Boid[] boids;
Predator[] predators;

class Boid {
  PVector pos;
  PVector vel;
  PVector accel;
  
  float maxSpeed;
  float maxForce;
  
  color c;
  Boid() {
    this.pos = new PVector(random(width), random(height));
    this.vel = PVector.random2D();
    this.accel = new PVector();
    this.c = color(0,153,255);
    this.maxSpeed = mSpeed;
    this.maxForce = mForce;
  }
  
  void show() {
    strokeWeight(6);
    stroke(this.c);
    point(this.pos.x, this.pos.y);
  }
  
  void showViews() {
    stroke(255);
    strokeWeight(1);
    noFill();
    arc(this.pos.x, this.pos.y, viewDistance*2, viewDistance*2, this.vel.heading()-(viewAngle/2), this.vel.heading()+(viewAngle/2), PIE);
  }
  
  void update() {
    this.pos.add(this.vel);
    this.vel.add(this.accel);
    this.vel.limit(this.maxSpeed);
    this.accel.mult(0);
  }
  
  void applyAccel(Boid[] boids) {
    PVector sep = this.separation(boids);
    PVector coh = this.cohesion(boids);
    PVector align = this.alignment(boids);
    PVector flee = this.flee(predators);
    
    sep.mult(separationFactor);
    coh.mult(cohesionFactor);
    align.mult(alignFactor);
    flee.mult(fleeFactor);
    
    this.accel.add(sep);
    this.accel.add(coh);
    this.accel.add(align);
    this.accel.add(flee);
  }
  
  void loopBack() {
    if (this.pos.x > width-edgeBuffer) {
      this.pos.x = edgeBuffer;
    } else if (this.pos.x < 0+edgeBuffer) {
      this.pos.x = width-edgeBuffer;
    }
    if (this.pos.y > height-edgeBuffer) {
      this.pos.y = edgeBuffer;
    } else if (this.pos.y < 0+edgeBuffer) {
      this.pos.y = height-edgeBuffer;
    }
  }
  
  void drawDetectionLines(Boid[] boids) {
    for (Boid otherBoid : boids) {
      if (canDetect(otherBoid)) {
        stroke(255,153,0);
        strokeWeight(1);
        line(this.pos.x, this.pos.y, otherBoid.pos.x, otherBoid.pos.y);
      }
    }
  }
  
  PVector separation(Boid[] boids) {
    PVector turn = new PVector();
    int boidsInView = 0;
    for (Boid otherBoid : boids) {
      float dist = dist(this.pos.x, this.pos.y, otherBoid.pos.x, otherBoid.pos.y);
      if (otherBoid != this && canDetect(otherBoid)) {
        PVector diff = PVector.sub(this.pos, otherBoid.pos);
        diff.div(dist*dist);
        turn.add(diff);
        boidsInView++;
      }
    }
    if (boidsInView > 0) {
      turn.div(boidsInView);
      turn.setMag(this.maxSpeed);
      turn.sub(this.vel);
      turn.limit(this.maxForce);
    }
    return turn;
  }
  
  PVector cohesion(Boid[] boids) {
    PVector turn = new PVector();
    int boidsInView = 0;
    for (Boid otherBoid : boids) {
      if (otherBoid != this && canDetect(otherBoid)) {
        turn.add(otherBoid.pos);
        boidsInView++;
      }
    }
    if (boidsInView > 0) {
      turn.div(boidsInView);
      turn.sub(this.pos);
      turn.setMag(this.maxSpeed);
      turn.sub(this.vel);
      turn.limit(this.maxForce);
    }
    return turn;
  }
  
  PVector alignment(Boid[] boids) {
    PVector turn = new PVector();
    int boidsInView = 0;
    for (Boid otherBoid : boids) {
      if (otherBoid != this && canDetect(otherBoid)) {
        turn.add(otherBoid.vel);
        boidsInView++;
      }
    }
    if (boidsInView > 0) {
      turn.div(boidsInView);
      turn.setMag(this.maxSpeed);
      turn.sub(this.vel);
      turn.limit(this.maxForce);
    }
    return turn;
  }
  
  PVector flee(Predator[] preds) {
    PVector turn = new PVector();
    int boidsInView = 0;
    for (Predator pred : preds) {
      float dist = dist(this.pos.x, this.pos.y, pred.pos.x, pred.pos.y);
      if (canDetectPred(pred)) {
        PVector diff = PVector.sub(this.pos, pred.pos);
        diff.div(dist*dist);
        turn.add(diff);
        boidsInView++;
      }
    }
    if (boidsInView > 0) {
      turn.div(boidsInView);
      turn.setMag(this.maxSpeed);
      turn.sub(this.vel);
      turn.limit(this.maxForce);
    }
    return turn;
  }
  
  boolean canDetect(Boid otherBoid) {
    float dist = dist(this.pos.x, this.pos.y, otherBoid.pos.x, otherBoid.pos.y);
    PVector toOther = new PVector(otherBoid.pos.x-this.pos.x,otherBoid.pos.y-this.pos.y);
    float a = PVector.angleBetween(this.vel, toOther);
    a = (a + TWO_PI) % TWO_PI;
    if (dist <= viewDistance && this.vel.heading() + abs(a) < this.vel.heading() + (viewAngle/2)) {
      return true;
    }
    return false;
  }
  
  boolean canDetectPred(Predator predator) {
    float dist = dist(this.pos.x, this.pos.y, predator.pos.x, predator.pos.y);
    PVector toOther = new PVector(predator.pos.x-this.pos.x,predator.pos.y-this.pos.y);
    float a = PVector.angleBetween(this.vel, toOther);
    a = (a + TWO_PI) % TWO_PI;
    if (dist <= viewDistance && this.vel.heading() + abs(a) < this.vel.heading() + (viewAngle/2)) {
      return true;
    }
    return false;
  }
}

class Predator {
  
  float speed;
  
  PVector pos;
  PVector vel;
  
  Predator() {
    this.speed = PredatorSpeed;
    this.pos = new PVector(random(width), random(height));
    this.vel = PVector.random2D();
  }
  
  void show() {
    stroke(255,153,0);
    strokeWeight(10);
    point(this.pos.x, this.pos.y);
  }
  
  void update() {
    vel.setMag(this.speed);
    this.pos.add(this.vel);
  }
  
  void loopBack() {
    if (this.pos.x > width-edgeBuffer) {
      this.pos.x = edgeBuffer;
    } else if (this.pos.x < 0+edgeBuffer) {
      this.pos.x = width-edgeBuffer;
    }
    if (this.pos.y > height-edgeBuffer) {
      this.pos.y = edgeBuffer;
    } else if (this.pos.y < 0+edgeBuffer) {
      this.pos.y = height-edgeBuffer;
    }
  }
}

void setup() {
  size(760,500);
  
  background(51,25);
  
  frameRate(60);
  
  boids = new Boid[numBoids];
  for (int i = 0; i < numBoids; i++) {
    boids[i] = new Boid();
  }
  
  predators = new Predator[numPredators];
  for (int i = 0; i < numPredators; i++) {
    predators[i] = new Predator();
  }
   
  viewAngle = radians(viewAngle);
  
}

void draw() {
  fill(51,75);
  noStroke();
  rect(0,0,width,height);
  //background(51);
  
  for (Boid boid : boids) {
    boid.show();
    boid.update();
    boid.loopBack();
    boid.applyAccel(boids);
    if (showViews) {
      boid.showViews();
    }
    if (showDetectLines) {
      boid.drawDetectionLines(boids);
    }
  }
  
  for (Predator pred : predators) {
    pred.show();
    pred.update();
    pred.loopBack();
  }
}

void mousePressed() {
  if (showViews) {
    showViews = false;
  } else {
    showViews = true;
  }
  if (showDetectLines) {
    showDetectLines = false;
  } else {
    showDetectLines = true;
  }
}
