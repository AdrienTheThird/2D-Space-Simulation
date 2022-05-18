

class CelBody {
  PVector acceleration; //aktuelle Beschleunigung
  PVector velocity; //aktuelle Geschwindigkeit
  PVector location; //aktuelle Position
  PVector forceE; //Gesammtkraft die auf den Körper wirkt
  float radius; //Radius des Körpers
  float mass; //Masse des Körpers
  int index; //Index des Körpers im Array
  int col = 1; //Farbe des Körpers (1=Aqua, 2=rot, 3=Gelb)
  boolean sel = false; //Ist der aktuelle Körper ausgewählt?
  boolean vis = true; //Sichtbarkeit/Existenz des Körpers (Soll der Körper berechnet & angezeigt werden)
  int collidable = 0; //Kann der Körper kollidieren? (kann kollidieren wenn < 1)
  
  float temp = 0; //temperature of the object
  float material = 0; //material of the object
  float habitlvl = 0; //how habitable is the object (0=not, 4=earth, 8=max)
  int type = 0; //type of celestial object (0=undetermined/brick, 1=star, 2=exoplanet, 3=moon)

  //Konstruktor mit X-Position, Y-Position, Größe, Masse, Index
  CelBody(float posX, float posY, float initVelX, float initVelY, float r, float m, int i) {
    forceE = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    velocity = new PVector(initVelX, initVelY); //startGeschwindigkeit übergeben
    location = new PVector(posX, posY);
    radius = r;
    mass = m;
    index = i;
  }


  //aktuelle Position berechnen
  void calcLocation() {
    if (vis) {
      acceleration = PVector.div(forceE, mass);
      acceleration.mult(timeStep/frameRate); //Geschwindigkeit der Simulation anpassen
      velocity.add(acceleration);
      location.add(velocity);
      forceE.mult(0);

      if (collidable > 0) {
        collidable -= 1;
      }
    }
  }

  //Körper auswählen mit Maustaste
  void select() {
    if (vis) {
      if (mousePressed && (mouseButton == LEFT)) {
        if (((mouseX>realX(location.x-radius)) && (mouseX<realX(location.x+radius)) ) && ( (mouseY>realY(location.y-radius)) && (mouseY<realY(location.y+radius)))) {
          for (int i=0; i<numObjects; i++) {
            body[i].sel = false;
          }
          sel = true;
        }
      }
    }
  }

  //Wenn aktueller Körper ausgewählt...
  void selected() {
    if (sel) {
      col = 2;
      selectedBody = index;
    } else {
      col = 1;
    }
  }

  //Körper anzeigen
  void display() {
    if (vis) {
      noStroke();
      if (col==1) {
        fill(#0A9396);
      } else if (col==2) {
        fill(#AE2012);
      } else if (col==3) {
        fill(#EE9B00);
      }

      ellipse(location.x, location.y, 2*radius, 2*radius);
    }
  }
}
