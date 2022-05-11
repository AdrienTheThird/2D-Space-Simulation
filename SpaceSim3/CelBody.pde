

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

  //Konstruktor mit X-Position, Y-Position, Größe, Masse, Index
  CelBody(float posX, float posY, float initVelX, float initVelY,  float r, float m, int i) {
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



//alle Gravitationskräfte die auf alle Objekte wirken berechnen
void calcGravityE() {
  numObjectsReal = 0;
  for (int i=0; i<numObjects; i++) {
    for (int n=i+1; n<numObjects; n++) {
      if (body[i].vis && body[n].vis) { //wenn beide Körper vorhanden

        PVector forceTmp = new PVector(0, 0); //temporäre Kraft

        forceTmp = PVector.sub(body[i].location, body[n].location); //Richtung der Kraft
        float tmpMag = forceTmp.mag(); //Distanz zwischen den beiden Objekten

        if (tmpMag > 2) {
          forceTmp.setMag(6.6743*pow(10, -2) * (body[i].mass*body[n].mass) / sq(tmpMag) ); //Länge der Kraft
          body[i].forceE.add(forceTmp.mult(-1)); //Kraft zur Gesammtkraft von Objekt1 hinzufügen
          body[n].forceE.add(forceTmp.mult(-1)); //Kraft zur Gesanntkraft Objekt2 hinzufügen
        }

        //auf Kollision prüfen && body[i].collidable < 20 && body[n].collidable < 20
        if (tmpMag < (body[i].radius + body[n].radius) ) {
          collision(i, n);
        }
      }
    }
    if (body[i].vis) {
      numObjectsReal += 1;
    }
  }
  numObjects += addedObjects; //Objekte die durch Kollisionen dazugekommen sind zur gesammtzahl hinzufügen
  addedObjects = 0;
}



void addBody() {
  float newMass = rightPressDuration;
  float newRadius = rightPressDuration;
  body[numObjects] = new CelBody(newX(mouseX), newY(mouseY), 0, 2, newRadius, newMass, numObjects);
  numObjects++;
  println("addBody");
}
