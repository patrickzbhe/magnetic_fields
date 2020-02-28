
class Pole {
  float strength;
  int polarity;
  float x;
  float y;
  ArrayList<Float> times;
  float interval;
  boolean selected;
  color colour;
  
  Pole (float x, float y, float strength, int polarity){
    this.x = x;
    this.y = y;
    this.strength = strength;
    this.polarity = polarity;
    this.times = new ArrayList<Float>();
    this.interval = 0;
    this.selected = false;
    this.colour = color(255);
  }
  
  void resetPulse() {
    //make arrows restart
    this.times.clear();
    this.interval = 0;
  }
  
  void setXY(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void drawSelf() {
    fill(0);
    if (this.selected) {
      stroke(255,0,0);
    
    } else {
      stroke(this.colour);
      
    }
    
    ellipse(x,y,30,30);
    String n = "";
    if (this.polarity == -1) {
      //checking north south
      n = "S";
    } else {
      n = "N";
    }
    if (this.selected) {
      fill(255,0,0);
    
    } else {
      fill(this.colour);
      
    }
    textAlign(CENTER,CENTER);
    text(n, x, y);
  }
 
  
  float getB(float x, float y, float k) {
    //calculate pull magnitude between pole and a point given k
    float distance = pow(dist(this.x, this.y, x, y),2);
    float B =   this.polarity * k * (this.strength / distance);
    return B;
  }
  
  float getAngle(float x, float y) {
    //calculate angle between pole and point
    return atan2(y - this.y, x - this.x);
  }
  
  PVector getPull(float x, float y, float k) {
    //calculate pull from pole to point given field constant
    float B = getB(x ,y, k);
    float theta = getAngle(x, y);
    
    PVector pull = new PVector(B * cos(theta), B * sin(theta));
    
    return pull;
  }
  

}
