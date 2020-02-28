//Patrick He
//https://github.com/patrickzebinghe/magnetic_fields

import g4p_controls.*;

float fldensity;
float flaccuracy;
float k;
Field mField;
boolean pToggle;
boolean tToggle;
boolean mToggle;
boolean gToggle;
String[] cOptions;

PVector t1 = new PVector(0,10);
PVector t2 = new PVector(-7,-7);
PVector t3 = new PVector(7,-7);
float alpha;

public void setup() {
  size(1000, 800);
  background(0);
  frameRate(60);
  alpha = 255;
  //button/slider default values
  pToggle = true;
  tToggle = true;
  mToggle = true;
  gToggle = false;
  fldensity = 5;
  flaccuracy = 5;
  
  //colours in order
  cOptions = new String[]{"White", "Green", "Blue", "Purple", "Yellow", "Pink", "Teal"};

  createGUI();
  
  //create field
  mField = new Field(0.001, width, height);

  mField.mx = mouseX;
  mField.my = mouseY;
}

public void draw() {
  background(0);
  
  //glow effect by drawing everything thick and blurring it
  if (gToggle) {
    strokeWeight(6);
    mField.run();
    filter(BLUR, 5);
  }
  
  //draw the lines and magnets and poles normally
  strokeWeight(1);
  mField.run();
  fill(255);
  text(int(frameRate), 20, 10);
}
