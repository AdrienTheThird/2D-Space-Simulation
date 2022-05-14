

PVector rightklickPos; //Position an der geklickt wurde

Boolean rightPress = false; //True wenn rechte Maustaste gedrückt
Boolean rightRelease = false; //True wenn rechte Maustaste losgelassen

int rightPressDuration = 5; //Länge der Dauer des Klicks


float newObjRadius; //Radius des neuen Objekts
PVector newObjVel; //Geschwindigkeit des neuen Objekts



void newObjects() {


  //neues Objekt mit Rechtsklick spawnen
  if (rightPress) { //Rechtklick gedrückt halten für Radius/Masse
    simActive = false;

    PVector radiusVector = new PVector(mouseX-rightklickPos.x, mouseY-rightklickPos.y);
    newObjRadius = radiusVector.mag();

    stroke(#001219);
    strokeWeight(3);
    ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2);


    noStroke();

    rightPressDuration++;
  }
  if (rightRelease) { //Rechtklick loslassen und ziehen für Geschwindigkeit
    simActive = false;

    newObjVel = new PVector(mouseX-rightklickPos.x, mouseY-rightklickPos.y);
    float newObjVelMag = newObjVel.mag() / camZoom;
    newObjVelMag /= 50;

    stroke(#FEFF2E);
    strokeWeight(3);
    line(rightklickPos.x, rightklickPos.y, mouseX, mouseY);
    ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2);
    
    fill(#8B8B8B);
    text(newObjVelMag, rightklickPos.x + newObjVel.x/1.9, rightklickPos.y + newObjVel.y/1.9);

    noStroke();

    rightPressDuration++;
  }
}





void addBody() {
  newObjVel.div(camZoom);
  newObjVel.div(50);
  newObjRadius /= camZoom;
  
  float newMass = newObjRadius;
  if (newObjRadius > 4) {
    body[numObjects] = new CelBody(newX(rightklickPos.x), newY(rightklickPos.y), newObjVel.x, newObjVel.y, newObjRadius, newMass, numObjects);
    numObjects++;
    println("addBody");
  }
}
