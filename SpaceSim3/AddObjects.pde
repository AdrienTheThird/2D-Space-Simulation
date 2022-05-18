

PVector rightklickPos; //Position an der geklickt wurde

Boolean rightPress = false; //True wenn rechte Maustaste gedrückt
Boolean rightRelease = false; //True wenn rechte Maustaste losgelassen
Boolean newOrbit = false; //True if new objekt is orbiting

int rightPressDuration = 5; //Länge der Dauer des Klicks


float newObjRadius; //Radius des neuen Objekts
PVector newObjVel; //Geschwindigkeit des neuen Objekts
PVector newOrbitSize; //distance of the orbiting object
float newOrbitDist; //distance of the orbiting object (magnitude of newOrbitSize)
PVector newOrbitPos; //position of the new orbiting object

//neues Objekt mit Rechtsklick spawnen
void newObjects() {
  if (newOrbit) {
    orbitNewObject();
  } else {
    normalNewObject();
  }
}

//normal new object
void normalNewObject() {

  if (rightPress) { //Rechtklick gedrückt halten für Radius/Masse
    simActive = false;

    PVector radiusVector = new PVector(mouseX-rightklickPos.x, mouseY-rightklickPos.y); //calc new size
    newObjRadius = radiusVector.mag();

    stroke(#001219);
    strokeWeight(3);
    ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2); //show new size

    //println("NOTorbit");
    noStroke();

    rightPressDuration++;
  }
  if (rightRelease) { //Rechtklick loslassen und ziehen für Geschwindigkeit
    simActive = false;
    //calc new velocity
    newObjVel = new PVector(mouseX-rightklickPos.x, mouseY-rightklickPos.y);
    float newObjVelMag = newObjVel.mag() / camZoom;
    newObjVelMag /= 50;

    stroke(#FEFF2E);
    strokeWeight(3);
    line(rightklickPos.x, rightklickPos.y, mouseX, mouseY); //show new velocity
    ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2); //show new size

    fill(#8B8B8B);
    text(newObjVelMag, rightklickPos.x + newObjVel.x/1.9, rightklickPos.y + newObjVel.y/1.9); //show new velocity

    noStroke();

    rightPressDuration++;
  }
}



//new object orbiting around other object
void orbitNewObject() {

  if (rightPress) { //Rechtklick gedrückt halten für Radius/Masse
    simActive = false;
    
    /*PVector radiusVector = new PVector(mouseX-rightklickPos.x, mouseY-rightklickPos.y); //calc new size
    newObjRadius = radiusVector.mag();

    stroke(#001219);
    strokeWeight(3);
    ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2); //show new size
    */
    //println("orbit");
    noStroke(); 
    
    newOrbitSize = new PVector(mouseX-realX(body[selectedBody].location.x), mouseY-realY(body[selectedBody].location.y));
    newOrbitDist = newOrbitSize.mag() / camZoom;
    newOrbitPos = new PVector(mouseX, mouseY);

    stroke(#FEFF2E);
    strokeWeight(3);
    line(realX(body[selectedBody].location.x), realY(body[selectedBody].location.y), mouseX, mouseY); //show new orbit
    //ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2); //show new size

    //fill(#8B8B8B);
    //text(newObjVelMag, rightklickPos.x + newObjVel.x/1.9, rightklickPos.y + newObjVel.y/1.9); //show new velocity

    noStroke();

    rightPressDuration++;
  }
  if (rightRelease) { //Rechtklick loslassen und ziehen für Geschwindigkeit
    simActive = false;
    //calc new velocity
    
    newObjRadius = 10;

    stroke(#FEFF2E);
    strokeWeight(3);
    //line(newOrbitSize.x, newOrbitSize.y, mouseX, mouseY); //show new velocity
    line(realX(body[selectedBody].location.x), realY(body[selectedBody].location.y), newOrbitPos.x, newOrbitPos.y); //show new orbit
    ellipse(newOrbitPos.x, newOrbitPos.y, newObjRadius*2, newObjRadius*2); //show new size

    //fill(#8B8B8B);
    //text(newObjVelMag, rightklickPos.x + newObjVel.x/1.9, rightklickPos.y + newObjVel.y/1.9); //show new velocity

    noStroke();

    rightPressDuration++;
  }
}






void addBody() {
  //adjust size and velocity to zoom
  newObjVel.div(camZoom);
  newObjVel.div(50);
  newObjRadius /= camZoom;
  
  float newMass = newObjRadius;
  
  if (newOrbit) {
    newObjVel = newOrbitSize;
    //newObjVel.setMag(sqrt(body[selectedBody].mass+newMass * ));
  }
  
  
  if (newObjRadius > 4) {
    body[numObjects] = new CelBody(newX(rightklickPos.x), newY(rightklickPos.y), newObjVel.x, newObjVel.y, newObjRadius, newMass, numObjects);
    numObjects++;
    println("addBody");
  }
}
