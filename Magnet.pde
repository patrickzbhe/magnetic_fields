
class Magnet {
  ArrayList<Pole> poles;
  float x;
  float y;
  float w;
  float h;
  boolean selected;
  float rotation;
  color colour;
  String cName;
  Magnet(float x, float y, float w, float h) {
    this.poles = new ArrayList<Pole>();
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.selected = false;
    this.rotation = 0;
    this.colour = color(255);
    this.cName = "White";
  }
  
  void addPole(float x, float y, float strength, int polarity) {
    //add new pole
    Pole p = new Pole(x, y, strength, polarity);
    this.poles.add(p);
  }
  
  void updatePoles(float dX, float dY) {
    //move poles by x and y
    this.x += dX;
    this.y += dY;
    for (int i = 0; i < this.poles.size(); i++) {
      this.poles.get(i).x += dX;
      this.poles.get(i).y += dY;
    }
  }
  
  void rotatePoles(float theta){
    //rotate poles from starting pos by theta
    PVector leftPole = new PVector(-1 * (w/2)+20,0);
    leftPole.rotate(theta);
    float bx = this.x  ;

    this.poles.get(0).setXY(x + leftPole.x, y + leftPole.y);
    
    PVector rightPole = new PVector( w/2 - 20,0);
    rightPole.rotate(theta);
    bx = this.x;
    this.poles.get(1).setXY(bx + rightPole.x, y + rightPole.y);
    this.rotation = theta;
    
  }
  
  void drawSelf() {
    noFill();
    if (this.selected) {
      //check if selected to colour either red or its own colour
      stroke(255,0,0);
    } else {
      stroke(this.colour);
    }

    translate(x,y);
    rotate(rotation);
    rect(-1 * w/2,-1 * h/2, w,h);
    
    rotate(-1 * rotation);
    translate(-1 * x, -1 * y);
  }
  
  void setStrength(float strength) {
    for (int i = 0; i < this.poles.size(); i++) {
      this.poles.get(i).strength = strength;
    }
  }
  
  float getStrength() {
    return this.poles.get(0).strength;
  }
  
  void select() {
    this.selected = true;
    for (int i = 0; i < this.poles.size(); i++) {
      this.poles.get(i).selected = true;
    }
  }
  
  void setColour(color c) {
    this.colour = c;
    for (int i = 0; i < this.poles.size(); i++) {
      this.poles.get(i).colour = c;
    }
  }
  
  void deselect() {
    this.selected = false;
    for (int i = 0; i < this.poles.size(); i++) {
      this.poles.get(i).selected = false;
    }
  }

}
