class Field {
  float k;
  float fWidth;
  float fHeight;
  ArrayList<Magnet> magnets;
  Magnet selected;
  Magnet clickSelected;
  float mx;
  float my;
  
  Field (float k, float fWidth, float fHeight) {
    this.k = k;
    this.fWidth = fWidth;
    this.fHeight = fHeight;
    this.magnets = new ArrayList<Magnet>();
    this.selected = null;
  }
  
  void addMagnet(Magnet m) {
    this.magnets.add(m);
  }
  
  void removeMagnet(Magnet m){
    for (int i = 0; i < this.magnets.size(); i++) {
      Magnet curr = this.magnets.get(i);
      if (curr == m) {
        this.magnets.remove(i);
      }
    }
  }
  
  void resetPulses() {
    for (int i = 0; i < this.magnets.size(); i++) {
      Magnet curr = this.magnets.get(i);
      for (int j = 0; j < curr.poles.size(); j++) {
        Pole cPole = curr.poles.get(j);
        cPole.resetPulse();
      }
    }
  }
  
  void sendLines(Pole p, float angleInc) {
    //start creating lines in a circle around the pole, each being close but not exactly on the pole
    float angle = 0;
    while (abs(angle) <= (2 * PI)-0.01) {
      PVector v = PVector.fromAngle(angle);
      drawFieldLine(p.x+v.x,p.y+v.y, p);
      angle += angleInc;
    }
  }
  
  void showPoles() {
    for (int i = 0; i < this.magnets.size(); i++) {
      Magnet curr = this.magnets.get(i);
      for (int j = 0; j < curr.poles.size(); j++) {
        Pole cPole = curr.poles.get(j);
        cPole.drawSelf();
      }
    }
  }
  
  void showMagnets() {
    for (int i = 0; i < this.magnets.size(); i++) {
      Magnet curr = this.magnets.get(i);
      curr.drawSelf();
    }
  }

  
  void showLines() {
    for (int i = 0; i < this.magnets.size(); i++) {
      Magnet curr = this.magnets.get(i);
      for (int j = 0; j < curr.poles.size(); j++) {
        Pole cPole = curr.poles.get(j);
        
        if (cPole.polarity == 1) {
          sendLines(cPole, PI/fldensity);
        }
      }
    }
  
  }
  
  PVector getTotalPull(float x, float y) {
    //get pull vector of point in space by adding force from all the poles
    PVector pull = new PVector(0,0);
    for (int i = 0; i < this.magnets.size(); i++) {
      Magnet curr = this.magnets.get(i);
      for (int j = 0; j < curr.poles.size(); j++) {
        pull.add(curr.poles.get(j).getPull(x,y,this.k));
      }
    }
   
    return pull;
  }
  
  void drawFieldLine(float x, float y, Pole P) {
    //draw field lines starting at a point off a pole
    //this is done by calculating the total pull at a point, 
    //moving in that direction, then repeating until a pole or 
    // max loop length has been reached
    float x1;
    float y1;
    PVector pull;
    int k = 0;
    boolean stop = true;

    if (P.selected) {
      stroke(255, 0, 0, alpha);
    } else {
      stroke(P.colour, alpha);
    }
    
    fill(0);
    
    float sDis = flaccuracy * 2;
    
    while (stop) {
      //stop when you get to a south pole or looped too many times
      pull = getTotalPull(x,y);
      pull.normalize();
      pull.mult(flaccuracy);
      
      x1 = x + pull.x;
      y1 = y + pull.y;

      for (int i = 0; i < this.magnets.size(); i++) {
        Magnet curr = this.magnets.get(i);
        for (int j = 0; j < curr.poles.size(); j++) {
          Pole cPole = curr.poles.get(j); 
          if (cPole.polarity == -1) {
            if (dist(cPole.x, cPole.y, x,y) < sDis) {
              stop = false;
            }
          }
        }
      }
      if (k > 1500) {
        //handle lines that never end at a pole or are too large
        break;
      }
      if (tToggle) {
        for(int i = 0; i < P.times.size(); i++) {
          //draw arrows
          if (k == int(P.times.get(i))) {
            t1.set(0,10);
            t2.set(-7,-7);
            t3.set(7,-7);
            float theta = pull.heading();
            t1.rotate(theta - PI/2);
            t2.rotate(theta - PI/2);
            t3.rotate(theta - PI/2);
            noFill();
            triangle(t1.x+x,t1.y+y,t2.x+x,t2.y+y,t3.x+x,t3.y+y);
          }
        }
      }
      //draw in direction of net pull
      line(x,y,x1,y1);
      x = x1;
      y = y1;
      k ++;
    }
    for(int i = 0; i < P.times.size(); i++) {
      P.times.set(i, new Float(P.times.get(i) + 0.2));
    }
    if (int(P.interval) == 100) {
      P.times.add(new Float(0));
      P.interval = 0;
    }
    if (P.times.size() > 100) {
      P.times.remove(0);
    }
    P.interval += 0.2;
 
  }
  
  void handleMousePressed() {
    //selects a clicked magnet (clickedSelected) and 
    //prevents a magnet from being unselected if dragged fast (selected) 
    if (this.selected != null) {
      this.selected.updatePoles(mouseX - mx, mouseY - my);
    } else {
      boolean found = false;
      for (int i = 0; i < this.magnets.size(); i++) {
        Magnet curr = this.magnets.get(i);
        if (insideBox(mouseX,mouseY,curr.x,curr.y,curr.w,curr.h)) {
          if (!found) {
            this.selected = curr;
            this.clickSelected = curr;
            curr.select();
            updateSliders(curr);
            found = true;
          } else {
            curr.deselect();
          }
          
        } else {
          curr.deselect();
        }
        
      }
      if (!found) {
        this.clickSelected = null;
      }
    }
  }
  
  void updateSliders(Magnet m) {
    //set slider values for selected sliders
    strengthslider.setValue(m.getStrength());
    angleslider.setValue(m.rotation);
    
    for (int i = 0; i < cOptions.length; i++) {
      if (m.cName.equals(cOptions[i])) {
        
        colourlist.setSelected(i);
      }
    }
  }
  
  void handleMagnetUi() {
    //only show ui when magnet is clicked
    boolean s = true;
    if (this.clickSelected != null) {
      s = true;
    } else {
      s = false;
    }
    strengthslider.setVisible(s);
    strengthlabel.setVisible(s);
    angleslider.setVisible(s);
    anglelabel.setVisible(s);
    colourlabel.setVisible(s);
    colourlist.setVisible(s);
    removebutton.setVisible(s);
    nothinglabel.setVisible(!s);
  }
  
  void run() {
    //put together everything to calculate lines and draw lines, poles, magnets and sets ui
    this.showLines();
    
    if (pToggle) {
      this.showPoles();
    }
    
    if (mToggle) {
      this.showMagnets();
    }
    
    if (mousePressed) {
      this.handleMousePressed();
    } else {
      this.selected = null;
    }


    handleMagnetUi();
    this.mx = mouseX;
    this.my = mouseY;
  
  
  }
}
