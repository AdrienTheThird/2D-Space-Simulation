

PVector rightklickPos; //Position an der geklickt wurde

Boolean rightPress = false; //True wenn rechte Maustaste gedrückt
Boolean rightRelease = false; //True wenn rechte Maustaste losgelassen
Boolean newOrbit = false; //True if new objekt is orbiting

Boolean newObjectActive = false;
int newObjectSequence = -1;

float newObjRadius; //Radius des neuen Objekts
PVector newObjVel; //Geschwindigkeit des neuen Objekts
PVector newOrbitSize; //distance of the orbiting object
float newOrbitDist; //distance of the orbiting object (magnitude of newOrbitSize)
PVector newOrbitPos; //position of the new orbiting object

//spawn new object (right mouse button)
void newObjects() {
  if (newObjectActive) {
    simActive = false;
    if (newObjectSequence == 0) { //save clicked pos, do once
      rightklickPos = new PVector(mouseX, mouseY);
      newObjectSequence = 1;
    } else if (newObjectSequence == 1) { //new mass/size
      newMass();
    } else if (newObjectSequence == 2) { //new vel
      newVel();
    } else if (newObjectSequence == 3) { //add object, reset
      addBody();
      newObjectSequence = -1;
      newObjectActive = false;
      simActive = true;
    }
  }


}


void newMass() {
  PVector radiusVector = new PVector(mouseX-rightklickPos.x, mouseY-rightklickPos.y); //calc new size
  newObjRadius = radiusVector.mag();

  stroke(#001219);
  strokeWeight(3);
  ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2); //show new size
}

void newVel() {
  //calc new velocity
  newObjVel = new PVector(mouseX-rightklickPos.x, mouseY-rightklickPos.y);
  float newObjVelMag = newObjVel.mag() / camZoom; //adjust to zoom
  newObjVelMag /= 50;
  
  stroke(#FEFF2E);
  strokeWeight(3);
  line(rightklickPos.x, rightklickPos.y, mouseX, mouseY); //show new velocity
  ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2); //show new size

  fill(#8B8B8B);
  text(newObjVelMag, rightklickPos.x + newObjVel.x/1.9, rightklickPos.y + newObjVel.y/1.9); //show new velocity
}



//new object orbiting around other object (not finished)
/*void orbitNewObject() {
 
 if (rightPress) { //Rechtklick gedrückt halten für Radius/Masse
 simActive = false;
 
/*PVector radiusVector = new PVector(mouseX-rightklickPos.x, mouseY-rightklickPos.y); //calc new size
 newObjRadius = radiusVector.mag();
 
 stroke(#001219);
 strokeWeight(3);
 ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2); //show new size
 
 //println("orbit");
 //noStroke();
 
 newOrbitSize = new PVector(mouseX-realX(body[selectedBody].location.x), mouseY-realY(body[selectedBody].location.y));
 newOrbitDist = newOrbitSize.mag() / camZoom;
 newOrbitPos = new PVector(mouseX, mouseY);
 
 stroke(#FEFF2E);
 strokeWeight(3);
 line(realX(body[selectedBody].location.x), realY(body[selectedBody].location.y), mouseX, mouseY); //show new orbit
 //ellipse(rightklickPos.x, rightklickPos.y, newObjRadius*2, newObjRadius*2); //show new size
 
 //fill(#8B8B8B);
 //text(newObjVelMag, rightklickPos.x + newObjVel.x/1.9, rightklickPos.y + newObjVel.y/1.9); //show new velocity
 
 //noStroke();
 
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
 
 //noStroke();
 
 }
 } */






void addBody() {
  //adjust size and velocity to zoom
  if (!newOrbit) {
    newObjVel.div(camZoom);
    newObjVel.div(50);
    newObjRadius /= camZoom;
  }

  float newMass = newObjRadius;
  //float newDist = abs(sqrt(sq(realX(newOrbitPos.x)-body[selectedBody].location.x) + sq(realX(newOrbitPos.y)-body[selectedBody].location.y)));

  /*if (newOrbit) {
   newObjVel = newOrbitSize;
   newObjVel.rotate(PI/2);
   newObjVel.setMag(sqrt((body[selectedBody].mass+newMass)*6.6743*pow(10, -2) / newDist));
   }*/


  if (newObjRadius > 4) {
    if (!newOrbit) {
      body[numObjects] = new CelBody(newX(rightklickPos.x), newY(rightklickPos.y), newObjVel.x, newObjVel.y, newObjRadius, newMass, numObjects);
    } else {
      float newDist = abs(sqrt(sq(realX(newOrbitPos.x)-body[selectedBody].location.x) + sq(realX(newOrbitPos.y)-body[selectedBody].location.y)));

      newObjVel = newOrbitSize;
      newObjVel.rotate(PI/2);
      newObjVel.setMag(sqrt((body[selectedBody].mass+newMass)*6.6743*pow(10, -2) / newDist));
      println("newOrbitVel: "+newObjVel);
      body[numObjects] = new CelBody(newX(newOrbitPos.x), newY(newOrbitPos.y), newObjVel.x, newObjVel.y, newObjRadius, newMass, numObjects);
    }
    numObjects++;

    println("addBody");
  }
}
