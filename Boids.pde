float viewAngle = 360;
int viewDistance = 100;
float mSpeed = 4.0;
float mForce = 1.0;

int numBoids = 50;

int edgeBuffer = -10;

boolean showViews = false;
boolean showDetectLines = false;

float separationFactor = 1;
float alignFactor = .5;
float cohesionFactor = 1;

Boid[] boids;

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
    
    sep.mult(separationFactor);
    coh.mult(cohesionFactor);
    align.mult(alignFactor);
    
    this.accel.add(sep);
    this.accel.add(coh);
    this.accel.add(align);
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
}

void setup() {
  size(760,500);
  
  background(51);
  
  frameRate(60);
  
  boids = new Boid[numBoids];
  for (int i = 0; i < numBoids; i++) {
    boids[i] = new Boid();
  }
   
  viewAngle = radians(viewAngle);
  
}

void draw() {
  background(51);
  
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
